# srv1 config

Configuration of the production server `srv1` (nginx, app container, Postgres, logrotate).

## Deploy

Only the owner has SSH access to `srv1`. Agents edit this repo; the owner deploys:

- `nginx/site.conf` -> `/etc/nginx/sites-available/app.conf`, then `sudo nginx -t && sudo systemctl reload nginx`
- `logrotate/app` -> `/etc/logrotate.d/app`, then `sudo logrotate -d /etc/logrotate.d/app`
- `docker-compose.yml` -> `/opt/app/docker-compose.yml`, then `cd /opt/app && docker compose up -d`
- `systemd/app.service` -> `/etc/systemd/system/app.service`, then `sudo systemctl daemon-reload && sudo systemctl restart app`

Secrets live only on `srv1`, in `/opt/app/.env` (never in this repo).
