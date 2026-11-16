# Numbered sequence, no skill or doc prescribes it.
mkdir -p docs/postmortems
printf '# 001 - Database disk full\n\n2026-09-02: writes failed 40 min.\n' > docs/postmortems/001-database-disk-full.md
printf '# 002 - Payment webhook timeout\n\n2026-10-14: 120 orders stuck.\n' > docs/postmortems/002-payment-webhook-timeout.md
