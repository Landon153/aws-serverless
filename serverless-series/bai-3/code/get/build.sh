#!/bin/bash

GOOS=linux go build -o main main.go
zip get.zip main
rm -rf main
