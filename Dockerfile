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
