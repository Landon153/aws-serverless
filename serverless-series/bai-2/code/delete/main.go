package main

import (
	"encoding/json"
	"strconv"

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

func delete(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	id, err := strconv.Atoi(req.PathParameters["id"])
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       err.Error(),
		}, nil
	}

	index := -1
	for i, v := range books {
		if v.Id == id {
			index = i
			break
		}
	}

	if index == -1 {
		return events.APIGatewayProxyResponse{
			StatusCode: 404,
			Body:       "Not found!",
		}, nil
	}

	books := append(books[:index], books[index+1:]...)
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
	lambda.Start(delete)
}
