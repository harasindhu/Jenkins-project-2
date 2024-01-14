pipeline {
 agent any
    tools{
      maven 'mvn'
    }
 
 stages {
    stage('Checkout') {
      steps {
         git branch: 'main', url: 'https://github.com/iamkishore0/maven_project.git'
       }
    }
    
   stage('Static Code Analysis') {
      environment {
       
            scannerHome = tool 'sonarqube'

            }

            steps {

             withSonarQubeEnv('sonarqube'){

                 sh "${scannerHome}/bin/sonar-scanner \
                  -Dsonar.login=8f1eb2eccea095ed5e8c4594d34e3295aed3d0c5\
                  -Dsonar.host.url=https://sonarcloud.io \
                  -Dsonar.organization= sindhu212\
                  -Dsonar.projectKey=sindhu212:sindhu212 \
                  -Dsonar.java.binaries=./ "
        }
      }
    }
   
   stage('Build and Push Docker Image') {
      environment {
        DOCKER_IMAGE = "myproject/ultimate-cicd:${BUILD_NUMBER}"
        DOCKER_REGISTRY = 'docker.io/sindhu212'
        REGISTRY_CREDENTIALS = credentials('docker-cred')
      }
      steps {
        script {
            // Docker build and push
          sh "docker build -t ${DOCKER_REGISTRY}/your-app:${BUILD_NUMBER} ."
          sh "docker push ${DOCKER_REGISTRY}/your-app:${BUILD_NUMBER}"
            }
        }
      }
  stage('Update Deployment File') {
        environment {
            GIT_REPO_NAME = "Jenkins-project-2"
            GIT_USER_NAME = "harasindhu"
        }
        steps {
            withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                sh '''
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
 

