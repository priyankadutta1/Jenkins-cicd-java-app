pipeline {
    agent any

    environment {
        PROJECT_ID = "internal-sandbox-446612"
        REGION     = "asia-south1"
        REPO       = "java-app-repo"
        IMAGE_NAME = "java-app"
        IMAGE_TAG  = "${BUILD_NUMBER}"

        REGISTRY   = "${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO}"
        FULL_IMAGE = "${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"

        SONAR_PROJECT_KEY = "java-app"
    }

    tools {
        maven "Maven"
        jdk "Java-17"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/priyankadutta1/Jenkins-cicd-java-app.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonarqube') {
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY}
                    """
                }
            }
        }

        stage('Quality Gate') {
            steps {
                timeout(time: 15, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $FULL_IMAGE .
                '''
            }
        }

        stage('Authenticate to Artifact Registry') {
            steps {
                sh '''
                    gcloud auth configure-docker asia-south1-docker.pkg.dev --quiet
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                    docker push $FULL_IMAGE
                '''
            }
        }

        stage('Deploy to GKE') {
            steps {
                sh '''
                    sed "s|IMAGE_PLACEHOLDER|$FULL_IMAGE|g" k8s/deployment.yaml | kubectl apply -f -
                '''
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD Pipeline completed successfully"
        }
        failure {
            echo "❌ CI/CD Pipeline failed"
        }
    }
}


