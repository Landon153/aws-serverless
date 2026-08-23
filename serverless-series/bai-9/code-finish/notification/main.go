package main

import (
	"context"
	"crypto/tls"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"

	mail "github.com/xhit/go-simple-mail/v2"
)

type Detail struct {
	Pipeline string `json:"pipeline"`
	State    string `json:"state"`
}

type Message struct {
	Time   time.Time `json:"time"`
	Detail Detail    `json:"detail"`
}

const html = `
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
	<p>Codepipeline %s is %s at %s</p>
</body>
`

func handler(ctx context.Context, snsEvent events.SNSEvent) {
	server := mail.NewSMTPClient()
	server.Host = "smtp.yandex.com"
	server.Port = 465
	server.Username = os.Getenv("MAIL_USERNAME")
	server.Password = os.Getenv("MAIL_PASSWORD")
	server.Encryption = mail.EncryptionSTARTTLS
	server.TLSConfig = &tls.Config{InsecureSkipVerify: true}

	smtpClient, err := server.Connect()
	if err != nil {
		log.Fatal(err)
	}

	// Create email
	email := mail.NewMSG()
	email.SetFrom(fmt.Sprintf("From Me <%s>", os.Getenv("MAIL_USERNAME")))
	email.AddTo(os.Getenv("MAIL_TO"))
	email.SetSubject("Codepipeline Notification")

	for _, record := range snsEvent.Records {
		snsRecord := record.SNS
		fmt.Printf("[%s %s] Message = %s \n", record.EventSource, snsRecord.Timestamp, snsRecord.Message)
		message := &Message{}
		json.Unmarshal([]byte(snsRecord.Message), message)

		email.SetBody(mail.TextHTML, fmt.Sprintf(html, message.Detail.Pipeline, message.Detail.State, message.Time))

		err = email.Send(smtpClient)
		if err != nil {
			log.Fatal(err)
		}
	}
}

func main() {
	lambda.Start(handler)
}
