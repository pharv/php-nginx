pipeline {
    agent any
    stages {
        stage('Build') {
            agent {
                dockerfile {
                    additionalBuildArgs "-t westonmax/php-nginx:${env.BRANCH_NAME}"
                }
            }
            steps {
                echo 'Building...'
            }
        }
        stage('Publish - Docker Hub') {
            steps {
                sh "docker push westonmax/php-nginx:${env.BRANCH_NAME}"
            }
        }
    }
}
