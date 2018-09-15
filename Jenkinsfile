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

    stage('DeployStaging') {
        // Lets deploy the previously build container
        def app = docker.image("sample-nodejs-service:${BUILD_NUMBER}")
        app.run("--name SampleNodeJsStaging -p 80:80 " +
                "-e 'DT_CLUSTER_ID=SampleNodeJsStaging' " +
                "-e 'DT_TAGS=Environment=Staging Service=Sample-NodeJs-Service' " +
                "-e 'DT_CUSTOM_PROP=ENVIRONMENT=Staging JOB_NAME=${JOB_NAME} " +
                    "BUILD_TAG=${BUILD_TAG} BUILD_NUMBER=${BUIlD_NUMBER}'")

        dir ('dynatrace-scripts') {
            // push a deployment event on the host with the tag [AWS]Environment:JenkinsTutorial
            sh './pushdeployment.sh HOST AWS Environment JenkinsTutorial ' +
               '${BUILD_TAG} ${BUILD_NUMBER} ${JOB_NAME} ' +
               'Jenkins ${JENKINS_URL} ${JOB_URL} ${BUILD_URL} ${GIT_COMMIT}'

            // now I push one on the actual service (it has the tags from our rules)
            sh './pushdeployment.sh SERVICE CONTEXTLESS DockerService SampleNodeJsStaging ' +
               '${BUILD_TAG} ${BUILD_NUMBER} ${JOB_NAME} ' +
               'Jenkins ${JENKINS_URL} ${JOB_URL} ${BUILD_URL} ${GIT_COMMIT}'
        }
    }

}
