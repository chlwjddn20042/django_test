#!/bin/bash
set -e

echo "[INFO] Deploy script started..."

PROJECT_DIR="/home/vagrant/django_git/mysite"

# mysite 디렉토리로 이동 (이미 클론되어 있음)
cd $PROJECT_DIR

# Git 리포가 이미 있으면 pull, 없으면 clone
if [ -d ".git" ]; then
    echo "[INFO] Existing repo found. Pulling latest changes..."
    git reset --hard
    git pull origin main
else
    echo "[INFO] Cloning repository..."
    git clone https://github.com/chlwjddn20042/django_test.git .
fi

# Python 환경 설정 및 서버 재시작
echo "[INFO] Installing dependencies..."
pip install --user -r requirements.txt

echo "[INFO] Restarting Django runserver..."
pkill -f "python manage.py runserver" || true
nohup python3 manage.py runserver 0.0.0.0:8000 > server.log 2>&1 &

echo "[INFO] ✅ Deployment completed successfully!"

