pipeline {
  agent any

  environment {
    DEPLOY_USER = 'vagrant'
    DEPLOY_HOST = '192.168.56.23'
    DEPLOY_DIR  = '/home/vagrant/django_git/mysite'
    BRANCH      = 'main'
    SSH_CRED_ID = 'deploy-ssh-key'   // Jenkins Credentials ID (username=vagrant, private key)
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Run Remote Deploy') {
      steps {
        // SSH 자격증명에서 private key를 파일로 꺼내서 scp/ssh에 전달
        withCredentials([sshUserPrivateKey(credentialsId: env.SSH_CRED_ID,
                                           keyFileVariable: 'SSH_KEY')]) {
          sh """
            set -euo pipefail
            echo "[INFO] Copy deploy script to remote..."
            scp -i "$SSH_KEY" -o StrictHostKeyChecking=no \\
                mysite/scripts/deploy_remote.sh \\
                ${DEPLOY_USER}@${DEPLOY_HOST}:/tmp/deploy_remote.sh

            echo "[INFO] Run deploy script on remote..."
            ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no \\
                ${DEPLOY_USER}@${DEPLOY_HOST} \\
                'chmod +x /tmp/deploy_remote.sh && /tmp/deploy_remote.sh'
          """
        }
      }
    }
  }

  post {
    success { echo "✅ Deployment succeeded" }
    failure { echo "❌ Deployment failed" }
  }
}

