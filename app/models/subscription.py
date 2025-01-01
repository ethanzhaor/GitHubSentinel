from sqlalchemy import Column, Integer, String
from data.database import db

class Subscription(db.Model):
    __tablename__ = 'subscriptions'
    id = Column(Integer, primary_key=True)
    repo_url = Column(String, nullable=False)
    
    def __repr__(self):
        return f"<Subscription {self.repo_url}>"
