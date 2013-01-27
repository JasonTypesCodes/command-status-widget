#!/bin/bash

target="./target/"
pkgSource="./command-status-widget"
zipName="command-status-widget.plasmoid"

function clean(){
  echo "Cleaning..."
  if [ -d $target ] ; then
    rm -rf $target
  fi
}

function build(){
  echo "Building..."
  mkdir $target
  cd $pkgSource
  zip -r ../$target/$zipName ./
  cd ..
}

function reinstall(){
  echo "Removing old package from system..."
  plasmapkg --remove $target/$zipName
  
  echo "Installing new package..."
  plasmapkg --install $target/$zipName
}

clean
build
reinstall
echo "Done!"
