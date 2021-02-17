
  //source                = "Azure/aci/azurerm"
  environment           = "dev"
  resource_group_name   = "rockstars"
  location              = "westeurope"
  container_group_name  = "containergroup-rockstars"
  dns_name_label        = "rockstars-example"
  os_type               = "linux"
  image_name            = "nginxdemos/hello"

  container_name        = "nginx-hello"
  cpu_core_number       = "1"
  memory_size           = "0.8"
  port_number           = "80"