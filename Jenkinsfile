pipeline {
  agent any

  environment {
    REPOSITORY_TAG     = "${PRIVATE_REPO_TAG}/${PRIVATE_APP_NAME}:${VERSION}"
    PRIVATE_REPO_TAG   = "765176032689.dkr.ecr.eu-west-1.amazonaws.com/awsprime"
    PRIVATE_APP_NAME   = "awsprime"
    VERSION            = "${BUILD_ID}"
  }

  stages {

    stage ('Publish to ECR') {
          steps {
             withEnv(["AWS_ACCESS_KEY_ID=${env.AWS_ACCESS_KEY_ID}", "AWS_SECRET_ACCESS_KEY=${env.AWS_SECRET_ACCESS_KEY}", "AWS_DEFAULT_REGION=${env.AWS_DEFAULT_REGION}"]) {
                sh 'docker login -u AWS -p $(aws ecr get-login-password --region eu-west-1) ${PRIVATE_REPO_TAG}'
                sh 'docker build -t ${PRIVATE_APP_NAME}:${VERSION} .'
                sh 'docker tag ${PRIVATE_APP_NAME}:${VERSION} ${PRIVATE_REPO_TAG}/${PRIVATE_APP_NAME}:${VERSION}'
                sh 'docker push ${PRIVATE_REPO_TAG}/${PRIVATE_APP_NAME}:${VERSION}'
         }
       }
    }

    stage("Install kubectl"){
            steps {
                sh """
                    curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
                    chmod +x ./kubectl
                    ./kubectl version --client
                """
            }
        }
        
    stage ('Deploy to Cluster') {
            steps {
                sh ""
                     aws eks update-kubeconfig --region eu-west-1 --name ekscluster
                     envsubst < ${WORKSPACE}/deploy.yaml | ./kubectl apply -f - 
                   ""
            }
        }

    stage ('Delete Images') {
      steps {
        sh 'docker rmi -f $(docker images -qa)'
      }
    }
  }
}
