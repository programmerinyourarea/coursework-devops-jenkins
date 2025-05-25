pipeline {
    agent any

    stages {
        stage('Checkout SCM') {
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

        stage('Deploy') {
            steps {
                dir("${env.WORKSPACE}") {
                    // Copy binary to target
                    sh 'scp main laborant@target:/home/laborant/main'

                    // Create and enable systemd service remotely
                    sh '''
                    ssh laborant@target << EOF
                    echo "[Unit]
Description=MyApp Service
After=network.target

[Service]
ExecStart=/home/laborant/main
Restart=always
User=laborant

[Install]
WantedBy=multi-user.target" > /home/laborant/myapp.service

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
}
