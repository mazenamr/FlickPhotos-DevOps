#!/bin/bash

cd $HOME/files/scripts

chmod +x *.sh
./update.sh && ./api.sh; ./apidocs.sh; ./web.sh;