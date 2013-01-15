#!/bin/bash

result=$[ ( $RANDOM % 100 ) + 1 ]

if [ $result -lt 50 ] ; then
  echo "Returning error"
  exit 1
fi

echo "Returning success"
exit 0
