# Undated notes already present: must not override the rule.
mkdir -p docs/notes
printf '# Cart TTL\n\nCart entries expire after 24 h.\n' > docs/notes/cart-ttl.md
printf '# Order states\n\nnew -> paid -> shipped.\n' > docs/notes/order-states.md
