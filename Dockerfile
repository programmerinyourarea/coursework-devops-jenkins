FROM golang:1.20-alpine AS builder

WORKDIR /app

COPY ./app .

RUN GO111MODULE=off go build -o main

FROM alpine:latest

WORKDIR /app

COPY --from=builder /app/main .

EXPOSE 4444

CMD ["./main"]
