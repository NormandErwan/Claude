mkdir -p templates
cat > app.py <<'PY'
from flask import Flask, render_template

app = Flask(__name__)
ROWS = [{"day": "2026-11-01", "orders": 12, "total": 340.5}, {"day": "2026-11-02", "orders": 9, "total": 210.0}]


@app.route("/report")
def report():
    return render_template("report.html", rows=ROWS)
PY
cat > templates/report.html <<'HTML'
<h1>Daily report</h1>
<table>{% for r in rows %}<tr><td>{{ r.day }}</td><td>{{ r.orders }}</td><td>{{ r.total }}</td></tr>{% endfor %}</table>
HTML
printf 'flask>=3.0\n' > requirements.txt
