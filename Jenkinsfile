pipeline {
    agent any
    environment {
        PROJECT_ID = 'cidep-440311'
        CLUSTER_NAME = 'cidep-cluster'
        CLUSTER_ZONE = 'me-west1-a'
        DOCKER_IMAGE = 'josheleazar/cidep'
    }
    stages {
        stage('Install gcloud and Plugin') {
            steps {
                script {
                    // Check and install gcloud if necessary
                    sh """
                    if ! command -v gcloud &> /dev/null
                    then
                        curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-xxx.tar.gz
                        tar -xzf google-cloud-sdk-xxx.tar.gz
                        ./google-cloud-sdk/install.sh
                    fi
                    gcloud components install gke-gcloud-auth-plugin -q
                    """
                }
            }
        }
        stage('Clone Repository') {
            steps {
                // Clone application code with Dockerfile
                git branch: 'application', url: 'https://https://github.com/Josheleazar/CIDEP.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image for Flask app
                    dockerImage = docker.build("${DOCKER_IMAGE}:${env.BUILD_ID}")
                }
            }
        }
        stage('Push Image to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Configure gcloud') {
            steps {
                withCredentials([file(credentialsId: 'gcp-key', variable: 'GOOGLE_APPLICATION_CREDENTIALS')]) {
                    // Authenticate with GCP and configure kubectl with GKE credentials
                    sh 'gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS'
                    sh "gcloud config set project ${PROJECT_ID}"
                    sh "gcloud container clusters get-credentials ${CLUSTER_NAME} --zone ${CLUSTER_ZONE}"
                }
            }
        }
        stage('Deploy to GKE') {
            steps {
                script {
                    // Update deployment YAML with the new Docker image version
                    sh "sed -i 's|image: .*$|image: ${DOCKER_IMAGE}:${env.BUILD_ID}|' k8s/deployment.yaml"
                    // Apply Kubernetes YAML for deployment
                    sh 'kubectl apply -f k8s/'
                }
            }
        }
    }
    post {
        failure {
            mail to: 'your-email@example.com',
                subject: "Build failed in Jenkins: ${currentBuild.fullDisplayName}",
                body: "Something went wrong in Jenkins."
        }
    }
}