pipeline {
    agent any

    environment {
        REGISTRY = "shubham4477"
        IMAGE = "reddit-clone"
        TAG = "latest"

        DOCKER_USERNAME = "shubham4477"
        DOCKER_PASSWORD = ""
    }

    stages {

        stage('Clone Repository') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/shubham4477234/reddit-clone-k8s-ingress.git'
            }
        }

        stage('Docker Login') {
            steps {
                sh """
                    echo "Logging into Docker Hub..."
                    echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
                """
            }
        }

        stage('Docker Build') {
            steps {
                sh """
                    echo "Building Docker image..."
                    docker build -t $REGISTRY/$IMAGE:$TAG .
                """
            }
        }

        stage('Docker Push') {
            steps {
                sh """
                    echo "Pushing image to Docker Hub..."
                    docker push $REGISTRY/$IMAGE:$TAG
                """
            }
        }

        stage('Setup Kubeconfig From Jenkins Secret') {
            steps {
                withCredentials([string(credentialsId: 'kubeconfig', variable: 'KCFG_B64')]) {
                    sh """
                        echo "Decoding kubeconfig from Jenkins secret..."
                        echo "$KCFG_B64" | base64 -d > kube.conf

                        export KUBECONFIG=kube.conf
                        kubectl cluster-info
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                    echo "Deploying manifests to Kubernetes..."

                    export KUBECONFIG=kube.conf

                    kubectl apply -f deployment.yml --validate=false
                    kubectl apply -f service.yml --validate=false
                    kubectl apply -f ingress.yml --validate=false
                """
            }
        }
    }
}
