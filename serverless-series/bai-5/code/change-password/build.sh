#!/bin/bash

GOOS=linux go build -o main main.go
zip change-password.zip main
rm -rf main
