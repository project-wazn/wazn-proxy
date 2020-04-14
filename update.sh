#!/bin/bash
git checkout . &&\
git pull --no-edit &&\
npm install &&\
echo "Everything OK! Proxy is updated. Please go ahead and restart with the correct pm2 command."
echo "This is usually pm2 restart proxy but you can use pm2 list to check for your exact proxy command."
