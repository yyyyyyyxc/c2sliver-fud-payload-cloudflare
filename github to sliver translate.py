
import requests, json, time, base64
from flask import Flask, request

GITHUB_TOKEN = "token"
REPO = "username/c2backup"
HEADERS = {"Authorization": f"token {GITHUB_TOKEN}"}

def create_issue(title, body):
    url = f"https://api.github.com/repos/{REPO}/issues"
    data = {"title": title, "body": body}
    requests.post(url, headers=HEADERS, json=data)

def get_issue_comments(issue_number):
    url = f"https://api.github.com/repos/{REPO}/issues/{issue_number}/comments"
    resp = requests.get(url, headers=HEADERS)
    return resp.json()
