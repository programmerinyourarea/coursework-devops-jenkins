pipeline {
    agent any

    environment {
        SSH_KEY = credentials('jenkins-deploy-key')  // Your SSH private key credential ID in Jenkins
        TARGET_USER = 'laborant'
        TARGET_HOST = 'target'                        // Replace with your target VM hostname/IP
        APP_PATH = '/home/laborant/myapp'
        SERVICE_FILE = 'myapp.service'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                sh 'cd app && go build -o ../myapp main.go'
            }
        }

        stage('Deploy') {
            steps {
                sh """
                    ssh -i ~/.ssh/id_deploy -o StrictHostKeyChecking=no ${TARGET_USER}@${TARGET_HOST} 'mkdir -p /home/laborant'
                    scp -i ~/.ssh/id_deploy myapp ${TARGET_USER}@${TARGET_HOST}:${APP_PATH}
                    scp -i ~/.ssh/id_deploy ${SERVICE_FILE} ${TARGET_USER}@${TARGET_HOST}:/home/laborant/
                """
            }
        }

        stage('Start Service') {
            steps {
                sh """
                    ssh -i ~/.ssh/id_deploy ${TARGET_USER}@${TARGET_HOST} 'sudo mv /home/laborant/${SERVICE_FILE} /etc/systemd/system/${SERVICE_FILE}'
                    ssh -i ~/.ssh/id_deploy ${TARGET_USER}@${TARGET_HOST} 'sudo systemctl daemon-reload'
                    ssh -i ~/.ssh/id_deploy ${TARGET_USER}@${TARGET_HOST} 'sudo systemctl enable ${SERVICE_FILE}'
                    ssh -i ~/.ssh/id_deploy ${TARGET_USER}@${TARGET_HOST} 'sudo systemctl restart ${SERVICE_FILE}'
                    ssh -i ~/.ssh/id_deploy ${TARGET_USER}@${TARGET_HOST} 'sudo systemctl status ${SERVICE_FILE} --no-pager'
                """
            }
        }
    }
}
