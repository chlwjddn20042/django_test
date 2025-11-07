pipeline {
    agent any

    environment {
        DEPLOY_USER = 'vagrant'
        DEPLOY_HOST = '192.168.56.23'
        DEPLOY_DIR = '/home/vagrant/django_git/mysite'
        REPO_URL = 'https://github.com/chlwjddn20042/django_test.git'
        BRANCH = 'main'
        SSH_CRED_ID = 'deploy-ssh-key'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Remote Deploy') {
            steps {
                sshagent(credentials: [env.SSH_CRED_ID]) {
                    // 핵심 포인트: heredoc이나 EOF 제거, 명령 직접 전달
                    sh '''
                        echo "[INFO] Connecting to remote server..."
                        ssh -T -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} << 'REMOTE_CMD'
                        set -e
                        echo "[INFO] Downloading latest deploy script..."
                        curl -s -o /tmp/deploy_remote.sh https://raw.githubusercontent.com/chlwjddn20042/django_test/main/mysite/scripts/deploy_remote.sh
                        chmod +x /tmp/deploy_remote.sh
                        echo "[INFO] Running remote deployment script..."
                        bash /tmp/deploy_remote.sh
                        REMOTE_CMD
                    '''
                }
            }
        }
    }

    post {
        success {
            echo "✅ Deployment succeeded"
        }
        failure {
            echo "❌ Deployment failed"
        }
    }
}

