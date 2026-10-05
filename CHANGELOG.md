# Changelog

Versions refer to the LACK Knowledge Graph. The LACK Ontology is versioned
independently (current: 1.0).

## KG v1.1 — 2026-10-05

### Fixed
- Step 3a (`queries/inference3a-associatedWith-symmetric.sparql`) emitted
  `owl:sameAs` for every `lack:associatedWith` pair and `lack:associatedWith`
  for every `owl:sameAs` pair. This produced ~69k erroneous internal
  `owl:sameAs` links (e.g. companies identified with their industry
  associations, people with their employers) and ~17k spurious
  `lack:associatedWith` triples involving Wikidata/DBpedia IRIs.
  The two properties are now symmetrised independently.

### Added
- Sanity-check queries: `queries/check-*.sparql`.

### Unchanged
- LACK Ontology 1.0.

### Stats (KG.ttl)
- Triples: 1,053,353 → 966,879
- `owl:sameAs`: 103,881 → 34,782 (lack→lack: 69,647 → 548)
- `lack:associatedWith`: 91,219 → 73,836

## KG v1.0 — 2026-04-26
- First release (with LACK Ontology 1.0).