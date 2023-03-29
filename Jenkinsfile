pipeline{
    agent{ label 'springpet' }
    environment {
        DOCKERHUB_USERNAME = "chaitu1812"
        JOBNAME = "${JOB_NAME}"
        IMAGE_TAG = "${BUILD_ID}"
        IMAGE_NAME = "${DOCKERHUB_USERNAME}" + "/" + "${JOBNAME}"
    }
    tools{
        maven 'MAVEN3.8.7'
    }
    stages{
        stage('Cleanup workspace'){
            steps{
                script{
                    cleanWs()
                }
            }
        }
        stage('git-clone'){
            steps{
                git branch: 'FIRST', url: 'https://github.com/chaithanya1812/test-12-spring-petclinic'
            }
        }
        stage('code-build'){
            steps{
                sh 'mvn clean package'
            }
        }
        stage('Archive-Junit-test results'){
            steps{
                junit  testResults: 'target/surefire-reports/*.xml'
            }
        }
        stage('SonarQubeReport'){
            steps{
                sh 'mvn sonar:sonar'
            }
        }
    
        stage('docker-Imagebuild'){
            steps{
                sh 'docker build -t ${IMAGE_NAME}:v1.${IMAGE_TAG} .'
                sh 'docker build -t ${IMAGE_NAME}:latest .'
            }
            
        }
        stage('docker-Imagepush'){
            steps{
                sh 'docker push ${IMAGE_NAME}:v1.${IMAGE_TAG}'
                sh 'docker push  ${IMAGE_NAME}:latest'
            }
        }
        stage('docker-Imagedelte'){
            steps{
                sh 'docker rmi ${IMAGE_NAME}:v1.${IMAGE_TAG}'
                sh 'docker rmi  ${IMAGE_NAME}:latest'
            }
            
        }
        stage('updating kuberntes deployment.yaml file'){
            steps{
                script{
                    sh """
                       cat deployment.yaml
                       sed -i 's/${JOBNAME}.*/${JOBNAME}:v1.${IMAGE_TAG}/g' deployment.yaml
                       cat deployment.yaml
                    """
                }
            }
            
        }
        stage('push changes to GitHub'){
            steps{
                script{
                    sh """
                       git add deployment.yaml
                       git commit -m "updated the deployment yaml file"
                    """
                    withCredentials([gitUsernamePassword(credentialsId: 'gitlogin1', gitToolName: 'Default')]) {
                        sh 'git push https://github.com/chaithanya1812/test-12-spring-petclinic.git FIRST'

                   }
                }
            }   
        }        
    }
}
