pipeline {
  agent {
    docker {
      image 'abhishekf5/maven-abhishek-docker-agent:v1'
      }
  }
  stages {
    stage('Checkout') {
      steps {
         git branch: 'main', url: 'https://github.com/iamkishore0/maven_project.git'
       }
    }
    stage('Build and Test') {
      steps {
        sh 'ls -ltr'
        // build the project and create a JAR file
        sh 'mvn clean package'
      }
    }
    stage('Static Code Analysis') {
      environment {

                scannerHome = tool 'sonarqube'

            }

            steps {

             withSonarQubeEnv('sonarqube'){

                 sh "${scannerHome}/bin/sonar-scanner \
                  -Dsonar.login=b34a4d7235a4f574bfa64d127fb1f124e5174c6f \
                  -Dsonar.host.url=https://sonarcloud.io \
                  -Dsonar.organization= sindhu123\
                  -Dsonar.projectKey=sindhu123 \
                  -Dsonar.java.binaries=./ "
        }
      }
    }
    stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "myproject/ultimate-cicd:${BUILD_NUMBER}"
        DOCKER_REGISTRY = 'docker.io/sindhu212'
      }
      steps {
        script {
            // Docker build and push
          sh "docker build -t ${DOCKER_REGISTRY}/your-app:${BUILD_NUMBER} ."
          sh "docker push ${DOCKER_REGISTRY}/your-app:${BUILD_NUMBER}"
            }
        }
      }
    }
    stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "Jenkins-Zero-To-Hero"
            GIT_USER_NAME = "iam-veeramalla"
        }
        steps {
            withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                sh '''
                    git config user.email "abhishek.xyz@gmail.com"
                    git config user.name "Abhishek Veeramalla"
                    BUILD_NUMBER=${BUILD_NUMBER}
                    sed -i "s/replaceImageTag/${BUILD_NUMBER}/g" java-maven-sonar-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml
                    git add java-maven-sonar-argocd-helm-k8s/spring-boot-app-manifests/deployment.yml
                    git commit -m "Update deployment image to version ${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/${GIT_USER_NAME}/${GIT_REPO_NAME} HEAD:main
                '''
            }
        }
    }
  }
}
