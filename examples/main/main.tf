locals {
  name_resource = format("%s-%s-%s-%s-%s", var.name_company, var.name_project, var.name_environment, module.azure_region.location_short, var.name_component)
}

module "azure_region" {
  #checkov:skip=CKV_TF_1:External module
  source  = "claranet/regions/azurerm"
  version = "7.1.1"

  azure_region = var.azure_region
}

resource "azurerm_resource_group" "this" {
  name     = local.name_resource
  location = var.azure_region

  tags = var.resource_tags
}


module "cdn_frontdoor_stacks" {
  #checkov:skip=CKV_TF_1:External module
  #checkov:skip=CKV_TF_2:External module
  source = "git::https://github.com/Ensono/terraform-azurerm-cdn-frontdoor-stacks?ref=feature/7298-afd"

  name_resource_group        = azurerm_resource_group.this.name
  name_cdn_frontdoor_profile = replace(local.name_resource, module.azure_region.location_short, "gbl")
  afd_base_configuration     = var.afd_base_configuration
  enable_debug_output        = var.enable_debug_output
}
