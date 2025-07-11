pipeline{
    agent any
    tools{
        jdk 'jdk'
        nodejs 'nodeJS'
    }
    environment {
        SCANNER_HOME=tool 'sonarqube-scanner'
    }
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git'){
            steps{
                git 'https://github.com/Debjyoti2004/amazon-prime-clone.git'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('SonarQube') {
                    sh ''' 
                       $SCANNER_HOME/bin/sonar-scanner \
                       -Dsonar.projectName=amazon-prime \
                       -Dsonar.projectKey=amazon-prime \
                       -Dsonar.branch.name=main 
                    '''
                }
            }
        }
        stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'SonarQube-Token' 
                }
            } 
        }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }        
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'Docker', toolName: 'docker'){   
                       sh "docker build -t amazon-prime ."
                       sh "docker tag amazon-prime debjyoti08/amazon-prime:latest "
                       sh "docker push debjyoti08/amazon-prime:latest "
                    }
                }
            }
        }
		stage('Docker Scout Image') {
            steps {
                script{
                   withDockerRegistry(credentialsId: 'Docker', toolName: 'docker'){
                       sh 'docker-scout quickview debjyoti08/amazon-prime:latest'
                       sh 'docker-scout cves debjyoti08/amazon-prime:latest'
                       sh 'docker-scout recommendations debjyoti08/amazon-prime:latest'
                   }
                }
            }
        }

        stage("TRIVY-docker-images"){
            steps{
                sh "trivy image debjyoti08/amazon-prime:latest > trivyimage.txt" 
            }
        }
        stage('App Deploy to Docker container'){
            steps{
                sh 'docker run -d --name amazon-prime -p 3000:3000 debjyoti08/amazon-prime:latest'
            }
        }

    }
    post {
    always {
        script {
            def buildStatus = currentBuild.currentResult
            def buildUser = currentBuild.getBuildCauses('hudson.model.Cause$UserIdCause')[0]?.userId ?: 'Github User'
            
            emailext (
                subject: "Pipeline ${buildStatus}: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """
                    <p>This is a Jenkins amazon-prime CICD pipeline status.</p>
                    <p>Project: ${env.JOB_NAME}</p>
                    <p>Build Number: ${env.BUILD_NUMBER}</p>
                    <p>Build Status: ${buildStatus}</p>
                    <p>Started by: ${buildUser}</p>
                    <p>Build URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>
                """,
                to: 'debjyotishit8@gmail.com',
                from: 'debjyotishit8@gmail.com',
                replyTo: 'debjyotishit8@gmail.com',
                mimeType: 'text/html',
                attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
            )
           }
       }

    }

}
