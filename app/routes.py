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
