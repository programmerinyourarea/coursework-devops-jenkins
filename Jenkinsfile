pipeline {
    agent any

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

        stage('Deploy') {
            steps {
                script {
                    // Copy the binary
                    sh 'scp ../main laborant@target:/home/laborant/main'

                    // Create the service file locally inside workspace
                    writeFile file: 'myapp.service', text: """
                    [Unit]
                    Description=My Go App
                    After=network.target

                    [Service]
                    ExecStart=/home/laborant/main
                    Restart=always
                    User=laborant
                    Group=laborant
                    Environment=PORT=4444

                    [Install]
                    WantedBy=multi-user.target
                    """

                    // Copy the service file to target's home as temp
                    sh 'scp myapp.service laborant@target:/home/laborant/myapp.service.tmp'

                    // On target, move service file to systemd folder, set permissions, reload systemd, enable and restart service
                    sh '''
                    ssh laborant@target << EOF
                    sudo mv /home/laborant/myapp.service.tmp /etc/systemd/system/myapp.service
                    sudo chown root:root /etc/systemd/system/myapp.service
                    sudo chmod 644 /etc/systemd/system/myapp.service
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
