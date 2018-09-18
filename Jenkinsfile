node {
    environment {
        APP_NAME = "SampleNodeJs"
        STAGING = "Staging"
        PRODUCTION = "Production"
    }
 
    stage('Checkout') {
        // Checkout our application source code
        //git url: 'https://github.com/dynatrace-innovationlab/jenkins-dynatrace-pipeline-tutorial.git', credentialsId: 'cd41a86f-ea57-4477-9b10-7f9277e650e1', branch: 'master'
        git url: 'https://github.com/laschwartz/jenkins-dynatrace-pipeline-tutorial.git', credentialsId: 'ddc7227e-e158-4e3a-a73c-0ca03f4f4bd4', branch: 'master'
        
        // into a dynatrace-cli subdirectory we checkout the CLI
        dir ('dynatrace-cli') {
            git url: 'https://github.com/Dynatrace/dynatrace-cli.git', credentialsId: 'cd41a86f-ea57-4477-9b10-7f9277e650e1', branch: 'master'
        }
    }
}
