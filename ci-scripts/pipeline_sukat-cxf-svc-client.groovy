#!/usr/bin/env groovy

String settingspath = "/local/jenkins/conf/settings.xml"
String projectName = env.JOB_NAME

node('agent')
{
    stage("Cleanup workspace")
    {
        cleanWs()
    }

    stage("Prepare docker environment")
    {
        suDockerBuildAndPull(projectName)
    }

    docker.image(projectName).inside('-v /local/jenkins/conf:/local/jenkins/conf -v /local/jenkins/libexec:/local/jenkins/libexec')
    {
        suGitHubBuildStatus
        {
            stage('Checkout Code')
            {
                suCheckoutCode([projectName: projectName])
            }

            stage('Clean')
            {
                sh 'mvn clean'
            }

            stage('Deploy Nexus')
            {
                sh 'mvn deploy --global-settings ' + settingspath
            }
        }
    }
}

