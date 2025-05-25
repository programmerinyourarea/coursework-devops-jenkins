pipeline {
  agent any

  environment {
    TARGET_HOST = 'laborant@target'
    DEPLOY_KEY_ID = 'jenkins-deploy-key' // ✅ Replace with your actual Jenkins credentials ID if different
  }

  stages {
    stage('Build') {
      steps {
        sh 'go build -o app/main ./app'
      }
    }

    stage('Deploy') {
      steps {
        sshagent (credentials: [env.DEPLOY_KEY_ID]) {
          sh '''
            scp -o StrictHostKeyChecking=no app/main $TARGET_HOST:/tmp/main
            ssh -o StrictHostKeyChecking=no $TARGET_HOST '
              chmod +x /tmp/main &&
              pkill -f /tmp/main || true &&
              nohup /tmp/main > /tmp/server.log 2>&1 &
            '
          '''
        }
      }
    }
  }
}
