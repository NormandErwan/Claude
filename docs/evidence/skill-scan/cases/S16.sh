cat > src/client.py <<'PY'
import httpx


def fetch_user(base_url, user_id):
    resp = httpx.get(f"{base_url}/users/{user_id}", timeout=5.0)
    resp.raise_for_status()
    return resp.json()
PY
printf 'httpx>=0.27\n' > requirements.txt
