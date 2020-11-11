#!/bin/bash

# Extract the HTML files (this is necessary because of the .git files inside)
if [ ! -d ./files/html ]; then
    cd files
    tar xzvf html.tgz
    cd ..
fi
# Build the Docker image
docker build --tag ctf-challenge-gitpress:1.0 .
# Start the challenge
docker run -d -p 80:80 -p 3306:3306 --rm --name gitpress ctf-challenge-gitpress:1.0
