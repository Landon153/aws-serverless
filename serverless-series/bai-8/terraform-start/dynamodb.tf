resource "aws_dynamodb_table" "books" {
  name           = "books"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "items" {
  table_name = aws_dynamodb_table.books.name
  hash_key   = aws_dynamodb_table.books.hash_key
  item       = file("source/books.json")
}
