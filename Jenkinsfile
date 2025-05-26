pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ttl.sh/programmerinyourarea/myapp:2h"
        TARGET_HOST = "laborant@docker"
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
                sshagent(['deploy_id']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${TARGET_HOST} '
                        docker pull ${DOCKER_IMAGE} &&
                        docker stop myapp || true &&
                        docker rm myapp || true &&
                        docker run -d -p 4444:4444 --name myapp ${DOCKER_IMAGE}
                    '
                    """
                }
            }
        }
    }
}
