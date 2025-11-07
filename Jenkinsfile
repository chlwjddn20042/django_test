pipeline {
  agent any

  environment {
    PATH = "/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin:/home/vagrant/.local/bin:/home/vagrant/bin"
    DEPLOY_USER = 'vagrant'
    DEPLOY_HOST = '192.168.56.23'
    DEPLOY_DIR  = '/home/vagrant/django_git/mysite'
    REPO_URL    = 'https://github.com/gyuseok-1316/django_test.git'
    BRANCH      = 'main'
    SSH_CRED_ID = 'deploy-ssh-key'
  }

  stages {
    stage('Checkout') {
      steps {
        echo "[INFO] Checking out repository..."
        checkout scm
      }
    }

    stage('Run Remote Deploy') {
      steps {
        sshagent (credentials: [env.SSH_CRED_ID]) {
          sh """
            echo "[INFO] Running remote deployment..."
            ssh -o StrictHostKeyChecking=no ${DEPLOY_USER}@${DEPLOY_HOST} 'bash -s' < ${DEPLOY_DIR}/scripts/deploy_remote.sh
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

