pipeline {
    agent any
    stages {
        stage('Build') {
            agent {
                dockerfile {
                    additionalBuildArgs "-t pharv/php-nginx:${env.BRANCH_NAME}"
                }
            }
            steps {
                echo 'Building...'
            }
        }
        stage('Publish - Docker Hub') {
            steps {
                sh "docker push pharv/php-nginx:${env.BRANCH_NAME}"
            }
        }
    }
}
