FROM golang:1.20-alpine AS builder

WORKDIR /app

COPY . .

# Disable Go modules and build with GOPATH mode
RUN GO111MODULE=off go build -o main main.go

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/main .

EXPOSE 4444

CMD ["./main"]
