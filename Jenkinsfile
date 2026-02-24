pipeline {
    agent { label 'dev' }
    environment {
        DOCKER_IMAGE = "easyshop-app"
        REGISTRY_ID  = "ayushsoni155"
        UNIQUE_TAG   = ""
        SCAN_REPORT  = "trivy-report.txt"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'k8s-test', url: 'https://github.com/ayushsoni155/EasyShop-k8s'
                script {
                    def shortSha = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    UNIQUE_TAG = "build-${env.BUILD_NUMBER}-${shortSha}"
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    sh "docker build -t ${REGISTRY_ID}/${DOCKER_IMAGE}:${UNIQUE_TAG} ."
                    sh "docker tag ${REGISTRY_ID}/${DOCKER_IMAGE}:${UNIQUE_TAG} ${REGISTRY_ID}/${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                script {
                    echo "Scanning image for vulnerabilities..."
                    sh "trivy image --severity HIGH,CRITICAL ${REGISTRY_ID}/${DOCKER_IMAGE}:${UNIQUE_TAG} > ${SCAN_REPORT}"
                    sh "cat ${SCAN_REPORT}"
                }
            }
        }

        stage('Push & Deploy') {
            steps {
                script {
                    withCredentials([usernamePassword(
                        credentialsId: "DOCKERHUB_CRED",
                        passwordVariable: "DOCKERHUB_PASS",
                        usernameVariable: "DOCKERHUB_USER")]) {
                        sh "docker login -u ${env.DOCKERHUB_USER} -p '${DOCKERHUB_PASS}'"
                        sh "docker push ${REGISTRY_ID}/${DOCKER_IMAGE}:${UNIQUE_TAG}"
                        sh "docker push ${REGISTRY_ID}/${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }
    }
    
    post {
        failure {
            script {
                emailext from: 'ayushsoni6997@gmail.com',
                         to: 'agent47.6997@gmail.com',
                         subject: "FAILED: Build ${env.JOB_NAME}", 
                         body: "Build failed for ${env.JOB_NAME}. See attached Trivy scan for potential security issues.",
                         attachmentsPattern: "${SCAN_REPORT}"
            }
        }
    
        success {
            script {
                emailext from: 'ayushsoni6997@gmail.com',
                         to: 'agent47.6997@gmail.com',
                         subject: "SUCCESSFUL: Build ${env.JOB_NAME}", 
                         body: "Build Successful! Trivy scan report is attached.",
                         attachmentsPattern: "${SCAN_REPORT}"
            }
        }
        always {
            sh "docker rmi ${REGISTRY_ID}/${DOCKER_IMAGE}:${UNIQUE_TAG} || true"
            archiveArtifacts artifacts: "${SCAN_REPORT}", allowEmptyArchive: true
        }
    }
}