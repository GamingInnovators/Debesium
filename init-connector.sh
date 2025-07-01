#!/bin/bash
sleep 20

curl -X POST -H "Content-Type: application/json" --data @/docker-entrypoint-initdb.d/mongo-connector.json http://connect:8083/connectors
curl -X POST -H "Content-Type: application/json" --data @/docker-entrypoint-initdb.d/mysql-sink-connector.json http://connect:8083/connectors
