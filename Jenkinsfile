pipeline {
  agent any

  environment {
    DEPLOY_USER = 'vagrant'
    DEPLOY_HOST = '192.168.56.23'
    DEPLOY_DIR  = '/home/vagrant/django_git/mysite'
    BRANCH      = 'main'
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
        sshagent (credentials: [env.SSH_CRED_ID]) {
          sh """
            echo "[INFO] Starting remote deploy..."
            cat <<'SCRIPT' | ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} bash
              set -e
              echo "[INFO] Connecting to remote server..."
              echo "[INFO] Downloading latest deploy script..."
              curl -s -o /tmp/deploy_remote.sh https://raw.githubusercontent.com/chlwjddn20042/django_test/${BRANCH}/mysite/scripts/deploy_remote.sh
              chmod +x /tmp/deploy_remote.sh
              echo "[INFO] Running remote deployment script..."
              /tmp/deploy_remote.sh || exit 1
              echo "[INFO] ✅ Remote deployment finished successfully."
            SCRIPT
          """
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
