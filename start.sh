#!/bin/bash

# Extract the HTML files
cd files
tar xzvf html.tgz
cd ..
# Build the Docker image
docker build --tag ctf-challenge-gitpress:1.0 .
# Start the challenge
docker run -d -p 8080:80 -p 3306:3306 --rm --name gitpress ctf-challenge-gitpress:1.0
