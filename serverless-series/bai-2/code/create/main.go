package main

import (
	"encoding/json"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

type Books struct {
	Id     int    `json:"id"`
	Name   string `json:"name"`
	Author string `json:"author"`
}

var books = []Books{
	{Id: 1, Name: "NodeJS", Author: "NodeJS"},
	{Id: 2, Name: "Golang", Author: "Golang"},
}

func create(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var book Books
	err := json.Unmarshal([]byte(req.Body), &book)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       err.Error(),
		}, nil
	}

	books = append(books, book)

	res, err := json.Marshal(&books)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 500,
			Body:       err.Error(),
		}, nil
	}

	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(res),
	}, nil
}

func main() {
	lambda.Start(create)
}
