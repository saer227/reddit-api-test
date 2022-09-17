import requests
from robot.api.deco import keyword

TOKEN = None

def get_reddit_token():
    auth = requests.auth.HTTPBasicAuth('vmqyq-8calokNi56zCTjyw', '3WAzGa-wTOs_TmC3Wzt9XlYzN5Xssw')
    data = {'grant_type': 'password',
            'username': 'Gold-Perception-451',
            'password': 'RF2022TestingPassword1'}
    headers = {'User-Agent': 'RF-API-test/0.0.1'}
    res = requests.post('https://www.reddit.com/api/v1/access_token', auth=auth, data=data, headers=headers)
    global TOKEN
    TOKEN = res.json()['access_token']

@keyword
def find_reddit_thread(thread_id: str):
    if TOKEN is None:
        get_reddit_token()
    headers = {'User-Agent': 'RF-API-test/0.0.1', 'Authorization': f"bearer {TOKEN}"}
    res = requests.get(f"https://oauth.reddit.com/by_id/t3_{thread_id}", headers=headers)
    return res.json()['data']['children'][0]['data']['url']

@keyword
def create_reddit_comment(thread_id: str, comment_text: str = "Test comment."):
    if TOKEN is None:
        get_reddit_token()
    headers = {'User-Agent': 'RF-API-test/0.0.1', 'Authorization': f"bearer {TOKEN}"}
    data = {'parent': f't3_{thread_id}', 'text': comment_text}
    res = requests.post("https://oauth.reddit.com/api/comment", data=data, headers=headers)
    return res.json()['jquery'][18][3][0][0]['data']['id']

@keyword
def delete_reddit_comment(comment_id: str):
    if TOKEN is None:
        get_reddit_token()
    headers = {'User-Agent': 'RF-API-test/0.0.1', 'Authorization': f"bearer {TOKEN}"}
    data = {'id': f't1_{comment_id}'}
    res = requests.post("https://oauth.reddit.com/api/del", data=data, headers=headers)
