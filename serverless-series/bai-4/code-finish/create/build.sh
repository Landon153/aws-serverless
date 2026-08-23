#!/bin/bash

GOOS=linux go build -o main main.go
zip create.zip main
rm -rf main
