pipeline {
    agent any

    environment {
        DEPLOY_USER = 'vagrant'
        DEPLOY_HOST = '192.168.56.23'
        DEPLOY_SCRIPT = '/home/vagrant/django_git/mysite/scripts/deploy_remote.sh'
        GIT_REPO = 'https://github.com/chlwjddn20042/django_test.git'
        GIT_BRANCH = 'main'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${env.GIT_BRANCH}", url: "${env.GIT_REPO}"
            }
        }

        stage('Run Remote Deploy') {
            steps {
                sshagent(['vagrant']) {
                    sh '''
                        echo "[INFO] Connecting to remote server..."
                        ssh -T -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} '
                            echo "[INFO] Downloading latest deploy script..."
                            if [ ! -f ${DEPLOY_SCRIPT} ]; then
                                echo "[ERROR] Deploy script not found at ${DEPLOY_SCRIPT}"
                                exit 1
                            fi
                            echo "[INFO] Running remote deployment script..."
                            bash ${DEPLOY_SCRIPT}
                        '
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment succeeded!"
        }
        failure {
            echo "❌ Deployment failed"
        }
    }
}

