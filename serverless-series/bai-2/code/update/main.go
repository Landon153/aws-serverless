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

func update(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var book Books
	err := json.Unmarshal([]byte(req.Body), &book)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       err.Error(),
		}, nil
	}

	for _, b := range books {
		if b.Id == book.Id {
			b.Name = book.Name
			b.Author = book.Author
			break
		}
	}

	res, _ := json.Marshal(&books)
	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(res),
	}, nil
}

func main() {
	lambda.Start(update)
}
