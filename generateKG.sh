#!/bin/bash
cat ontology/lack-ontology.ttl > output/KG.ttl
cat output/entities.ttl >> output/KG.ttl
cat output/relations.ttl >> output/KG.ttl
cat output/provenance-relations.ttl >>  output/KG.ttl
cat output/provenance-attributes.ttl >>  output/KG.ttl
cat output/KG-inferred.ttl >> output/KG.ttl
tar -czf output/KG.tar.gz output/KG.ttl output/KG-inferred.ttl 
./stats.sh > KGSTATS.md
