#!/bin/bash
set -e

echo "==> Starting remote Django deployment..."

PROJECT_DIR="/home/vagrant/django_git/mysite"
REPO_URL="https://github.com/chlwjddn20042/django_test.git"
BRANCH="main"

# ensure git repo exists
if [ ! -d "$PROJECT_DIR/.git" ]; then
  echo "==> Cloning repository..."
  git clone -b $BRANCH $REPO_URL $PROJECT_DIR
else
  echo "==> Pulling latest code..."
  cd $PROJECT_DIR
  git pull origin $BRANCH
fi

cd $PROJECT_DIR

# create virtual environment if not exists
if [ ! -d "venv" ]; then
  echo "==> Creating Python virtual environment..."
  python3 -m venv venv
fi

source venv/bin/activate

# install dependencies
echo "==> Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

# run Django server
echo "==> Starting Django server..."
nohup python manage.py runserver 0.0.0.0:8000 > server.log 2>&1 &
echo "==> Django server started successfully."

