pipeline {
    agent { label 'cicd' }
    environment {
        PROJECT_ID = 'cidep-440311'
        CLUSTER_NAME = 'cidep-cluster'
        CLUSTER_ZONE = 'me-west1'
        DOCKER_IMAGE = 'josheleazar/cidep'
    }
    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "${env.BRANCH_NAME}"]],
                        userRemoteConfigs: [[
                            url: 'https://github.com/Josheleazar/CIDEP.git',
                            credentialsId: 'ccb5f0db-747d-4c7e-9cee-694faa7cc9d3'  // Use the ID you gave your token
                        ]]
                    ])
                }
            }
        }
        stage('Clone Repository') {
            steps {
                // Clone application code with Dockerfile
                git branch: 'main', url: 'https://github.com/Josheleazar/Jenk.git',
                credentialsId: 'ccb5f0db-747d-4c7e-9cee-694faa7cc9d3'  // Specify your GitHub token ID here
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'whoami'
                    sh 'groups'
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
                    sh "gcloud container clusters get-credentials ${CLUSTER_NAME} --region ${CLUSTER_ZONE}"
                }
            }
        }
        stage('Checkout 2') {
            steps {
                script {
                    checkout([
                        $class: 'GitSCM',
                        branches: [[name: "${env.BRANCH_NAME}"]],
                        userRemoteConfigs: [[
                            url: 'https://github.com/Josheleazar/CIDEP.git',
                            credentialsId: 'ccb5f0db-747d-4c7e-9cee-694faa7cc9d3'  // Use the ID you gave your token
                        ]]
                    ])
                }
            }
        }
        stage('Deploy to GKE') {
            steps {
                script {
                    // List files in the k8s directory for debugging
                    sh 'ls -la'
                    // Update deployment YAML with the new Docker image version
                    sh "sed -i 's|image: .*|image: ${DOCKER_IMAGE}:${env.BUILD_ID}|' k8s/blue-green.yaml"
                    // Apply Kubernetes YAML for deployment
                    sh 'kubectl apply -f k8s/blue-green.yaml'
                    sh 'kubectl apply -f k8s/selector.yaml'
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
