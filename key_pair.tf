# for ec2 ssh
# ref: https://tech.teshiblog.com/aws/terraform/terraform-create-ec2-keypair/
resource "aws_key_pair" "youknow_key_pair" {
  key_name = var.youknow_key_name
  public_key = var.youknow_pub_key
}
