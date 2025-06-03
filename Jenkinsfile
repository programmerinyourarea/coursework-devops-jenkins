pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "ttl.sh/programmerinyourarea/myapp:2h"
        KUBECONFIG_PATH = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'kubernetes', url: 'https://github.com/programmerinyourarea/coursework-devops-jenkins'
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
            environment {
                K8S_SERVER = "https://k8s:6443"
            }
            steps {
                withCredentials([string(credentialsId: 'k8s-token', variable: 'K8S_TOKEN')]) {
                    sh '''
                        mkdir -p $(dirname ${KUBECONFIG_PATH})
                        cat <<EOF > ${KUBECONFIG_PATH}
apiVersion: v1
kind: Config
clusters:
- name: k8s
  cluster:
    server: ${K8S_SERVER}
    insecure-skip-tls-verify: true
contexts:
- name: k8s-context
  context:
    cluster: k8s
    user: jenkins
current-context: k8s-context
users:
- name: jenkins
  user:
    token: ${K8S_TOKEN}
EOF
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl --kubeconfig=${KUBECONFIG_PATH} delete pod myapp --ignore-not-found=true -n default

                    cat <<EOF | kubectl --kubeconfig=${KUBECONFIG_PATH} apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: myapp
  namespace: default
spec:
  containers:
  - name: myapp
    image: ${DOCKER_IMAGE}
    ports:
    - containerPort: 8080
EOF
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh 'kubectl --kubeconfig=${KUBECONFIG_PATH} get pods -n default'
            }
        }
    }
}
