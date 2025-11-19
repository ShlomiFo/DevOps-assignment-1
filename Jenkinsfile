pipeline {
    agent any
    environment {
        AWS_REGION  = "us-east-1"
        ECR_REGISTRY = "YOUR_AWS_ACCOUNT_ID.dkr.ecr.${AWS_REGION}.amazonaws.com" / add your ECR registry uri
        REPO_NAME = "demo-app-repo"
        GIT_REPO_URL = 'https://github.com/ShlomiFo/DevOps-assignment-1.git'
        DOCKER = '/usr/bin/docker'
        AWS = '/usr/local/bin/aws'

        CLUSTER_NAME          = "demo-eks"           // replace with your EKS cluster name
        HELM_RELEASE          = "demo-app"                 // Helm release name
        HELM_CHART_PATH       = "/helm-chart"               // path to your Helm chart in repo
        NAMESPACE             = "production"               // Kubernetes namespace
        KUBECONFIG_PATH       = "${WORKSPACE}/kubconfig"  // local kubeconfig path

    }


    stages {
        stage('Checkout code') {
            steps {
                git branch: "main",
                    credentialsId: "github-creads",
                    url: "${GIT_REPO_URL}"
            }
        }

            stage('verify AWS creadentials') {
                withAWS(creadentials: 'aws-creads', region: '${AWS_REGION}') {

             sh '''
             /usr/local/bin/aws sts get-caller-identity
             echo "Make sure ECR repo exists"
             aws ecr describe-repositories --repository-names $ECR_REPO >/dev/null 2>&1 || \
                aws ecr create-repository --repository-name $ECR_REPO
                echo "Login Docker to ECR"
             aws ecr get-login-password --region $AWS_REGION \
                        | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                    '''
             }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                        docker build -t -f /app/Dockerfile ${REPO_NAME}:latest .
                        docker tag $REPO_NAME:latest $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:latest
                    """
                }
            }
        }

        stage('Push to ECR') {
            steps {
                script {
                    sh """
                        docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPO_NAME:latest
                    """
                }
            }
        }
    }
     stage('Update kubeconfig for EKS') {
            steps {
                withEnv([
                    "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}",
                    "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}",
                    "AWS_DEFAULT_REGION=${AWS_REGION}"
                ]) {
                    script {
                        sh """
                        # Update local kubeconfig
                        aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME} --kubeconfig ${KUBECONFIG_PATH}
                        export KUBECONFIG=${KUBECONFIG_PATH}
                        kubectl get nodes --kubeconfig ${KUBECONFIG_PATH}
                        """
                    }
                }
            }
        }

        stage('Helm Deploy/Upgrade') {
            steps {
                script {
                    sh """
                    export KUBECONFIG=${KUBECONFIG_PATH}

                    # Create namespace if it doesn't exist
                    kubectl get namespace ${NAMESPACE} --kubeconfig ${KUBECONFIG_PATH} || \
                        kubectl create namespace ${NAMESPACE} --kubeconfig ${KUBECONFIG_PATH}

                    # Deploy / Upgrade Helm release
                    helm upgrade --install ${HELM_RELEASE} ${HELM_CHART_PATH} \
                        --namespace ${NAMESPACE} \
                        --set image.repository=${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO} \
                        --set image.tag=${IMAGE_TAG} \
                        --wait --timeout 5m
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                script {
                    sh """
                    export KUBECONFIG=${KUBECONFIG_PATH}
                    kubectl rollout status deployment/${HELM_RELEASE} -n ${NAMESPACE} --kubeconfig ${KUBECONFIG_PATH} --timeout=120s || \
                        kubectl describe deployment ${HELM_RELEASE} -n ${NAMESPACE} --kubeconfig ${KUBECONFIG_PATH}
                    """
                }
            }
        }
    }

    post {
        success {
            echo "Deployment succeeded! Image: ${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:${IMAGE_TAG}"
        }
        failure {
            echo "Pipeline failed. Check logs for errors."
        }
    }
}

}
