pipeline {
 agent any
    tools{
      maven 'mvn'
    }
  environment {
            GIT_REPO_NAME = "Jenkins-project-2"
            GIT_USER_NAME = "harasindhu"
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
    }
  stage('deploy') {
    steps {
       script {
          kubernetesDeploy(configs: "deploymentservice.yml", kubeconfigId: "kubernetes")
        }
        }
    }
}

