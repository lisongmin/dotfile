#!/usr/bin/env bash

which qtile-cmd &>/dev/null
if [ $? -eq 0 ];then
    qtile-cmd -o cmd -f restart &>/dev/null
fi
