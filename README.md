# LACK: Knowledge Graph Construction

## Input

- Relation Extraction (Desmog): `input/desmog_ie_time.csv`
- Relation Extraction (LobbyMap): `input/lobbymap_ie_time.csv`
- Entity Linking Output: `input/entities_linked_flagged.csv`
<!-- - Climate disinformation Database (Desmog) KG: `input/climate-disinformation-database.ttl`
- Climate disinformation Database (Desmog) KG entity linking to Relation Extraction (Desmog) entities: `input/desmog-links.csv`
-->
## Phase 1: alignment/mapping to ontology

Input: 

- Relation Extraction (Desmog): desmog\_ie\_time.csv
- Relation Extraction (LobbyMap): lobbymap\_ie\_time.csv

Process:

- Generate a distinct set of relations: phase1-relations.sparql (152 different relation types over 78734 relation instances)
- Align to Ontology IRIs (manual)

Output:
- List of relations: `ontology/relations-extracted.csv`
- Mappings between relations and ontology IRIs: `ontology/relations-mappings.csv`

## Phase 2: generation of entity URIs

Input:

- Entity Linking Output: `input/entities_linked_flagged.csv`

Entity keys (hashes) — priority order:

1. WikiData QID
2. Wikipedia page
3. Web page
4. Surface form + evidence link (fallback)

Query: `queries/phase2-entities.sparql`

```bash
fx -q queries/phase2-entities.sparql -f TTL -o output/entities.ttl
```

Output:

- `output/entities.ttl` — entity IRIs with `rdf:type`, `rdfs:label`, `rdfs:seeAlso`, `owl:sameAs`

## Phase 3: construction of the relations graph

Input:
- Relation Extraction (Desmog): `input/desmog_ie_time.csv`
- Relation Extraction (LobbyMap): `input/lobbymap_ie_time.csv`
- Entity Linking Output: `input/entities_linked_flagged.csv`
- Relation–ontology mappings: `ontology/relations-mappings.csv`

Two-step process (single query runs out of memory due to join size):

**Step 3a** — build entity index (surface form + evidence link → entity IRI):

```bash
fx -q queries/phase3a-entity-index.sparql -f TTL -o output/entity-index.ttl
```

**Step 3b** — construct relation triples, loading the index in-memory:

```bash
fx -q queries/phase3b-relations.sparql -l output/entity-index.ttl -f TTL -o output/relations.ttl
```

**Step 3c** — construct attribute triples, loading the index in-memory:

```bash
fx -q queries/phase3c-attributes.sparql -l output/entity-index.ttl -f TTL -o output/attributes.ttl
```

Output:

- `output/entity-index.ttl` — intermediate index (not part of the final graph)
- `output/relations.ttl` — relation triples with reified statements carrying `rdfs:seeAlso` (evidence link), `lack:since`, and `lack:until`

## Step 4: Provenance

```bash
fx -q queries/provenance.sparql -l output/relations.ttl -f TTL -o output/provenance-relations.ttl
```

```bash
fx -q queries/provenance.sparql -l output/attributes.ttl -f TTL -o output/provenance-attributes.ttl
```


## Output

### `output/entities.ttl`

A set of named entities extracted from the relation extraction datasets and linked to external knowledge bases. Each entity has:

- `rdf:type` — main type (`lack:Person` or `lack:Collective`) and a granular subtype (`lack-type:company`, `lack-type:think_tank`, `lack-type:person`, etc.)
- `rdfs:label` — the Wikidata label (or surface form if no external link was found)
- `rdfs:seeAlso` — the evidence page from which the entity was extracted
- `owl:sameAs` — link to the Wikidata entity (when available)

Entity IRIs are of the form `lack-entity:<SHA1>`, where the hash is computed from the best available identifier (Wikidata QID > Wikipedia URL > web page > surface form + evidence link).

### `output/relations.ttl`

A set of directed relations between entities, drawn from both Desmog and LobbyMap extraction datasets. Each relation is represented as:

- A direct triple: `?source ?property ?target` — using ontology properties from `ontology/lack-ontology.ttl` (e.g. `lack:employedBy`, `lack:memberOf`, `lack:fundedBy`)
- A reified `rdf:Statement` carrying:
  - `rdfs:seeAlso` — the evidence URL for the relation
  - `lack:since` (`xsd:gYear`) — start year, when available
  - `lack:until` (`xsd:gYear`) — end year, when available

## Inferences

## Assemble


## Run all the pipeline

`$ bash make.sh`
