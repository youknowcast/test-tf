resource "aws_lb" "example" {
  name = "example"
  load_balancer_type = "application"
  internal = false
  idle_timeout = 60
  enable_deletion_protection = true

  subnets = [
		aws_subnet.example_public.id
	]

	access_logs {
	  bucket = aws_s3_bucket.alb_log.id
	  enabled = true
	}

	security_groups = [
		aws_security_group.example.id
	]
}

resource "aws_lb_listener" "http" {
	load_balancer_arn = aws_lb.example.arn
	port = "80"
	protocol = "HTTP"

	default_action {
	  type = "fixed-response"
		fixed_response {
		  content_type = "text/plain"
		  message_body = "これは [HTTP] です"
		  status_code = "200"
		}	
	}
}

output "alb_dns_name" {
  value = aws_lb.example.dns_name
}