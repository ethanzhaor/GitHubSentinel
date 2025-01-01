import os

class Config:
    SQLALCHEMY_DATABASE_URI = os.getenv('DATABASE_URL', 'sqlite:///db.sqlite3')
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    GITHUB_API_TOKEN = os.getenv('GITHUB_API_TOKEN')
    NOTIFICATION_METHOD = 'email'  # email, slack, etc.
