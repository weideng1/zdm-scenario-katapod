#!/usr/bin/env bash

# We assume the node is UN at this point

echo -en "> Provisioning Origin database ...";

sleep 2;
echo -en " [sc]"
cqlsh dse0 -u cassandra -p cassandra -f origin_config/origin_schema.cql > ./katapod_logs/cql-origin-schema.log
sleep 5;
echo -en " [da]"
cqlsh dse0 -u cassandra -p cassandra -f origin_config/origin_populate.cql > ./katapod_logs/cql-origin-populate.log

echo -e " => DB populated.";
