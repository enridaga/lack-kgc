#!/usr/bin/env bash
set -euo pipefail

cat output/entities.ttl > output/KG-extracted.ttl
cat output/relations.ttl >> output/KG-extracted.ttl
cat output/attributes.ttl >> output/KG-extracted.ttl

echo "# LACK KG STATS "
echo "### BEFORE INFERENCING "

echo ""
echo "Entity counts:"
echo ""
fx -q queries/count-entities.sparql \
   -l output/KG-extracted.ttl

echo ""
echo "Entity links breakdown:"
echo ""
fx -q queries/entities-breakdown.sparql \
   -l output/KG-extracted.ttl

echo ""
echo "Relation counts:"
echo ""
fx -q queries/count-relations.sparql \
   -l output/relations.ttl

echo ""
echo "Relation breakdown:"
echo ""
fx -q queries/relations-stats.sparql \
   -l output/relations.ttl


echo ""
echo "Same as/See also counts:"
echo ""
fx -q queries/count-sameas.sparql \
   -l output/KG-extracted.ttl

echo ""
echo "Same as/See also breakdown:"
echo ""
fx -q queries/sameas-stats.sparql \
   -l output/KG-extracted.ttl

echo ""
echo "Attributes counts:"
echo ""
fx -q queries/count-attributes.sparql \
   -l output/attributes.ttl

echo ""
echo "Attributes breakdown:"
echo ""
fx -q queries/attributes-stats.sparql \
   -l output/attributes.ttl

echo ""
echo "Statements counts:"
echo ""
fx -q queries/count-statements.sparql \
   -l output/KG-extracted.ttl

echo ""
echo "Statements breakdown:"
echo ""
fx -q queries/statements-stats.sparql \
   -l output/KG-extracted.ttl

echo ""
echo "### INFERRED "

echo ""
echo "Entity counts:"
echo ""
fx -q queries/count-entities.sparql \
   -l output/inferred.ttl

echo ""
echo "Entity links breakdown:"
echo ""
fx -q queries/entities-breakdown.sparql \
   -l output/inferred.ttl

echo ""
echo "Relation counts:"
echo ""
fx -q queries/count-relations.sparql \
   -l output/inferred.ttl

echo ""
echo "Relation breakdown:"
echo ""
fx -q queries/relations-stats.sparql \
   -l output/inferred.ttl
echo ""
echo "### AFTER INFERENCING ==="

echo ""
echo "Entity counts:"
echo ""
fx -q queries/count-entities.sparql \
   -l output/KG-inferred.ttl

echo ""
echo "Entity links breakdown:"
echo ""
fx -q queries/entities-breakdown.sparql \
   -l output/KG-inferred.ttl

echo ""
echo "Relation counts:"
echo ""
fx -q queries/count-relations.sparql \
   -l output/KG-inferred.ttl

echo ""
echo "Relation breakdown:"
echo ""
fx -q queries/relations-stats.sparql \
   -l output/KG-inferred.ttl
