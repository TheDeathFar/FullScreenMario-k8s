pipeline {
    agent {
        kubernetes {
            yaml '''
        apiVersion: v1
        kind: Pod
        spec:
          containers:
          - name: kubectl
            image: deathfar/kubectl:1.29.0
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /root/.kube
               name: kube-config
          - name: docker
            image: docker:latest
            command:
            - cat
            tty: true
            volumeMounts:
             - mountPath: /var/run/docker.sock
               name: docker-sock
          volumes:
          - name: docker-sock
            hostPath:
              path: /var/run/docker.sock
          - name: kube-config
            hostPath:
              path: /tmp
        '''
        }
    }
    stages {
        stage('Checkout Source') {
            steps {
                git branch: 'main', url: 'https://github.com/TheDeathFar/FullScreenMario-k8s.git'
            }
        }
        stage('Build image') {
            steps {
                script {
                    container('docker') {
                        sh 'docker build -t deathfar/fsm_nginx .'
                    }
                }
            }
        }
        stage('Push image to Hub'){
            steps {
                script {
                    container('docker') {
                        withCredentials([string(credentialsId: 'dockerhub-pwd', variable: 'dockerhubpwd')]) {
                            sh 'docker login -u deathfar -p ${dockerhubpwd}'
                        }
                        sh 'docker push deathfar/fsm_nginx'
                    }
                }
            }
        }
        stage('Deploying mario container to Kubernetes') {
            steps {
                script {
                    container('kubectl') {
                        sh 'kubectl apply -f fsm-deployment/deployment'
                    }
                }
            }
        }
    }
}