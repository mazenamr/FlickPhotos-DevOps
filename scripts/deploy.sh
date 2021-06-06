#!/bin/bash

cd $HOME/files/scripts

chmod +x *.sh

./update.sh || exit -1

./api-build.sh && ./api-test.sh && ./api-deploy.sh

./apidocs-build.sh && ./apidocs-test.sh && ./apidocs-deploy.sh

./web-build.sh && ./web-test.sh && ./web-deploy.sh
