package main

import (
	"context"
	"encoding/json"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
)

type Book struct {
	Id     string `json:"id"`
	Name   string `json:"name"`
	Author string `json:"author"`
}

func create(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var book Book
	err := json.Unmarshal([]byte(req.Body), &book)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: 400,
			Body:       err.Error(),
		}, nil
	}

	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error while retrieving AWS credentials",
		}, nil
	}

	svc := dynamodb.NewFromConfig(cfg)
	newBook, err := svc.PutItem(context.TODO(), &dynamodb.PutItemInput{
		TableName: aws.String("books"),
		Item: map[string]types.AttributeValue{
			"id":     &types.AttributeValueMemberS{Value: book.Id},
			"name":   &types.AttributeValueMemberS{Value: book.Name},
			"author": &types.AttributeValueMemberS{Value: book.Author},
		},
		ReturnValues: types.ReturnValueAllOld,
	})
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       err.Error(),
		}, nil
	}

	res, _ := json.Marshal(newBook)
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
