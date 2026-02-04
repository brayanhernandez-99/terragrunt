variable "origin_id" {
  description = "ID del origen que se utilizará para CloudFront"
  type        = string
}

variable "origin_domain_name" {
  description = "El nombre de dominio del origen para CloudFront (puede ser un bucket S3 u otro origen)"
  type        = string
}

variable "comment" {
  description = "Comentario opcional para la distribución de CloudFront"
  type        = string
  default     = "Distribución de CloudFront"
}

variable "default_root_object" {
  description = "El objeto raíz predeterminado para CloudFront"
  type        = string
  default     = "index.html"
}

variable "allowed_methods" {
  description = "Métodos HTTP permitidos para las solicitudes a CloudFront"
  type        = list(string)
}

variable "cached_methods" {
  description = "Métodos HTTP que se almacenarán en caché"
  type        = list(string)
}

variable "custom_cache_policy_id" {
  description = "ID de la custom cache policy de CloudFront"
  type        = string
}

variable "query_string" {
  description = "Determina si CloudFront debe reenviar los parámetros de consulta al origen"
  type        = bool
  default     = false
}

variable "compress" {
  description = "Habilita la compresión automática de respuestas en CloudFront"
  type        = bool
  default     = false
}

variable "cookies_forward" {
  description = "Determina cómo se deben reenviar las cookies al origen"
  type        = string # Opciones: "none", "all", "whitelist"
}

variable "viewer_protocol_policy" {
  description = "Define cómo CloudFront maneja los protocolos de las solicitudes de los usuarios (HTTP/HTTPS)"
  type        = string # Opciones: "redirect-to-https", "allow-all", "https-only"
}

variable "price_class" {
  description = "Clase de precio para CloudFront"
  type        = string
}

variable "aws_cloudfront_tags" {
  description = "Un mapa de etiquetas (tags) para CloudFront"
  type        = map(string)
}

variable "custom_error_pages" {
  description = "Configuración de las páginas de error personalizadas para CloudFront"
  type = map(object({
    error_code            = number
    response_code         = number
    response_page_path    = string
    error_caching_min_ttl = number
  }))
  default = {

  }
}

variable "geo_restriction_type" {
  description = "Método para restringir la distribución de contenido por país: none, whitelist, or blacklist"
  type        = string
  default     = "none"
}

variable "geo_restriction_countries" {
  description = "Lista de códigos de país (ISO 3166-1 alpha-2) para whitelist o blacklist en restricciones geográficas"
  type        = list(string)
  default     = [] # Lista vacía por defecto, solo usada si restriction_type no es 'none'
}

variable "function_associations" {
  description = "Configuración de las asociaciones de funciones para CloudFront"
  type = map(object({
    event_type   = string
    function_arn = string
  }))
  default = {

  }
}

variable "oac_signing_behavior" {
  description = "Define el comportamiento de firma para el Control de Acceso de Origen (OAC). Valores posibles: 'always' (siempre firma las solicitudes), 'never' (nunca firma las solicitudes), o 'no-override' (usa la configuración del origen)."
  type        = string
  default     = "always"
}

variable "oac_signing_protocol" {
  description = "Especifica el protocolo de firma utilizado por el Control de Acceso de Origen (OAC). Para un bucket S3, el valor debe ser 'sigv4' (Signature Version 4), que es el protocolo estándar para solicitudes seguras."
  type        = string
  default     = "sigv4"
}

variable "alternate_domain_names" {
  description = "Lista de nombres de dominio alternativos (CNAMEs)"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ARN del certificado SSL en ACM"
  type        = string
}
