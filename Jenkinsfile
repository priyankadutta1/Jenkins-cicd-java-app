pipeline {
    agent any

    tools {
        maven 'Maven3'
        jdk 'Java17'
    }

    environment {
        PROJECT_ID = 'internal-sandbox-446612'
        REGION     = 'asia-south1'
        REPO       = 'java-app-repo'
        IMAGE_NAME = 'java-app'
        IMAGE_TAG  = 'latest'
        IMAGE_URI  = "${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}/${IMAGE_NAME}:${IMAGE_TAG}"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/<your-username>/java-app.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Docker Build & Push') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:$IMAGE_TAG .
                docker tag $IMAGE_NAME:$IMAGE_TAG $IMAGE_URI
                gcloud auth configure-docker ${REGION}-docker.pkg.dev -q
                docker push $IMAGE_URI
                '''
            }
        }

        stage('Deploy to GKE') {
            steps {
                sh '''
                kubectl apply -f k8s/deployment.yaml
                kubectl rollout status deployment/java-app
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully'
        }
        failure {
            echo '❌ Pipeline failed'
        }
    }
}
