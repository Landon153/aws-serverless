#!/bin/bash

GOOS=linux go build -o main main.go
zip update.zip main
rm -rf main
