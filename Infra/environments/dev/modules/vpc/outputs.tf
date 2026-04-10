output "vpc_name" {
  value = aws_vpc.this.tags["Name"]
}

output "public_subnet_id"{
  value = [for s in aws_subnet.public : s.id]
}

output "private_subnet_id"{
  value = [for s in aws_subnet.private : s.id]
}

output "public_subnet_cidr" {
  value = [for s in aws_subnet.public : s.cidr_block]
}

output "private_subnet_cidr" {
  value = [for s in aws_subnet.private : s.cidr_block]
}

output "vpc_id" {
  value = aws_vpc.this.id
}