pipeline {
    agent any
    environment {
        TARGET = 'laborant@target'          // your deploy target user@host
        DEPLOY_PATH = '/home/laborant/app'  // where to put your app on the target
        SSH_KEY = '/var/lib/jenkins/.ssh/id_deploy'  // Jenkins private key path
        DOCKER_IMAGE = 'golang:1.21'        // Go Docker image version
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'git@github.com:programmerinyourarea/coursework-devops-jenkins.git'
            }
        }
        stage('Build') {
            steps {
                // Run go build inside docker container mounting current workspace
                sh """
                    docker run --rm -v \$(pwd):/go/src/app -w /go/src/app ${DOCKER_IMAGE} \
                    go build -o app/main main.go
                """
            }
        }
        stage('Deploy') {
            steps {
                sh "ssh -i ${SSH_KEY} -o StrictHostKeyChecking=no ${TARGET} 'mkdir -p ${DEPLOY_PATH}'"
                sh "scp -i ${SSH_KEY} app/main ${TARGET}:${DEPLOY_PATH}/main"
                // Restart app remotely: kill old and start new in background
                sh "ssh -i ${SSH_KEY} ${TARGET} 'pkill -f \"${DEPLOY_PATH}/main\" || true && nohup ${DEPLOY_PATH}/main > ${DEPLOY_PATH}/app.log 2>&1 &'"
            }
        }
    }
}
