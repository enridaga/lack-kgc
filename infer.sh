#!/usr/bin/env bash
set -euo pipefail

rm -rf output/inferred/*
mkdir -p output/inferred

# Initialise accumulated graph from source data
cat output/entities.ttl output/relations.ttl  output/attributes.ttl > output/inferred/accumulated.ttl

# Step 1 — inverses
echo "Step 1: inverse properties..."
fx -q queries/inference1-inverses.sparql \
   -l output/inferred/accumulated.ttl \
   -f TTL -o output/inferred/step1-inverses.ttl
cat output/inferred/step1-inverses.ttl >> output/inferred/accumulated.ttl

# Step 2a — leadsAt → employedBy / hasLeader → hasEmployee
echo "Step 2a: leadsAt/hasLeader sub-property..."
fx -q queries/inference2a-leadsAt-employedBy.sparql \
   -l output/inferred/accumulated.ttl \
   -f TTL -o output/inferred/step2a-leadsAt-employedBy.ttl
cat output/inferred/step2a-leadsAt-employedBy.ttl >> output/inferred/accumulated.ttl

# Step 2b — all subprops → associatedWith
echo "Step 2b: sub-properties → associatedWith..."
fx -q queries/inference2b-subprops-associatedWith.sparql \
   -l output/inferred/accumulated.ttl \
   -f TTL -o output/inferred/step2b-subprops-associatedWith.ttl
cat output/inferred/step2b-subprops-associatedWith.ttl >> output/inferred/accumulated.ttl

# Step 3a — associatedWith symmetric
echo "Step 3a: associatedWith symmetry..."
fx -q queries/inference3a-associatedWith-symmetric.sparql \
   -l output/inferred/accumulated.ttl \
   -f TTL -o output/inferred/step3a-associatedWith-symmetric.ttl
cat output/inferred/step3a-associatedWith-symmetric.ttl >> output/inferred/accumulated.ttl

# Step 3b — hasPartner symmetric
echo "Step 3b: hasPartner symmetry..."
fx -q queries/inference3b-hasPartner-symmetric.sparql \
   -l output/inferred/accumulated.ttl \
   -f TTL -o output/inferred/step3b-hasPartner-symmetric.ttl
cat output/inferred/step3b-hasPartner-symmetric.ttl >> output/inferred/accumulated.ttl

# Final outputs
echo "Merging outputs..."
cat output/inferred/step*.ttl > output/inferred.ttl          # inferred triples only
cp output/inferred/accumulated.ttl output/KG-inferred.ttl    # source + inferred

echo "Done."
echo "  Inferred triples only : output/inferred.ttl"
echo "  Full graph (src+inf)  : output/KG-inferred.ttl"
