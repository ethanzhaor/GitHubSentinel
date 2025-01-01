from app.models.subscription import Subscription
from data.database import db_session

def add_subscription(repo_url):
    # 保存订阅信息到数据库
    subscription = Subscription(repo_url=repo_url)
    db_session.add(subscription)
    db_session.commit()
