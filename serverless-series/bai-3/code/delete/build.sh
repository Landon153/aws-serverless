#!/bin/bash

GOOS=linux go build -o main main.go
zip delete.zip main
rm -rf main
