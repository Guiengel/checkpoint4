#!/usr/bin/env bash

set -e

apt update
apt install -y jq

HTTP_STATUS=$(
    curl -X 'POST' \
    'http://localhost:8080/eventos' \
    -H 'accept: */*' \
    -H 'Content-Type: application/json' \
    -w "%{http_code}" \
    -o product_create.json \
    -d '{
    "nome": "Uva"
    }'
)
echo "Status HTTP: $HTTP_STATUS"
if [ "$HTTP_STATUS" -ne 201 ]; then
    echo "Erro ao criar evento"
    exit 1  
fi

EVENTO_ID=$(jq '.id' event_create.json)

echo "Evento criado com ID: $EVENTO_ID"

HTTP_STATUS=$(
    curl -X 'DELETE' \
    "http://localhost:8080/eventos/$EVENTO_ID" \
    -H 'accept: */*' \
    -w "%{http_code}"
)
echo "Status HTTP: $HTTP_STATUS"
if [ "$HTTP_STATUS" -ne 204 ]; then
    echo "Erro ao deletar produto"
    exit 1
fi

HTTP_STATUS=$(curl -X GET 'http://localhost:8080/eventos' -o event_list.json -w "%{http_code}" -H 'accept: */*')
echo "Status HTTP: $HTTP_STATUS"
if [ "$HTTP_STATUS" -ne 200 ]; then
    echo "Erro ao acessar a API de eventos"
    exit 1  
fi