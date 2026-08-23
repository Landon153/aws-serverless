#!/bin/bash

GOOS=linux go build -o main main.go
zip notification.zip main
rm -rf main
