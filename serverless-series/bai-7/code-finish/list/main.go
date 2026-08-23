package main

import (
	"context"
	"encoding/json"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

type Book struct {
	Id     string `json:"id"`
	Name   string `json:"name"`
	Author string `json:"author"`
}

type Res struct {
	Rows  []Book `json:"rows"`
	Total int    `json:"total"`
}

func list(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error while retrieving AWS credentials",
		}, nil
	}

	svc := dynamodb.NewFromConfig(cfg)
	out, err := svc.Scan(context.TODO(), &dynamodb.ScanInput{
		TableName: aws.String("books"),
	})
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       err.Error(),
		}, nil
	}

	books := []Book{}
	err = attributevalue.UnmarshalListOfMaps(out.Items, &books)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error while Unmarshal books",
		}, nil
	}

	total := len(books)
	res := Res{Rows: books, Total: total}
	r, _ := json.Marshal(res)
	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type": "application/json",
		},
		Body: string(r),
	}, nil
}

func main() {
	lambda.Start(list)
}
