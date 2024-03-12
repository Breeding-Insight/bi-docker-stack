#!/bin/bash
#Installs necessary node and npm versions and starts biweb
npm install -g npm@v8.12.1
npm install
npm run githooks
npm run serve