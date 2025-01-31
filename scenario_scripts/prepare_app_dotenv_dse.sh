#!/usr/bin/env bash

# Creation of the .env file, pre-filled as far as Origin is concerned

echo -en "> Configuring client application ...";

cat client_application/.env.sample | sed "s/IP.OF.ORIGIN.1/10.0.0.11/" > client_application/.env

echo -e " => done.";
