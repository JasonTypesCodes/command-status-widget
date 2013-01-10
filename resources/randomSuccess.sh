#!/bin/bash

result=$[ ( $RANDOM % 100 ) + 1 ]

if [ $result -lt 50 ] ; then
  exit 1
fi

exit 0
