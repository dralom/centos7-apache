#!/bin/bash

name="apache24"
tag="dev"

docker build . --no-cache -t $name:$tag
