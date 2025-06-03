pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ttl.sh/programmerinyourarea/myapp:2h"
        K8S_API = 'https://k8s:6443'
        K8S_TOKEN = credentials('k8s-token') // Store your service account token in Jenkins
        NAMESPACE = 'default'
        POD_NAME = 'myapp'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                sh "docker push ${DOCKER_IMAGE}"
            }
        }

        stage('Configure kubectl') {
            steps {
                sh '''
                mkdir -p $HOME/.kube

                cat <<EOF > $HOME/.kube/config
                apiVersion: v1
                kind: Config
                clusters:
                - cluster:
                    server: ${K8S_API}
                    insecure-skip-tls-verify: true
                  name: my-cluster
                contexts:
                - context:
                    cluster: my-cluster
                    user: jenkins
                    namespace: ${NAMESPACE}
                  name: jenkins-context
                current-context: jenkins-context
                users:
                - name: jenkins
                  user:
                    token: ${K8S_TOKEN}
                EOF
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh """
                    kubectl delete pod ${POD_NAME} --ignore-not-found=true -n ${NAMESPACE}

                    cat <<EOF | kubectl apply -f -
                    apiVersion: v1
                    kind: Pod
                    metadata:
                      name: ${POD_NAME}
                      namespace: ${NAMESPACE}
                    spec:
                      containers:
                      - name: ${POD_NAME}-container
                        image: ${DOCKER_IMAGE}
                        ports:
                        - containerPort: 4444
                        imagePullPolicy: Always
                    EOF
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh "kubectl get pod ${POD_NAME} -n ${NAMESPACE} -o wide"
            }
        }
    }
}
