# Input variable definitions

variable "teamname" {
  description = "Name of the s3 bucket. Must be unique."
  type        = string
}

variable "env" {
  description = "environment"
}
variable "stackname" {

}
variable "instancetype" {
  default = "t2.micro"
}
