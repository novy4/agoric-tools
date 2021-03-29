/*
variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key"
}
variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Key"
}
variable "AWS_SSH_KEY_NAME" {
  description = "Name of the SSH keypair to use in AWS."
}
*/
variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
}
variable "instance_type" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
}
variable "ssh_key" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
}
variable "user" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
}
variable "vpc_name" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
}
variable "region" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
}
variable "profile" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
}