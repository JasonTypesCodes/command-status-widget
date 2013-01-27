#!/bin/bash

target="./target/"
pkgSource="./command-status-widget"
zipName="command-status-widget.plasmoid"

function clean(){
  if [ -d $target ] ; then
    rm -rf $target
  fi
}

function build(){
  mkdir $target
  cd $pkgSource
  zip -r ../$target/$zipName ./
  cd ..
}

clean
build
echo "Done!"
