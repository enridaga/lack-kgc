#!/bin/bash

echo "## Wrap in single KG.ttl (including inferences)"
cat ontology/lack-ontology.ttl > output/KG.ttl
cat ontology/lack-kg.ttl >> output/KG.ttl
cat output/entities.ttl >> output/KG.ttl
cat output/relations.ttl >> output/KG.ttl
cat output/provenance-relations.ttl >>  output/KG.ttl
cat output/provenance-attributes.ttl >>  output/KG.ttl
cat output/KG-inferred.ttl >> output/KG.ttl
echo "## Prepare archive KG.tar.gz with output/KG.ttl output/KG-inferred.ttl"
COPYFILE_DISABLE=1 tar -czf output/KG.tar.gz output/KG.ttl output/KG-inferred.ttl
echo "Print statistics into KGSTATS.md"
./stats.sh > KGSTATS.md
