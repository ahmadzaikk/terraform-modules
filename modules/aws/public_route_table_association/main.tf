resource "aws_route_table_association" "public" {
  # count = local.public_count

  subnet_id      = var.subnet_id
  route_table_id = var.route_table_id


  # depends_on = [
  #   aws_subnet.public,
  #   aws_route_table.public,
  # ]
}