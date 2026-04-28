#!/bin/bash
cat ontology/lack-ontology.ttl > output/KG.ttl
cat output/entities.ttl >> output/KG.ttl
cat output/relations.ttl >> output/KG.ttl
cat output/provenance-relations.ttl >>  output/KG.ttl
cat output/provenance-attributes.ttl >>  output/KG.ttl
cat output/KG-inferred.ttl >> output/KG.ttl
./stats.sh > KGSTATS.md
cp -f output/KG.ttl ~/Development/Claude/lack/
cp -f output/KG-inferred.ttl ~/Development/Claude/lack/
cp -f KGSTATS.md ~/Development/Claude/lack/