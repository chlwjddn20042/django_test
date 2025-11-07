#!/bin/bash
set -e

echo "[INFO] Deploy script started..."

PROJECT_DIR="/home/vagrant/django_git/mysite"
REPO_URL="https://github.com/chlwjddn20042/django_test.git"
BRANCH="main"

cd $PROJECT_DIR

# Git repo 없으면 clone, 있으면 fetch + reset
if [ ! -d ".git" ]; then
    echo "[INFO] No repo found. Cloning fresh..."
    git clone -b $BRANCH $REPO_URL .
else
    echo "[INFO] Existing repo found. Fetching latest changes..."
    git fetch origin $BRANCH
    git reset --hard origin/$BRANCH
fi

# Python dependencies
echo "[INFO] Installing dependencies..."
pip install --user -r requirements.txt

# 서버 재시작
echo "[INFO] Restarting Django runserver..."
pkill -f "python manage.py runserver" || true
nohup python3 manage.py runserver 0.0.0.0:8000 > server.log 2>&1 &

echo "[INFO] ✅ Deployment completed successfully!"

