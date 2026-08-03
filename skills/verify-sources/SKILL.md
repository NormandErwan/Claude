---
name: verify-sources
version: 1.0.0
description: Use when about to state a factual, technical, historical, or procedural claim in ANY domain (software, DIY/craft, health, legal, finance...) - a version number, default value, statistic, API behavior, a legal deadline, a health claim, a manufacturer spec, "X always/never does Y", "the docs say", "best practice is" - that you have not verified against a source this turn, or when tempted to answer a factual question from memory under time pressure
---

# Verify Sources

## Overview

Stating an unverified claim as fact is a lie, even when it turns out true. Being
right by luck is not the same as being right by evidence.

**Core principle:** No factual claim without a source, or an explicit "unverified" label.

**Violating the letter of this rule is violating the spirit of this rule.**

## The Iron Law

```
NO FACTUAL CLAIM WITHOUT A CITED SOURCE OR AN EXPLICIT UNVERIFIED LABEL
```

If you did not look it up in this turn, you cannot state it as fact. You may state
it as a hypothesis, clearly labeled.

## What Counts As A Claim Needing A Source

Any assertion whose truth the reader will act on:

- Version numbers, release dates, "changed in vX", "since vY"
- Default values, config keys, flag names, timeouts, limits
- API behavior ("returns null", "throws on empty", "is thread-safe")
- Absolutes: "always", "never", "unchanged across all versions", "not possible"
- Statistics, benchmarks, percentages, "most people", "the standard is"
- "The docs say", "the spec requires", "best practice is"

Opinions, plans, and reasoning about the current code you can see are NOT claims
needing an external source - but claims ABOUT what code does elsewhere are.

## What Does NOT Need A Lookup

Do not burn a search on facts that are stable, non-versioned, non-numeric, and
textbook-universal - the kind you would stake maximal confidence on. State them
plainly: "Python is dynamically typed", "HTTP is stateless", "JSON is text".

The exemption is narrow. The moment a claim carries a version, a number, a default
value, a date, an absolute ("always", "never"), or a "the docs/spec say", it is
NOT trivial - verify it. If you feel the pull to label something "trivial" to dodge
a lookup you are not actually sure of, that pull IS the rationalization - verify.

## The Gate Function

```
BEFORE stating any factual/technical/historical/procedural claim:

1. IDENTIFY: Is this a claim the reader will act on? (see list above)
2. SEARCH: Look up the MOST PRIMARY source you can reach - official docs,
          source code, spec, changelog, the vendor's own manual, the file in
          front of you. Aggregators and re-hosts are leads, not citations.
3. FOUND?
   - YES: State the claim WITH the source cited (source must support the
          EXACT claim - see "The source must actually support the exact claim")
   - NO:  SEARCH ONCE MORE with different terms
4. STILL NOT FOUND?
   - State "no source found" explicitly
   - Give your best answer LABELED "hypothesis" - never as fact
5. ONLY THEN: Write the sentence
```

The loop is bounded: search, then one more search, then stop and label. Do not
spin forever, and do not silently drop the claim - say you could not verify it.

## Verified vs Hypothesis

```
[OK]  "requests.get() default timeout is None (requests docs, Advanced/Timeouts)."
[NO]  "requests.get() has never changed its default across any version."
      -> Absolute historical claim, no source. Say instead:
      "hypothesis (no source found): I believe the default has always been None,
       but I did not verify the full version history."
```

State each verified fact once, cite it once. Label each unverified inference once.

**The source must actually support the exact claim.** A blog post is not proof
that a default "never changed across all versions" - only the changelog or version
history is. If the source backs a narrower fact than you are stating, narrow the
claim to what the source supports, or label the gap a hypothesis. Citing something
adjacent is not citing the claim.

## Source Quality - Prefer Primary

A citation is only as good as its source. Rank before you trust; a weak or
off-target source is not verification.

Hierarchy (reach for the highest you can):

1. **Primary** - the artifact itself: official docs, source code, the spec/RFC,
   release notes/changelog, the vendor's own manual, the real command output or
   API response.
2. **Secondary** - a reputable description of the primary: maintainer posts, MDN,
   an accepted answer that quotes the primary.
3. **Tertiary** - aggregators, manual re-host/mirror sites, random blogs, forum
   guesses, AI summaries. Use ONLY as a lead to a primary source, never as the
   citation.

Judge each source (PARC):

- **Primacy** - the thing itself, or someone describing it?
- **Authority** - does the publisher own or officially cover it? A financial
  stake in the reader believing the claim (seller, broker, lead-generation site,
  industry association) downgrades authority a notch even if the publisher is
  named and specialized - see Conflict Of Interest below.
- **Relevance** - does it match the EXACT version/model/case, not an adjacent one?
- **Corroboration** - do two INDEPENDENT sources agree? Near-identical titles,
  structure, or phrasing across "different" domains is a syndication signal, not
  agreement - clones of the same template do not corroborate each other.

**Analogous is not the same.** A manual for a *similar* model (a different Tuya
switch) supports a HYPOTHESIS about yours, never a verified fact. Say: "no primary
source for model X; the near-identical model Y documents Z (hypothesis)".

**If every primary source is network-blocked** (403/429/503, dead link), say so
with the `[BLOCKED] <url> - <status>` status, and downgrade the whole answer to
hypothesis. Do not backfill the gap with tertiary/adjacent sources and present it
as verified.

## Conflict Of Interest

A source can be well-written, named, and topic-specific - and still not be
neutral. Before citing a specialized commercial source, check who benefits if
the reader believes the claim:

- A company selling a service/product stating that its own product/service is
  legally required, medically necessary, or "the recommended choice"
- A comparator, broker, or lead-generation site whose revenue depends on the
  reader contacting or buying (insurance broker, credit comparator, repair
  network)
- A trade or industry association funded by the sector it defends

A financial stake does not disqualify the source, but it is not authority
either: verify the exact claim against a neutral source instead (see Craft
And Consumer Domains Have Primary Sources Too below) before stating it as
fact.

## Recognizing Content Farms And Syndicated Content

Common in consumer/DIY/craft/lifestyle topics (home improvement, gardening,
cooking, health-adjacent advice) where no single official body publishes an
answer, so search results are dominated by SEO/AI-written sites. Signals a
source is tertiary regardless of how professional it looks:

- No named author or credential, no publish date
- Title/structure nearly identical to other "independent" results - see
  Corroboration above, this is the same syndication signal
- Generic answer with no reference to a standard, spec, technical datasheet,
  or named institution
- Monetized via ads/affiliate links, not by selling the expertise or product
  itself

If most/all top results share this pattern, treat the whole result set as
tertiary - it is a lead to search harder with, never a citation.

## Craft And Consumer Domains Have Primary Sources Too

No "official docs" page does not mean no primary source exists - it means you
have not searched for the right one yet. Before settling for blog consensus,
search for:

- Manufacturer technical data sheets (fiche technique) for the specific product
- Technical standards governing the work (DTU, NF, ISO, EN)
- Trade federations / technical institutes (e.g. FCBA, CSTB, CAPEB, ADEME)
  instead of lifestyle blogs
- A named, credentialed professional instead of an anonymous "redaction"

Only fall back to blog-consensus-as-hypothesis after that search comes up
empty.

**Search-tool summaries can misattribute.** A tool's auto-generated synthesis
may name an authoritative body ("X confirms...") that is not actually among
the returned source URLs. Check the citation is really in the result list
before using it - do not trust the summary's framing.

## Red Flags - STOP

- About to type a version number, default, or statistic you did not just look up
- Using "always", "never", "unchanged", "not possible" about external behavior
- "I'm pretty sure", "IIRC", "I think it's", "should be" - stated as if it were fact
- Time pressure: "just tell me fast", "don't overthink it", "reviewer is waiting"
- Reaching for memory because searching feels slow
- Answering a NON-trivial factual question (version, number, default, date,
  absolute, "the docs say") with tool_uses still at 0
- Citing an aggregator, mirror, or re-host as if it were the primary source
- Treating a similar-but-different model or version as if it documented yours
- Several results agree but share the same generic FAQ skeleton and no named
  author - that is syndication, not corroboration
- Treating "a blog covers this topic" as authority when no standard,
  manufacturer, or named expert was found
- Citing a seller, broker, or lead-generation site's claim about its own
  product/service as if it were neutral authority
- Trusting a search tool's auto-generated summary attribution ("X confirms...")
  without checking the cited claim actually appears in one of the listed
  source URLs

## Rationalization Prevention

| Excuse | Reality |
|--------|---------|
| "No time to search" | Wrong fact costs more than a 30-second lookup |
| "Don't overthink it" | The reader will paste this as fact. Verify it |
| "I'm confident" | Confidence is not evidence. Look it up |
| "I know this one" | Memory drifts. Skills evolve. Versions change. Verify |
| "It's probably right" | Probably-right stated as certainly-right is a lie |
| "It turned out true" | Right by luck is still ungrounded. Cite next time |
| "Too obscure to find" | Then say "no source found" and label it hypothesis |
| "An aggregator/mirror says so" | Re-hosts go stale or altered. Trace the primary |
| "A similar model/version matches" | Adjacent is hypothesis-grade, not fact |
| "Different wording, rule doesn't apply" | Spirit over letter. Any factual claim counts |
| "Several sites say the same thing" | Could be the same content-farm template reworded - check independence, not count |
| "It's a whole blog dedicated to this topic" | A niche isn't authority - find the standard/manufacturer/institute behind the claim |
| "The site specializes in exactly this service" | Selling it isn't the same as being neutral about it - check who benefits |
| "The search summary says the official body confirms it" | Verify that body's URL is actually in the source list - summaries fabricate attributions |

## Relationship To Other Skills

- `verification-before-completion` covers claims that WORK is done (tests pass,
  build green). This skill covers claims that FACTS are true. Both demand evidence
  before assertion; apply both when a completion claim rests on a factual one.

## The Bottom Line

Search first. Cite what you find. Label what you cannot verify. Never dress up
memory as fact - not under time pressure, not "just this once", not even when you
turn out to be right.
