for q in queries/check-*.sparql; do echo "$q"; fx -q "$q" -l output/KG.ttl; done
grep -n 'dcat:version\|owl:versionInfo' output/KG.ttl | head   # expect "1.1" (dataset) and "1.0" (ontology)
tar tzf output/KG.tar.gz      # expect only output/KG.ttl and output/KG-inferred.ttl
git diff --stat

