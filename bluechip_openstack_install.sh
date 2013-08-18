#!/bin/bash

# just so we're all clear
clear 

if [ -f ./setuprc ]
then
  echo;
else
  echo "########################################################################################################################"
  echo;
  echo "Your setuprc configuration file wasn't found.  Install will halt.  Report this error at http://github.com/bluechip."
  echo;
  echo "########################################################################################################################"
fi

