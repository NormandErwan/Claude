# Repo doc prescribes an undated name; no numbered sequence, no skill.
mkdir -p docs/reports
cat > docs/README.md <<'MD'
# Docs

- `architecture.md`: system overview.
- `reports/`: one load-test report per service, named `<service>-load-test.md`. A new run replaces the previous report of that service; git history keeps the old ones.
MD
