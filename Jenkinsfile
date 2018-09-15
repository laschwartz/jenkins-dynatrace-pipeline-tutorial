node {
    environment {
        APP_NAME = "SampleNodeJs"
        STAGING = "Staging"
        PRODUCTION = "Production"
    }
 
    stage('Checkout') {
        // Checkout our application source code
        git url: 'https://github.com/dynatrace-innovationlab/jenkins-dynatrace-pipeline-tutorial.git', credentialsId: 'cd41a86f-ea57-4477-9b10-7f9277e650e1', branch: 'master'
        
        // into a dynatrace-cli subdirectory we checkout the CLI
        dir ('dynatrace-cli') {
            git url: 'https://github.com/Dynatrace/dynatrace-cli.git', credentialsId: 'cd41a86f-ea57-4477-9b10-7f9277e650e1', branch: 'master'
        }
    }

    stage('Build') {
        // Lets build our docker image
        dir ('sample-nodejs-service') {
            def app = docker.build("sample-nodejs-service:${BUILD_NUMBER}")
        }
    }

    stage('CleanStaging') {
        // The cleanup script makes sure no previous docker staging containers run
        dir ('sample-nodejs-service') {
            sh "./cleanup.sh SampleNodeJsStaging"
        }
    }

}
