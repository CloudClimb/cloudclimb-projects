output "vpc_id" {
    description = "The ID of the VPC"
    value       = aws_vpc.main.id
}

output "internet_gateway_id" {
    description = "The ID of the Internet Gateway"
    value       = aws_internet_gateway.main.id
}

output "public_route_table_id" {
    description = "The ID of the public route table"
    value       = aws_route_table.public.id
}

output "private_route_table_id" {
    description = "The ID of the private route table"
    value       = aws_route_table.private.id
}   

output "data_security_group_id" {
    description = "The ID of the data security group"
    value       = aws_security_group.data.id
}

output "app_security_group_id" {
    description = "The ID of the app security group"
    value       = aws_security_group.app.id
}

output "subnet_ids" {
    description = "The IDs of the subnets"
    value       = { for name, subnet in aws_subnet.subnet : name => subnet.id }

}
