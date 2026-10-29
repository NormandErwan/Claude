**C) Leave it `[Heuristic]` and do something else about the client's objection.**

Gate 3 is explicit that it never yields to deadline pressure, and the evidence rules are just as explicit: "no label without opening the source... in this session." I don't have ISO 9001 open, and can't get it before 08:00. "Everyone knows clause 8.4 requires this" is precisely the pattern the skill calls out — a recollection, not a verification — and it's a trap here for a second reason even if I *could* open the standard tonight: ISO 9001:2015 clause 8.4 requires the organization to determine criteria for evaluation, selection, monitoring and re-evaluation of external providers, but it does not itself prescribe a numeric interval like 24 months. That number is your organization's own risk-based choice. Labeling it `[Standard]` wouldn't just be unverified tonight — it would very likely be **false** even after verification, because the standard doesn't set the figure. Attaching `[Standard]` to it is the exact failure mode `evidence.md` warns about: "cite a standard only for what it standardises." A quality manager who knows clause 8.4 well is the person most likely to catch that mismatch and use it to discredit the rest of the document.

The stronger move for tomorrow is to make the heuristic's relationship to the standard explicit rather than pretend the standard hands you the number:

```
A supplier is re-audited every 24 months.  [Heuristic]
    (ISO 9001 clause 8.4 requires periodic re-evaluation of external
     providers but leaves the interval to the organization; 24 months
     is our own risk-based cadence, consistent with 8.4's intent.)
```

This keeps the label honest, pre-empts the objection by showing you understand clause 8.4 correctly (evaluation is mandated, the interval is not), and reframes the client's likely attack — "this isn't in the standard" — into something you already conceded and contextualized, which is far harder to use against the rest of the guide.
