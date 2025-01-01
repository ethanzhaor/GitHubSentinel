import requests

def get_recent_updates():
    # GitHub API交互逻辑
    url = "https://api.github.com/repos/yourusername/yourrepo/commits"
    response = requests.get(url)
    
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": "Failed to fetch updates"}
