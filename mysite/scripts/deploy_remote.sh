#!/bin/bash
set -euo pipefail

PROJECT_DIR="/home/vagrant/django_git/mysite"
REPO_URL="https://github.com/chlwjddn20042/django_test.git"
BRANCH="main"

echo "[INFO] Deploy script started..."

# 디렉토리 없으면 생성
mkdir -p "$PROJECT_DIR"

cd "$PROJECT_DIR"

if [ -d ".git" ]; then
  echo "[INFO] Existing repo found. Pulling latest changes..."
  git fetch origin "$BRANCH"
  git reset --hard "origin/$BRANCH"
else
  echo "[INFO] No git repo found. Cloning fresh repository..."
  rm -rf "$PROJECT_DIR"/*  # 혹시 잔여 파일 있을 경우 정리
  git clone -b "$BRANCH" "$REPO_URL" "$PROJECT_DIR"
  cd "$PROJECT_DIR"
fi

echo "[INFO] Installing dependencies..."
pip3 install -r requirements.txt

echo "[INFO] Restarting Django runserver..."
pkill -f "python3 manage.py runserver" || true
nohup python3 manage.py runserver 0.0.0.0:8000 > server.log 2>&1 &

echo "[INFO] ✅ Deployment completed successfully!"

