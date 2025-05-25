pipeline {
    agent {
        docker {
            image 'golang:1.21'  // official Go image with Go 1.21
            args '-v $HOME/.ssh:/root/.ssh:ro'  // mount your ssh keys for deployment
        }
    }
    environment {
        TARGET = 'laborant@target'         // your deploy SSH user@host
        DEPLOY_PATH = '/home/laborant/app' // remote path to deploy
        SSH_KEY = '/root/.ssh/id_deploy'   // private key inside container
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:programmerinyourarea/coursework-devops-jenkins.git'
            }
        }
        stage('Build') {
            steps {
                sh 'go build -o app/main main.go'
            }
        }
        stage('Deploy') {
            steps {
                // Create remote dir (ignore errors if exists)
                sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${TARGET} 'mkdir -p ${DEPLOY_PATH}'"

                // Copy binary
                sh "scp -i ${SSH_KEY} app/main ${TARGET}:${DEPLOY_PATH}/main"

                // Run binary remotely (background, redirect output)
                sh "ssh -i ${SSH_KEY} ${TARGET} 'pkill -f \"${DEPLOY_PATH}/main\" || true && nohup ${DEPLOY_PATH}/main > ${DEPLOY_PATH}/app.log 2>&1 &'"
            }
        }
    }
}
