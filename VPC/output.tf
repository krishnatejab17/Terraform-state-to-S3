output "web_instance_public_ip" {
  value = aws_instance.web.public_ip
}   
output "app_instance_private_ip" {
  value = aws_instance.app.private_ip
}
output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnet_id" {
  value = aws_subnet.public.id
}
output "private_subnet_id" {
  value = aws_subnet.private.id
}
output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
output "internet_gateway_id" {
  value = aws_internet_gateway.igw.id
}
output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}
output "private_route_table_id" {
  value = aws_route_table.private_rt.id
}
output "web_security_group_id" {
  value = aws_security_group.web_sg.id
}
output "app_security_group_id" {
  value = aws_security_group.app_sg.id
}
output "web_instance_id" {
  value = aws_instance.web.id
}
output "app_instance_id" {
  value = aws_instance.app.id
}