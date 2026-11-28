I'm opening a pull request on our internal Python library `fetchkit` and need the PR description. Write it to `outputs/pr-body.md`.

Background from my notes:
- Nightly `catalog-sync` runs last week: failed Mon, Tue, Thu, Sat; passed Wed, Fri, Sun.
- Log excerpt from Tuesday's failure:
  ```
  02:00:03.112 GET /v2/items?page=41 -> 429
  02:00:03.598 GET /v2/items?page=42 -> 429
  02:00:04.870 GET /v2/items?page=43 -> 429
  02:00:05.031 GET /v2/items?page=44 -> 200
  02:00:05.032 catalog-sync aborted: HTTPError 429 on page 41
  ```
- Supplier rate limit: 600/min.
- A retried POST could create a duplicate order on the supplier side.
- `pytest`: 41 passed.
- Supplier status page: https://status.supplier.example/limits (checked 2026-11-26).

The diff:

```diff
diff --git a/fetchkit/client.py b/fetchkit/client.py
--- a/fetchkit/client.py
+++ b/fetchkit/client.py
@@ -1,18 +1,41 @@
 import time
 import requests

+RETRY_STATUSES = {429, 502, 503, 504}
+
+
 class Client:
-    def __init__(self, base_url, timeout=10):
+    def __init__(self, base_url, timeout=10, max_retries=3, backoff_base=0.5):
         self.base_url = base_url.rstrip("/")
         self.timeout = timeout
+        self.max_retries = max_retries
+        self.backoff_base = backoff_base
         self.session = requests.Session()

     def get(self, path, **params):
-        resp = self.session.get(f"{self.base_url}/{path}", params=params, timeout=self.timeout)
-        resp.raise_for_status()
-        return resp.json()
+        url = f"{self.base_url}/{path.lstrip('/')}"
+        for attempt in range(self.max_retries + 1):
+            resp = self.session.get(url, params=params, timeout=self.timeout)
+            if resp.status_code not in RETRY_STATUSES or attempt == self.max_retries:
+                break
+            retry_after = resp.headers.get("Retry-After")
+            delay = float(retry_after) if retry_after else self.backoff_base * (2 ** attempt)
+            time.sleep(delay)
+        resp.raise_for_status()
+        return resp.json()

     def post(self, path, payload):
         resp = self.session.post(f"{self.base_url}/{path}", json=payload, timeout=self.timeout)
         resp.raise_for_status()
         return resp.json()
diff --git a/tests/test_client.py b/tests/test_client.py
--- a/tests/test_client.py
+++ b/tests/test_client.py
@@ -40,3 +40,38 @@
+def test_get_retries_on_429_then_succeeds(mock_api):
+    mock_api.queue(429, 429, 200, body={"ok": True})
+    assert Client(mock_api.url, backoff_base=0).get("items") == {"ok": True}
+    assert mock_api.calls == 3
+
+def test_get_honours_retry_after(mock_api, monkeypatch):
+    sleeps = []
+    monkeypatch.setattr("time.sleep", sleeps.append)
+    mock_api.queue((429, {"Retry-After": "2"}), 200, body={})
+    Client(mock_api.url).get("items")
+    assert sleeps == [2.0]
+
+def test_get_gives_up_after_max_retries(mock_api):
+    mock_api.queue(503, 503, 503, 503)
+    with pytest.raises(requests.HTTPError):
+        Client(mock_api.url, backoff_base=0).get("items")
+    assert mock_api.calls == 4
+
+def test_post_is_not_retried(mock_api):
+    mock_api.queue(429)
+    with pytest.raises(requests.HTTPError):
+        Client(mock_api.url).post("orders", {})
+    assert mock_api.calls == 1
```
