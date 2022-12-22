#!/bin/bash

if [[ -n "$(git diff --name-only --cached)" ]]
then
  exit 1
else
  exit 0
fi
