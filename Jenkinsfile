pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ttl.sh/programmerinyourarea/myapp:2h"
        TARGET_HOST  = "ubuntu@ec2-13-48-1-54.eu-north-1.compute.amazonaws.com"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy to Docker VM') {
            steps {
                sshagent(['docker_deploy']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${TARGET_HOST} '
                        set -e
                        docker pull ${DOCKER_IMAGE}
                        docker stop myapp || true
                        docker rm myapp || true
                        docker run -d -p 4444:4444 --name myapp ${DOCKER_IMAGE}
                    '
                    """
                }
            }
        }
    }
}
