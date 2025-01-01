from flask import Flask
from app.routes import setup_routes

def create_app():
    app = Flask(__name__)
    
    # 加载配置
    app.config.from_pyfile('config/config.py')

    # 初始化路由
    setup_routes(app)

    return app
