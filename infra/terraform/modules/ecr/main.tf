resource "aws_ecr_repository" "this" {
  for_each = var.ecr_repositories

  name = each.value

  image_tag_mutability = "MUTABLE"

  tags = {
    Name = each.value
  }
}
