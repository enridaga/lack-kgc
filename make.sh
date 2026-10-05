#!/bin/bash -e

echo "# Make core triples"
echo "## Make entities"
fx -q queries/phase2-entities.sparql -f TTL -o output/entities.ttl
echo "## Make entity index"
fx -q queries/phase3a-entity-index.sparql -f TTL -o output/entity-index.ttl
echo "## Make relations"
fx -q queries/phase3b-relations.sparql -l output/entity-index.ttl -f TTL -o output/relations.ttl
echo "## Make attributes"
fx -q queries/phase3c-attributes.sparql -l output/entity-index.ttl -f TTL -o output/attributes.ttl
echo "## Make provenance (relations)"
fx -q queries/provenance.sparql -l output/relations.ttl -f TTL -o output/provenance-relations.ttl
echo "## Make provenance (attributes)"
fx -q queries/provenance.sparql -l output/attributes.ttl -f TTL -o output/provenance-attributes.ttl
#

echo ""
echo "# Make inferences"
./infer.sh

echo ""
echo "# Generate"
./generateKG.sh

./deploy.sh
echo "All done"