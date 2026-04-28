# Inferred Axioms Plan

Materialise OWL inferences using SPARQL CONSTRUCT queries. Run queries in the order listed to ensure completeness — each step may produce triples that feed into subsequent steps.

## Steps

### Step 1 — Inverse properties (`inference1-inverses.sparql`)
Generate inverse triples for all 10 inverse pairs defined in the ontology. Must run first so the generated inverse triples are available for sub-property propagation in Step 2.

Pairs covered:
- `memberOf` ↔ `hasMember`
- `employedBy` ↔ `hasEmployee`
- `leadsAt` ↔ `hasLeader`
- `fundedBy` ↔ `hasFunder`
- `founded` ↔ `wasFoundedBy`
- `contributedTo` ↔ `hasContributor`
- `sponsored` ↔ `wasSponsoredBy`
- `acquired` ↔ `wasAcquiredBy`
- `derivedFrom` ↔ `hasDerivation`
- `organised` ↔ `wasOrganisedBy`

### Step 2a — Sub-property: `leadsAt → employedBy` (`inference2a-leadsAt-employedBy.sparql`)
`leadsAt` is a sub-property of `employedBy`. Generates both directions:
- `leadsAt → employedBy` (forward)
- `hasLeader → hasEmployee` (inverse direction, using `hasLeader` triples generated in Step 1)

Must run before Step 2b so these triples are present when the catch-all `employedBy`/`hasEmployee → associatedWith` fires.

### Step 2b — Sub-property: all → `associatedWith` (`inference2b-subprops-associatedWith.sparql`)
All direct sub-properties of `associatedWith` generate `associatedWith` triples. Covers:
`memberOf`, `hasMember`, `employedBy` (includes `leadsAt` via Step 2a), `hasEmployee`, `hasLeader`, `fundedBy`, `hasFunder`, `founded`, `wasFoundedBy`, `sponsored`, `wasSponsoredBy`, `acquired`, `wasAcquiredBy`, `derivedFrom`, `hasDerivation`, `organised`, `wasOrganisedBy`, `hasPartner`.

Note: `contributedTo` and `hasContributor` are **not** sub-properties of `associatedWith` and are excluded.

### Step 3a — Symmetry: `associatedWith` (`inference3a-associatedWith-symmetric.sparql`)
`associatedWith` is a symmetric property. Run after Steps 1–2 so all `associatedWith` triples (including those inferred from sub-properties) are symmetrised.

### Step 3b — Symmetry: `hasPartner` (`inference3b-hasPartner-symmetric.sparql`)
`hasPartner` is a symmetric property. Kept separate from Step 3a for clarity.

## Query files

| File | Step |
|------|------|
| `inference1-inverses.sparql` | All 10 inverse pairs in one query (distinct variable trick) |
| `inference2a-leadsAt-employedBy.sparql` | `leadsAt → employedBy` and `hasLeader → hasEmployee` |
| `inference2b-subprops-associatedWith.sparql` | All 19 sub-properties `→ associatedWith` |
| `inference3a-associatedWith-symmetric.sparql` | `associatedWith` symmetry |
| `inference3b-hasPartner-symmetric.sparql` | `hasPartner` symmetry |

## Execution

Run `infer.sh` from the repository root. Each step appends its output to `output/inferred/accumulated.ttl` so the next `fx` call sees the full growing graph via a single `-l` flag.

```bash
mkdir -p output/inferred

# Initialise accumulated graph from source data
cat output/entities.ttl output/relations.ttl > output/inferred/accumulated.ttl

# Step 1 — inverses
fx -q queries/inference1-inverses.sparql \
   -l output/inferred/accumulated.ttl \
   -f TTL -o output/inferred/step1-inverses.ttl
cat output/inferred/step1-inverses.ttl >> output/inferred/accumulated.ttl

# Step 2a — leadsAt → employedBy / hasLeader → hasEmployee
fx -q queries/inference2a-leadsAt-employedBy.sparql \
   -l output/inferred/accumulated.ttl \
   -f TTL -o output/inferred/step2a-leadsAt-employedBy.ttl
cat output/inferred/step2a-leadsAt-employedBy.ttl >> output/inferred/accumulated.ttl

# Step 2b — all subprops → associatedWith
fx -q queries/inference2b-subprops-associatedWith.sparql \
   -l output/inferred/accumulated.ttl \
   -f TTL -o output/inferred/step2b-subprops-associatedWith.ttl
cat output/inferred/step2b-subprops-associatedWith.ttl >> output/inferred/accumulated.ttl

# Step 3a — associatedWith symmetric
fx -q queries/inference3a-associatedWith-symmetric.sparql \
   -l output/inferred/accumulated.ttl \
   -f TTL -o output/inferred/step3a-associatedWith-symmetric.ttl
cat output/inferred/step3a-associatedWith-symmetric.ttl >> output/inferred/accumulated.ttl

# Step 3b — hasPartner symmetric
fx -q queries/inference3b-hasPartner-symmetric.sparql \
   -l output/inferred/accumulated.ttl \
   -f TTL -o output/inferred/step3b-hasPartner-symmetric.ttl
cat output/inferred/step3b-hasPartner-symmetric.ttl >> output/inferred/accumulated.ttl

# Final outputs
cat output/inferred/step*.ttl > output/inferred.ttl          # inferred triples only
cp output/inferred/accumulated.ttl output/KG-inferred.ttl    # source + inferred
```

## Completeness argument

- Step 1 generates inverses → new triples feed Step 2b (e.g. `hasMember → associatedWith`)
- Step 2a ensures the `leadsAt → employedBy → associatedWith` chain is complete before Step 2b
- Step 3 symmetrises the full `associatedWith` graph including all inferred triples
- No generated `associatedWith` triple triggers further inverse rules (`associatedWith` has no inverse other than itself via symmetry)
- `owl:sameAs` is intentionally not materialised — it is used only to link entities to external identity systems (Wikidata, DBpedia)
