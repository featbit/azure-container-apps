resource "azurerm_log_analytics_workspace" "featbit" {
  name                = "acctest-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "featbit" {
  name                       = var.container_apps_environment
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.featbit.id
  infrastructure_subnet_id   = var.subnet_aca_id
}

resource "azurerm_container_app" "da_server" {
  name                         = var.container_name.da_server
  container_app_environment_id = azurerm_container_app_environment.featbit.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  ingress {
    allow_insecure_connections = true
    target_port                = 80
    external_enabled           = false
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    min_replicas = 1
    max_replicas = 3

    container {
      name   = var.container_name.da_server
      image  = "docker.io/featbit/featbit-data-analytics-server:latest"
      cpu    = 0.75
      memory = "1.5Gi"
      env {
        name  = "REDIS_URL"
        value = format("rediss://default:%s@%s:%s", var.redis.primary_access_key, var.redis.hostname, var.redis.ssl_port)
      }
      env {
        name  = "MONGO_URI"
        value = var.mongodb_connection_str
      }
      env {
        name  = "MONGO_INITDB_DATABASE"
        value = var.mongodb_dbname
      }
      env {
        name  = "MONGO_HOST"
        value = "mongodb"
      }
      env {
        name  = "CHECK_DB_LIVNESS"
        value = false
      }
      env {
        name  = "mongodb_primary_key"
        value = var.mongodb_primary_key
      }
      env {
        name  = "mongodb_primary_sql_connection_string"
        value = var.mongodb_primary_sql_connection_string
      }
    }
  }
}

data "azurerm_container_app" "da_server" {
  name                = azurerm_container_app.da_server.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_container_app" "api_server" {
  name                         = var.container_name.api_server
  container_app_environment_id = azurerm_container_app_environment.featbit.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  ingress {
    allow_insecure_connections = true
    target_port                = 5000
    external_enabled           = true
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    min_replicas = 1
    max_replicas = 3

    container {
      name   = var.container_name.api_server
      image  = "docker.io/featbit/featbit-api-server:latest"
      cpu    = 0.75
      memory = "1.5Gi"
      env {
        name  = "MongoDb__ConnectionString"
        value = var.mongodb_connection_str
      }
      env {
        name  = "MongoDb__Database"
        value = var.mongodb_dbname
      }
      env {
        name  = "Redis__ConnectionString"
        value = var.redis.primary_connection_string
      }
      env {
        name  = "OLAP__ServiceHost"
        value = format("http://%s", azurerm_container_app.da_server.name)
      }
    }
  }

  depends_on = [
    azurerm_container_app.da_server
  ]
}


resource "azurerm_container_app" "eval_server" {
  name                         = var.container_name.eval_server
  container_app_environment_id = azurerm_container_app_environment.featbit.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 3

    container {
      name   = var.container_name.eval_server
      image  = "docker.io/featbit/featbit-evaluation-server:latest"
      cpu    = 0.75
      memory = "1.5Gi"
      env {
        name  = "MongoDb__ConnectionString"
        value = var.mongodb_connection_str
      }
      env {
        name  = "MongoDb__Database"
        value = var.mongodb_dbname
      }
      env {
        name  = "Redis__ConnectionString"
        value = var.redis.primary_connection_string
      }
    }
  }

  ingress {
    allow_insecure_connections = true
    target_port                = 5100
    external_enabled           = true
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  depends_on = [
    azurerm_container_app.api_server
  ]
}

data "azurerm_container_app" "api_server" {
  name                = azurerm_container_app.api_server.name
  resource_group_name = var.resource_group_name
}

data "azurerm_container_app" "eval_server" {
  name                = azurerm_container_app.eval_server.name
  resource_group_name = var.resource_group_name
}


resource "azurerm_container_app" "ui" {
  name                         = var.container_name.ui
  container_app_environment_id = azurerm_container_app_environment.featbit.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  ingress {
    allow_insecure_connections = false
    target_port                = 80
    external_enabled           = true
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }

  template {
    min_replicas = 1
    max_replicas = 3

    container {
      name   = var.container_name.ui
      image  = "featbit/featbit-ui:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "API_URL"
        value = format("https://%s", data.azurerm_container_app.api_server.ingress[0].fqdn)
      }
      env {
        name  = "DEMO_URL"
        value = "https://featbit-samples.vercel.app"
      }
      env {
        name  = "EVALUATION_URL"
        value = format("https://%s", data.azurerm_container_app.eval_server.ingress[0].fqdn)
      }
    }
  }

  depends_on = [
    azurerm_container_app.api_server,
    azurerm_container_app.eval_server
  ]
}
