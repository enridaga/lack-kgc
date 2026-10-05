# Release procedure

Releases are coordinated across two repositories:
- `lack-kgc` — KG construction (this repo)
- `lack` — website and distribution (https://github.com/climatesense-project/lack)

## Versioning

- The **KG** and the **ontology** are versioned independently (MAJOR.MINOR).
- Git tags in both repos (`vX.Y`) refer to the **KG** version.
- The KG version is declared in `ontology/lack-kg.ttl` (`dcat:version`,
  `owl:versionInfo`, `dc:modified`) and embedded in `output/KG.ttl` by
  `generateKG.sh`. The `lack` repo copies these values into `lack-dataset.ttl`.
- The ontology version (`owl:versionInfo` in `ontology/lack-ontology.ttl`)
  changes only when classes, properties or axioms change. When it does,
  also update `dc:modified` (`dc:issued` stays at first release).

## Steps in lack-kgc

1. If the ontology changed, update `ontology/lack-ontology.ttl` (see above).
2. Update `ontology/lack-kg.ttl`: `dcat:version` and `owl:versionInfo` → new
   version, `dc:modified` → release date.
3. Add an entry to `CHANGELOG.md`.
4. Regenerate the KG (order matters: `generateKG.sh` reads `output/KG-inferred.ttl`
   and calls `stats.sh`): 
	
	`./infer.sh && ./generateKG.sh`

5. Run the sanity checks; each must return 0:

	`for q in queries/check-*.sparql; do echo "$q"; fx -q "$q" -l output/KG.ttl; done`

6. Check `KGSTATS.md` and copy key figures to `CHANGELOG.md`.
7. Commit tracked files only (`output/KG.ttl` exceeds GitHub's 100 MB limit;
   it is distributed inside `output/KG.tar.gz`), then tag:

	```git add -u
    git add CHANGELOG.md RELEASE.md ontology/lack-kg.ttl queries/check-*.sparql
	git commit -m "KG vX.Y: <summary>"
	git tag -a vX.Y -m "LACK KG vX.Y"
	git push origin main
	git push origin vX.Y```


## Then, in lack (website)

See `RELEASE.md` in that repo.