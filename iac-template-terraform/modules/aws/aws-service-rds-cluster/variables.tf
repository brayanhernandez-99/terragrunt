variable  "cluster_config" {
  description                   = "Modelo de creacion de RDS con cluster o sin cluster y demas configuraciones de las instancias"
  type                          = object({ //ESTRUCTURA DE CONFIGURACIÓN DEL CLUSTER
    engine                      = string
    engine_version              = string
    cluster_identifier          = string // NOMBRE PARA EL CLUSTER
    database_name               = string
    subnet_group                = string
    security_groups             = list(string)
    master_credentials          = object({
      username                  = string
    })

    backup_retention_period     = number
    preferred_backup_window     = string
    avaliability_zones          = list(string) //ZONAS VALIDAS

    multi_az_config             = object({ // CONFIGURACIÓN DEL MULTI AZ EN CASO DE ACTIVARSE
      db_cluster_instance_class = string
      storage_type              = string
      allocated_storage         = number
      iops                      = number
    })

    serverless_v2_config        = optional(object({ // SERVERLESS CONFIGURATION
      min_capacity              = number //Capacidad minima
      max_capacity              = number //Capacidad maxima
    }))

    storage_encrypted           = bool //ENCRYPTION
  })
}

variable "instances_config" {
  description                   = "Listas de las instancias para crear dentro del cluster"
  type                          = list(object({
    instance_identifier         = string // NOMBRE DE LA INSTANCIA
    instance_class              = string
    publicly_accessbile         = bool
    custom_iam_instance_profile = string
    availability_zone           = string
    apply_inmediatly            = bool
    
  }))
  default                       = null
}