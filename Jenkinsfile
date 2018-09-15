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
            //sh "./cleanup.sh SampleNodeJsStaging"
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

    stage('Testing') {
        // lets push an event to dynatrace that indicates that we START a load test
        dir ('dynatrace-scripts') {
            sh './pushevent.sh SERVICE CONTEXTLESS DockerService SampleNodeJsStaging ' +
               '"STARTING Load Test" ${JOB_NAME} "Starting a Load Test as part of the Testing stage"' +
               ' ${JENKINS_URL} ${JOB_URL} ${BUILD_URL} ${GIT_COMMIT}'
        }

        // lets run some test scripts
        dir ('sample-nodejs-service-tests') {
            // start load test and run for 120 seconds - simulating traffic for Staging enviornment on port 80
            sh "rm -f stagingloadtest.log stagingloadtestcontrol.txt"
            sh "./loadtest.sh 80 stagingloadtest.log stagingloadtestcontrol.txt 120 Staging"

            archiveArtifacts artifacts: 'stagingloadtest.log', fingerprint: true
        }

        // lets push an event to dynatrace that indicates that we STOP a load test
        dir ('dynatrace-scripts') {
            sh './pushevent.sh SERVICE CONTEXTLESS DockerService SampleNodeJsStaging '+
               '"STOPPING Load Test" ${JOB_NAME} "Stopping a Load Test as part of the Testing stage" '+
               '${JENKINS_URL} ${JOB_URL} ${BUILD_URL} ${GIT_COMMIT}'
        }
    }


}
