#!/bin/bash

GOOS=linux go build -o main main.go
zip login.zip main
rm -rf main
