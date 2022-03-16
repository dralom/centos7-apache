#!/bin/bash

name="apache24"
tag="dev"
port=18080

echo "Access the server with http://localhost:${port}"
echo ""
echo "http://localhost:${port}/contact-page"
echo ""
echo "http://localhost:${port}/server-status"
echo ""

docker run --rm -d \
    --name $name \
    -p $port:80 \
    $name:$tag