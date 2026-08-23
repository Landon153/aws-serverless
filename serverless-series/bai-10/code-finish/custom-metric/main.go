package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/cloudwatch"
	"github.com/aws/aws-sdk-go-v2/service/cloudwatch/types"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
)

type Book struct {
	Id     string `json:"id"`
	Name   string `json:"name"`
	Author string `json:"author"`
	Image  string `json:"image"`
}

func list(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Body:       "Error while retrieving AWS credentials",
		}, nil
	}

	cw := cloudwatch.NewFromConfig(cfg)

	svc := dynamodb.NewFromConfig(cfg)
	out, err := svc.Scan(context.TODO(), &dynamodb.ScanInput{
		TableName: aws.String("book"),
	})
	if err != nil {
		log.Println("err: " + err.Error())

		input := &cloudwatch.PutMetricDataInput{
			Namespace: aws.String("Lambda"),
			MetricData: []types.MetricDatum{
				{
					MetricName: aws.String("FailedConnectToDynamoDB"),
					Unit:       types.StandardUnitSeconds,
					Value:      aws.Float64(1.0),
					Dimensions: []types.Dimension{
						{
							Name:  aws.String("env"),
							Value: aws.String("staging"),
						},
					},
				},
			},
		}
		cw.PutMetricData(context.TODO(), input)

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

	res, _ := json.Marshal(books)
	return events.APIGatewayProxyResponse{
		StatusCode: 200,
		Headers: map[string]string{
			"Content-Type":                "application/json",
			"Access-Control-Allow-Origin": "*",
		},
		Body: string(res),
	}, nil
}

func main() {
	lambda.Start(list)
}
