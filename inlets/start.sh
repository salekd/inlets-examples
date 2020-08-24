#!/bin/bash
python -m http.server 3000 -d www &
inlets client --remote=$REMOTE --token=$TOKEN --upstream="http://127.0.0.1:3000"
