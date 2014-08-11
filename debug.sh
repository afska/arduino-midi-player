#!/bin/bash

killall grunt
grunt compile
if [ $? -ne 0 ]; then
	exit $?
fi

killall node
node-inspector > /dev/null 2>&1 &
node --debug-brk .js/main.js > /dev/null 2>&1 &

google-chrome http://127.0.0.1:8080/debug?port=5858
