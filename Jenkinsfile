pipeline {
    agent any

    environment {
        TARGET_HOST = "laborant@target"
        DEPLOY_PATH = "/home/laborant/main"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                dir('app') {
                    sh 'go build -o ../main main.go'
                }
            }
        }

        stage('Deploy Binary') {
            steps {
                sshagent(['70653f76-7f59-457b-b04e-db2244138e10']) {
                    sh 'scp -o StrictHostKeyChecking=no main ${TARGET_HOST}:${DEPLOY_PATH}'
                }
            }
        }

        stage('Setup systemd Service') {
            steps {
                sshagent(['70653f76-7f59-457b-b04e-db2244138e10']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no $TARGET_HOST 'bash -s' <<'ENDSSH'
                        echo "[Unit]
Description=My Go App

[Service]
ExecStart=/home/laborant/main
Restart=always
User=laborant

[Install]
WantedBy=multi-user.target" > myapp.service

                        sudo mv myapp.service /etc/systemd/system/myapp.service
                        sudo chown root:root /etc/systemd/system/myapp.service
                        sudo systemctl daemon-reexec
                        sudo systemctl daemon-reload
                        sudo systemctl enable myapp
                        sudo systemctl restart myapp
                        ENDSSH
                    '''
                }
            }
        }
    }
}
