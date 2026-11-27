# Réunion du 27 novembre 2026 : décisions

## Décisions

1. **Durée de vie des paniers (TTL, « time to live »)** : elle passe à 72 h. Elle est aujourd'hui de 24 h (voir `cart-ttl.md`).
2. **Base de données** : on ajoute un index sur la colonne `orders.created_at`.
3. **Remboursements partiels** : Paul reprend le ticket correspondant.

## Suites à donner

- Mettre à jour `cart-ttl.md` quand le changement de TTL est appliqué.
- Écrire la migration qui crée l'index sur `orders.created_at`.
