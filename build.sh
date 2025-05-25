#!/bin/bash
set -e

echo "Building Go app..."
cd app
GOOS=linux GOARCH=amd64 go build -o ../my-app main.go
echo "✅ Build complete"
