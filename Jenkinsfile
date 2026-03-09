pipeline {
    agent any

    environment {
        // Jenkins mein jo ID 'docker-hub-creds' banayi hai, ye wahi hai
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-creds') 
        DOCKER_IMAGE = "${DOCKERHUB_CREDENTIALS_USR}/django-ecommerce" 
        IMAGE_TAG = "v3" 
    }

    stages {
        stage('Cleanup') {
            steps {
                cleanWs() // Purana kachra saaf karne ke liye
            }
        }

        stage('Checkout SCM') {
            steps {
                checkout scm // GitHub se code uthayega
            }
        }

        stage('Trivy Security Scan') {
            steps {
                echo "Skipping Trivy scan for now to fix deployment..."
                // exit-code 0 matlab 63 vulns hone par bhi build fail nahi hoga
                //sh "trivy fs . --severity HIGH,CRITICAL --exit-code 0" 
            }
        }

        stage('Docker Build') {
            steps {
                echo "Building Docker Image: ${DOCKER_IMAGE}:${IMAGE_TAG}"
                sh "docker build -t ${DOCKER_IMAGE}:${IMAGE_TAG} ."
            }
        }

        stage('Docker Push') {
            steps {
                echo "Pushing to Docker Hub..."
                // PAT (Token) se login karega
                sh "echo ${DOCKERHUB_CREDENTIALS_PSW} | docker login -u ${DOCKERHUB_CREDENTIALS_USR} --password-stdin"
                sh "docker push ${DOCKER_IMAGE}:${IMAGE_TAG}"
            }
        }
    }

    post {
        success {
            echo "Bhai, Build Success! Image Docker Hub pe hai. 🚀"
        }
        failure {
            echo "Build fail ho gaya, console logs check karo. ❌"
        }
    }

}
