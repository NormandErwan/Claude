I'm opening a pull request on our internal Python library `fetchkit` and need the PR description. Write it to `outputs/pr-body.md`.

Background from my notes:
- Last week the nightly `catalog-sync` job failed 4 times out of 7. Each time, the supplier API answered HTTP 429 (too many requests) during the burst at 02:00 and `fetchkit` raised immediately.
- The supplier's status page, https://status.supplier.example/limits, gave the limit as 600 requests per minute when I looked on 2026-11-26.
- I picked 3 retries because the 429 bursts in the logs never lasted more than about 2 seconds, and 0.5 s base delay doubling gives 0.5 + 1 + 2 = 3.5 s of total wait, which covers that.
- Retrying a POST could create duplicate orders on the supplier side, so I left POST alone on purpose.
- Tests pass locally (`pytest`, 41 passed).

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
