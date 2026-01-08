"""Debug Audi API connection - using the modern audiconnectpy approach."""
import hashlib
import base64
import secrets
import logging
import requests
import re
import json
from urllib.parse import urljoin, parse_qs, urlparse

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

USERNAME = "borismulder91@gmail.com"
PASSWORD = "!Zondag22"

session = requests.Session()
session.headers.update({
    "User-Agent": "myAudi-Android/4.31.0 (Android 14; SDK 34)",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8",
    "Accept-Language": "en-US,en;q=0.5",
})

# Constants from audiconnect
CLIENT_ID = "09b6cbec-cd19-4589-82fd-363dfa8c24da@apps_vw-dilab_com"
REDIRECT_URI = "myaudi:///"
CARIAD_URL = "https://emea.bff.cariad.digital"

def generate_pkce():
    """Generate PKCE code verifier and challenge."""
    code_verifier = secrets.token_urlsafe(64)[:64]
    code_challenge = base64.urlsafe_b64encode(
        hashlib.sha256(code_verifier.encode()).digest()
    ).decode().rstrip("=")
    return code_verifier, code_challenge

# Step 1: Get OpenID configuration
print("=" * 60)
print("Step 1: Fetching OpenID configuration...")
oidc_url = f"{CARIAD_URL}/login/v1/idk/openid-configuration"
response = session.get(oidc_url)
print(f"Status: {response.status_code}")
oidc = response.json()
auth_endpoint = oidc.get("authorization_endpoint")
token_endpoint = oidc.get("token_endpoint")
print(f"Auth endpoint: {auth_endpoint}")
print(f"Token endpoint: {token_endpoint}")

# Step 2: Start authorization with PKCE
print("\n" + "=" * 60)
print("Step 2: Starting authorization with PKCE...")
code_verifier, code_challenge = generate_pkce()
state = secrets.token_urlsafe(16)
nonce = secrets.token_urlsafe(16)

auth_params = {
    "client_id": CLIENT_ID,
    "response_type": "code",
    "redirect_uri": REDIRECT_URI,
    "scope": "openid profile mbb",
    "state": state,
    "nonce": nonce,
    "code_challenge": code_challenge,
    "code_challenge_method": "S256",
}

response = session.get(auth_endpoint, params=auth_params, allow_redirects=True)
print(f"Status: {response.status_code}")
print(f"URL: {response.url[:100]}...")

if response.status_code != 200:
    print(f"Error: {response.text[:500]}")
    exit(1)

# Parse the email form
from html.parser import HTMLParser

class EmailFormParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self._inside_form = False
        self.target = None
        self.data = {}

    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        if tag == "form" and attrs_dict.get("id") == "emailPasswordForm":
            self._inside_form = True
            self.target = attrs_dict.get("action")
        elif tag == "input" and self._inside_form:
            name = attrs_dict.get("name")
            value = attrs_dict.get("value", "")
            if name:
                self.data[name] = value or ""

parser = EmailFormParser()
parser.feed(response.text)
print(f"Email form action: {parser.target}")
print(f"Email form fields: {list(parser.data.keys())}")

# Step 3: Submit email
print("\n" + "=" * 60)
print("Step 3: Submitting email...")
parser.data["email"] = USERNAME
email_url = urljoin("https://identity.vwgroup.io", parser.target)
response = session.post(email_url, data=parser.data, allow_redirects=True)
print(f"Status: {response.status_code}")

# Step 4: Parse and submit password
print("\n" + "=" * 60)
print("Step 4: Submitting password...")

# Find templateModel in script
match = re.search(r"templateModel: (.*?),\n", response.text)
if match:
    model = json.loads(match.group(1))
    post_action = model.get("postAction")
    form_data = {
        "relayState": model.get("relayState"),
        "hmac": model.get("hmac"),
        "email": USERNAME,
        "password": PASSWORD,
    }
    csrf_match = re.search(r"csrf_token: '([^']+)'", response.text)
    if csrf_match:
        form_data["_csrf"] = csrf_match.group(1)

    print(f"Password form action: {post_action}")
    password_url = f"https://identity.vwgroup.io/signin-service/v1/{CLIENT_ID}/{post_action}"
    response = session.post(password_url, data=form_data, allow_redirects=False)
    print(f"Status: {response.status_code}")
    print(f"Location: {response.headers.get('Location', 'N/A')[:100]}...")

    # Step 5: Follow redirects to get the code
    print("\n" + "=" * 60)
    print("Step 5: Following redirects...")
    url = response.headers.get("Location", "")
    for i in range(20):
        if not url:
            break
        if url.startswith("myaudi://"):
            print(f"Got redirect to myaudi://")
            parsed = urlparse(url)
            params = parse_qs(parsed.query)
            code = params.get("code", [None])[0]
            print(f"Authorization code: {code[:50] if code else 'None'}...")

            # Step 6: Exchange code for tokens
            print("\n" + "=" * 60)
            print("Step 6: Exchanging code for tokens...")
            token_data = {
                "grant_type": "authorization_code",
                "client_id": CLIENT_ID,
                "code": code,
                "redirect_uri": REDIRECT_URI,
                "code_verifier": code_verifier,
            }
            response = session.post(token_endpoint, data=token_data)
            print(f"Status: {response.status_code}")
            if response.status_code == 200:
                tokens = response.json()
                print(f"Access token: {tokens.get('access_token', '')[:50]}...")
                print(f"ID token: {tokens.get('id_token', '')[:50]}...")
                print(f"Expires in: {tokens.get('expires_in')}")
                print(f"Refresh token: {'Yes' if tokens.get('refresh_token') else 'No'}")
            else:
                print(f"Error: {response.text[:500]}")
            break

        full_url = url if url.startswith("http") else urljoin("https://identity.vwgroup.io", url)
        response = session.get(full_url, allow_redirects=False)
        print(f"  [{i}] {response.status_code} -> {response.headers.get('Location', 'N/A')[:80]}...")

        if response.status_code in (302, 303):
            url = response.headers.get("Location", "")
        elif response.status_code == 200:
            match = re.search(r'(myaudi://[^"\'<>\s]+)', response.text)
            if match:
                url = match.group(1)
            else:
                print("No redirect found in body")
                break
        else:
            print(f"Unexpected status")
            break
else:
    print("Could not find templateModel")
