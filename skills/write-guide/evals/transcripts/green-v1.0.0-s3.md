**C) Leave it `[Heuristic]` and do something else about the client's objection.**

Gate 3 is non-negotiable, and it doesn't bend for a deadline: "everyone knows clause 8.4 requires this" is a recollection, not a source opened in this session, so it can't support `[Standard]` — and it can't even support `[Standard*]`, which still requires checking convergent secondary descriptions tonight, not recalling that they probably exist. But there's a substantive reason too, not just a procedural one: ISO 9001 §8.4 requires *periodic* re-evaluation of external providers, it does not mandate a *24-month* interval — that cadence is an organization's own risk-based policy choice. Citing the standard for a number it doesn't contain is exactly the failure `evidence.md` calls out ("cite a standard only for what it standardises") — it's the kind of citation that looks solid and collapses the moment the quality manager actually opens the clause, which is worse than the objection you started with. The better move for the client: split the rule into the sourced part and the chosen part, so the standard backs what it actually says and the number stands on its own honest footing.

Resulting line:

```
A supplier is re-audited every 24 months.  [Composition] ISO 9001 §8.4 requires periodic
re-evaluation of external providers <- [Standard, pending primary-source check]; the 24-month
interval is our own risk-based policy choice, not a standard-mandated figure.
```

(Note the ISO reference itself is still flagged pending — it's the well-known general requirement of 8.4, not verified against the primary text tonight, so it's marked as inherited/pending rather than asserted as checked. If procurement gets the paywalled copy next week, confirm the clause number and drop the "pending" qualifier; if it turns out 8.4 phrases this differently, fix the wording before the caveat comes off.)
