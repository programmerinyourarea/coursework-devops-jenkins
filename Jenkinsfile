pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/programmerinyourarea/coursework-devops-jenkins.git'
            }
        }

        stage('Build') {
            steps {
                sh 'go build -o main main.go'
            }
        }

        stage('Deploy') {
            steps {
                // Copy binary to target machine
                sh 'scp -i ~/.ssh/id_deploy main laborant@target:/home/laborant/main'

                // Copy systemd service file (you create this on Jenkins workspace)
                sh 'scp -i ~/.ssh/id_deploy myapp.service laborant@target:/home/laborant/myapp.service'

                // On target, move the service file and start the service
                sh '''
                ssh -i ~/.ssh/id_deploy laborant@target << EOF
                sudo mv /home/laborant/myapp.service /etc/systemd/system/myapp.service
                sudo systemctl daemon-reload
                sudo systemctl enable myapp.service
                sudo systemctl restart myapp.service
                EOF
                '''
            }
        }
    }
}
