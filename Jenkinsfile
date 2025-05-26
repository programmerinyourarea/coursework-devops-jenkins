pipeline {
    agent any

    environment {
        TARGET_HOST = "laborant@docker"
        DOCKER_IMAGE = "ttl.sh/programmerinyourarea/myapp:2h"
        SSH_CREDENTIALS_ID = 'docker_deploy'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Binary') {
    steps {
        dir('app') {
            docker.image('golang:1.20-alpine').inside {
                sh 'go build -o ../main main.go'
            }
        }
    }
}

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${DOCKER_IMAGE} .
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                sh """
                docker push ${DOCKER_IMAGE}
                """
            }
        }

        stage('Deploy to Docker VM') {
            steps {
                sshagent([SSH_CREDENTIALS_ID]) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${TARGET_HOST} '
                        docker pull ${DOCKER_IMAGE} &&
                        docker stop myapp || true &&
                        docker rm myapp || true &&
                        docker run -d --name myapp -p 4444:4444 ${DOCKER_IMAGE}
                    '
                    """
                }
            }
        }
    }
}
