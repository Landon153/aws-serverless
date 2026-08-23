#!/bin/bash

GOOS=linux go build -o hello main.go
zip main.zip hello
rm -rf main
