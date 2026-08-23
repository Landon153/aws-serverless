package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/aws/aws-sdk-go-v2/service/s3"
	"github.com/grokify/go-awslambda"
)

type Book struct {
	Id     string `json:"id"`
	Name   string `json:"name"`
	Author string `json:"author"`
	Image  string `json:"image"`
}

func Upload(request events.APIGatewayProxyRequest, cfg aws.Config) (image string, err error) {
	client := s3.NewFromConfig(cfg)
	r, err := awslambda.NewReaderMultipart(request)
	if err != nil {
		return
	}

	part, err := r.NextPart()
	if err != nil {
		return
	}

	content, err := ioutil.ReadAll(part)
	if err != nil {
		return
	}

	bucket := "serverless-series-upload"
	filename := part.FileName()

	data := &s3.PutObjectInput{
		Bucket: &bucket,
		Key:    &filename,
		Body:   bytes.NewReader(content),
	}

	_, err = client.PutObject(context.TODO(), data)
	if err != nil {
		return
	}

	image = fmt.Sprintf("https://%s.s3.%s.amazonaws.com/%s", bucket, "us-west-2", filename)

	return
}

func create(req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Headers: map[string]string{
				"Content-Type":                "application/json",
				"Access-Control-Allow-Origin": "*",
			},
			Body: "Error while retrieving AWS credentials",
		}, nil
	}

	image, err := Upload(req, cfg)
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Headers: map[string]string{
				"Content-Type":                "application/json",
				"Access-Control-Allow-Origin": "*",
			},
			Body: err.Error(),
		}, nil
	}

	r, _ := awslambda.NewReaderMultipart(req)
	form, _ := r.ReadForm(1024)
	svc := dynamodb.NewFromConfig(cfg)
	data, err := svc.PutItem(context.TODO(), &dynamodb.PutItemInput{
		TableName: aws.String("books"),
		Item: map[string]types.AttributeValue{
			"id":     &types.AttributeValueMemberS{Value: form.Value["id"][0]},
			"name":   &types.AttributeValueMemberS{Value: form.Value["name"][0]},
			"author": &types.AttributeValueMemberS{Value: form.Value["author"][0]},
			"image":  &types.AttributeValueMemberS{Value: image},
		},
		ReturnValues: types.ReturnValueAllOld,
	})
	if err != nil {
		return events.APIGatewayProxyResponse{
			StatusCode: http.StatusInternalServerError,
			Headers: map[string]string{
				"Content-Type":                "application/json",
				"Access-Control-Allow-Origin": "*",
			},
			Body: err.Error(),
		}, nil
	}

	res, _ := json.Marshal(data)
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
	lambda.Start(create)
}
