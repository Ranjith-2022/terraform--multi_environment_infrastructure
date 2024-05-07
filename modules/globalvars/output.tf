# Default tags
output "default_tags" {
  value = {
    "Owner" = "Ranjith"
    "App"   = "Web"
  }
}

# Prefix to identify resources
output "prefix" {
  value     = "project"
}