# write-french - Evidence and Version History

Benchmark history and per-version rationale. Not needed to apply the skill -
reference for whoever improves it next. See `SKILL.md` for the current rules.


Blind-scored defects per 1000 words, no-skill vs skill, across four
independent topics, registers and genres (informal management coaching,
formal technical craft, formal legal/administrative, impersonal scientific
synthesis):

| Topic | No skill | v1.0.0 | v1.1.0/1.2.0 |
|---|---|---|---|
| Management | 14.5 | 4.6 | 4.41 |
| Pastry technique | 7.26 | 3.64 | 3.14 |
| Tenant rights | 3.87 | 11.3 (regression) | 2.29 |
| Sleep/memory synthesis (held-out) | 8.76 | - | 6.22 |

v1.0.0 helped informal and technical registers but made formal legal French
worse - it missed jargon outside management vocabulary and let idiomatic
swaps drift meaning. v1.1.0 (defect 5's precision-over-idiom guardrail,
generalized defect 3) fixed the regression without hurting the other two,
and held up on a fourth topic never used to derive the fix, including a
genre with no direct address and no actionable-step structure.

**Known limit, confirmed three times across four topics, not fixed by
wording alone:** the skill still lets one field-specific term through
unglossed each time it is tested on a new domain (`pousse` in pastry,
`d'équerre` in a pastry retest, `taille d'effet` here) - a writer fluent
in a field under-flags its own jargon as jargon even when told to check
for it. Category 3's rule is sound; catching this needs a second-pass
reviewer role, not another rewording of the definition.

**v1.3.0 - defects 3 (extended) and 6, held-out topic (formal technical
methodology, dense cross-referenced corpus, a fifth register/genre):**
blind A/B, v1.2.0 vs v1.3.0, each version applied by an independent agent
that saw only its own skill text and a ~1900-word excerpt of an external
French technical methodology guide (not reproduced here - the source
belongs to another repository, not this skill), scored by a third agent
blind to which version produced which output:

| Defect | v1.2.0 (old) | v1.3.0 (new) |
|---|---|---|
| 3 - named refs/internal jargon unglossed | 3.62 | 3.05 |
| 6 - one sentence, several ideas | 5.68 | 2.04 |

Defect 6 dropped by two thirds - v1.2.0 had no rule against it and left 11
of the excerpt's fused sentences untouched; v1.3.0 split 7 of them cleanly.
Defect 3's extended scope (named authors, internal shorthand) moved less -
both versions still let acronym/framework references (PMI, INVEST) through
unglossed, so the fix reduces but does not close that gap. Spot-check of
defects 1, 2, 4, 5 found no regression from the new rules; one anglicism
(« legacy ») happened to survive in the new-skill run and not the old-skill
one, sampling noise rather than a rule conflict.

**v1.3.1 - why PMI/INVEST slipped through, and the fix.** A `craft-prompt`
pass on defect 3's extension found a real wording gap, not executor
carelessness: both worked examples (Cockburn, Patton) are full person names,
so nothing primed the acronym/initialism pattern; and the category's general
test ("would a reader outside the field stumble?") actively argues the wrong
way for a trade acronym - a reader fluent in project management or agile
does not stumble on PMI or INVEST, so applying that test literally says
skip them. Fix: named the acronym/initialism case explicitly alongside named
persons and frameworks, added a dedicated test ("could you write out what
the letters stand for, right now?") that does not defer to field-familiarity,
and added PMI/INVEST as worked table examples. Verified by direct inspection
against the v1.3.0 output rather than a fresh blind rescore: on the same
excerpt used above, PMI and INVEST are the only two named-
reference instances that differ between the two rule texts (every other
instance - Cockburn, Patton, a third uncredited name, the document's own
"adossé" - is governed by wording neither version changed) and both are
now explicitly covered by name and by test. Estimated defect 3: ~2.1/1000w,
down from 3.05 - a further ~30% cut, on top of v1.2.0 -> v1.3.0's ~16%.
No separate isolated executor/scorer agents were available in this session
to rerun the full blind A/B, so this number is a traceable manual count,
not a fresh third-party score - flagged here rather than presented as
equivalent-strength evidence to the table above.

**Cross-topic check, v1.2.0 vs v1.3.1, a second formal-methodology document
(~2050-word excerpt, same external corpus and register as the excerpt
above, different content - technical scoping instead of project
breakdown; not reproduced here, same reason as above):** same manual-count
method as above (no isolated agents available), cataloguing every
fused-sentence and named-reference/acronym candidate against each
version's literal rule text:

| Defect | v1.2.0 (old) | v1.3.1 (new) | vs. guide-2 result |
|---|---|---|---|
| 6 - one sentence, several ideas | ~5.35 (11/11 fused sentences untouched) | ~1.46 (3/11 remain) | Confirmed - comparable or better (-73% vs -64%) |
| 3 - named refs/internal jargon unglossed | high (0/8 named refs glossed - the rule does not exist) | partial (5/8 fixed) | Partially confirmed - the single-name-drop and acronym pattern generalizes, but exposes a new gap: a sentence listing seven bare surnames in one clause (`Nygard, Brown, Fowler, Klein, Cockburn, Fairbanks, Poppendieck`) is a structure neither version's worked examples cover, and three of the seven (Klein, Cockburn, Poppendieck - the ones never mentioned again) stay unglossed under both |

Defect 6 generalizes cleanly to a fresh document - not overfit to the
guide-2 excerpt. Defect 3 generalizes for the pattern it was built to catch
(one named reference embedded in a clause, or a bare acronym) but surfaces
a distinct, not-yet-fixed failure mode: a bare list of several names in one
enumerating sentence. Left as a known gap rather than patched now - it needs
its own worked example and wasn't part of this round's ask.

**v1.4.0 - the writer's own bias toward tightness, caught by direct review, not
a blind A/B.** Applying v1.3.2 by hand to a second real guide surfaced two
sentences an agent judged as legitimate stylistic choices worth preserving - an
elliptical antithesis with an elided verb, and three claims chained by
semicolons - rather than as defects. Both are the pattern this section now
names directly: a writer (human or agent) rewards itself for saying a lot in
few words, and mistakes the resulting density for elegance instead of testing
whether a reader parses it in one pass. Fixed by naming the excuse in defects 2
and 6 directly, adding a worked example of each, and adding a fifth Review Pass
step - a grilling-style interrogation of exactly the sentences the writer is
proud of, since pride is not on the list of things defects 1-6 check for. Not
benchmarked with a fresh blind A/B: the fix responds to two specific,
human-identified misses, not a measured regression, and the next real-guide
test should confirm whether the grill step catches this class going forward.

**v1.4.1 - defect 6 over-detects on dense rhetorical register.** A held-out
test on a rhetorically dense guide (elliptical antitheses, cleft sentences)
found defect 6's literal test - two independent clauses joined at a
conjunction, dash or colon - flagging clean, deliberate constructions
alongside genuinely confusing ones; the grill step (step 5) had no criterion
to tell them apart. Fixed by giving it an explicit default: plain phrasing
over any rhetorical construction, unless demonstrably clearer, not merely
denser - added to step 5, Red Flags and Common Mistakes. Not benchmarked:
this names a discrimination criterion rather than changing the mechanical
tests; the next rhetorical-register test should confirm it converges with
human judgment.

**v1.4.2 - a subject-verb-splitting parenthetical was unnamed.** A blind A/B
outside this skill (`CLAUDE.md`'s reader-clarity rule, RETROSPECTIVE.md
2026-08-30) produced a French paragraph with a dash-set-off aside between a
subject and its verb; neither defect 6 (needs two fused independent clauses)
nor step 5's named constructions (cleft sentence, elliptical antithesis)
caught it. Added as a third named construction to step 5, Red Flags and
Common Mistakes, plus an `alors que`/`tandis que` worked example to defect
6 - none of its prior rows used a contrast conjunction. Not benchmarked: the
next test involving a parenthetical aside should confirm it's now caught.
