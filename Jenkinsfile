pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh './build.sh'
            }
        }

        stage('Deploy to VM') {
            steps {
                sshagent(['deploy-key']) {
                    sh '''
                        scp ./my-app laborant@target:/home/user/
                        ssh user@target-vm '
                            sudo mv /home/user/my-app /usr/local/bin/my-app &&
                            sudo chmod +x /usr/local/bin/my-app
                        '
                    '''
                }
            }
        }

        stage('Setup systemd') {
            steps {
                sshagent(['deploy-key']) {
                    sh '''
                        ssh laborant@target '
                            echo "[Unit]
Description=Go App Service
After=network.target

[Service]
ExecStart=/usr/local/bin/my-app
Restart=always
User=user

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/my-app.service

                            sudo systemctl daemon-reload
                            sudo systemctl enable my-app
                            sudo systemctl restart my-app
                        '
                    '''
                }
            }
        }
    }
}
