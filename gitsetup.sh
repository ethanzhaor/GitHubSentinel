#!/bin/bash

# 设置项目根目录
PROJECT_DIR="GitHubSentinel"

# 创建项目目录结构
mkdir -p $PROJECT_DIR/{app/{services,models},config,data,migrations}

# 进入项目目录
cd $PROJECT_DIR

# 创建基础文件
touch run.py
touch requirements.txt
touch Dockerfile

# 创建 app/__init__.py
cat > app/__init__.py <<EOL
from flask import Flask
from app.routes import setup_routes

def create_app():
    app = Flask(__name__)
    
    # 加载配置
    app.config.from_pyfile('config/config.py')

    # 初始化路由
    setup_routes(app)

    return app
EOL

# 创建 app/routes.py
cat > app/routes.py <<EOL
from flask import request, jsonify
from app.services import github_service, subscription_service

def setup_routes(app):
    @app.route("/subscribe", methods=["POST"])
    def subscribe():
        data = request.get_json()
        repo_url = data.get("repo_url")
        # 调用订阅服务
        subscription_service.add_subscription(repo_url)
        return jsonify({"message": "Subscription added"}), 200

    @app.route("/get_updates", methods=["GET"])
    def get_updates():
        updates = github_service.get_recent_updates()
        return jsonify(updates), 200
EOL

# 创建 app/services/github_service.py
cat > app/services/github_service.py <<EOL
import requests

def get_recent_updates():
    # GitHub API交互逻辑
    url = "https://api.github.com/repos/yourusername/yourrepo/commits"
    response = requests.get(url)
    
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": "Failed to fetch updates"}
EOL

# 创建 app/services/subscription_service.py
cat > app/services/subscription_service.py <<EOL
from app.models.subscription import Subscription
from data.database import db_session

def add_subscription(repo_url):
    # 保存订阅信息到数据库
    subscription = Subscription(repo_url=repo_url)
    db_session.add(subscription)
    db_session.commit()
EOL

# 创建 app/services/notification_service.py
cat > app/services/notification_service.py <<EOL
# Placeholder for notification logic (email, slack, etc.)
EOL

# 创建 app/services/report_service.py
cat > app/services/report_service.py <<EOL
# Placeholder for report generation logic
EOL

# 创建 app/models/subscription.py
cat > app/models/subscription.py <<EOL
from sqlalchemy import Column, Integer, String
from data.database import db

class Subscription(db.Model):
    __tablename__ = 'subscriptions'
    id = Column(Integer, primary_key=True)
    repo_url = Column(String, nullable=False)
    
    def __repr__(self):
        return f"<Subscription {self.repo_url}>"
EOL

# 创建 app/models/update.py
cat > app/models/update.py <<EOL
# Placeholder for update model
EOL

# 创建 config/config.py
cat > config/config.py <<EOL
import os

class Config:
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL', 'sqlite:///db.sqlite3')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    GITHUB_API_TOKEN = os.getenv('GITHUB_API_TOKEN')
    NOTIFICATION_METHOD = 'email'  # email, slack, etc.
EOL

# 创建 data/database.py
cat > data/database.py <<EOL
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def init_db(app):
    db.init_app(app)
EOL

# 创建 migrations 目录（数据库迁移文件将存储在此）
mkdir migrations

# 创建 requirements.txt
cat > requirements.txt <<EOL
Flask
Flask-SQLAlchemy
requests
celery
EOL

# 创建 Dockerfile
cat > Dockerfile <<EOL
# 使用Python官方镜像
FROM python:3.9-slim

# 设置工作目录
WORKDIR /app

# 复制requirements.txt并安装依赖
COPY requirements.txt .

RUN pip install -r requirements.txt

# 复制整个项目
COPY . .

# 设置Flask环境变量
ENV FLASK_APP=run.py
ENV FLASK_ENV=development

# 设置容器启动命令
CMD ["flask", "run", "--host=0.0.0.0"]
EOL

# 输出完成信息
echo "Project structure has been set up successfully!"

