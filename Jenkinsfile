pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = "easyshop-app"
        REGISTRY_ID  = "ayushsoni155"
        // We initialize these as empty; we will populate them in the first stage
        UNIQUE_TAG   = ""
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/ayushsoni155/EasyShop-k8s'
                script {
                    // Generate SHA and Tag after checkout is complete
                    def shortSha = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
                    UNIQUE_TAG = "build-${env.BUILD_NUMBER}-${shortSha}"
                    echo "Generated Unique Tag: ${UNIQUE_TAG}"
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    // Use double quotes to allow Groovy variable interpolation
                    sh "docker build -t ${REGISTRY_ID}/${DOCKER_IMAGE}:${UNIQUE_TAG} ."
                    sh "docker tag ${REGISTRY_ID}/${DOCKER_IMAGE}:${UNIQUE_TAG} ${REGISTRY_ID}/${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Test') {
            steps {
                script{
                echo 'Testing image...'
                }
            }
        }

        stage('Push & Deploy') {
            steps {
                script {
                    // Secure login and push
                    withCredentials([string(credentialsId: 'DOCKERHUB_PASS', variable: 'SECRET_VAR')]) {
                        sh "docker login -u ${REGISTRY_ID} -p '${SECRET_VAR}'"
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
                         body: "Build failed: ${env.JOB_NAME} (No. ${env.BUILD_NUMBER})",
                         attachmentsPattern: 'fileAnalysis.txt, dockerAnalysis.txt'
            }
        }
    
        success {
            script {
                emailext from: 'ayushsoni6997@gmail.com',
                         to: 'agent47.6997@gmail.com',
                         subject: "SUCCESSFUL: Build ${env.JOB_NAME}", 
                         body: "Build Successful: ${env.JOB_NAME} (No. ${env.BUILD_NUMBER})",
                         attachmentsPattern: 'fileAnalysis.txt, dockerAnalysis.txt'
            }
        }
        always {
            // Cleanup to save disk space on the Jenkins agent
            sh "docker rmi ${REGISTRY_ID}/${DOCKER_IMAGE}:${UNIQUE_TAG} || true"
        }
    }
}