#! /usr/bin/bash

echo "Dotnet sdk stage builder"

_root_dir=$PWD
_installer_dir=$_root_dir/installer
_sources_dir=$_root_dir/sources
_installer_ver=
_arch=x64
while getopts "a:v:" opt; do
  case $opt in 
    a)
        _arch=$OPTARG
        ;;
    v)
        _installer_ver=$OPTARG
        ;;
  esac
done

echo "installer version: $_installer_ver"
echo "arch: $_arch"
echo "Root dir: $_root_dir"
echo "Installer dir: $_installer_dir"
echo "Sources dir: $_sources_dir"

if [ -z $_installer_ver ]; then
    echo "-v not set, quitting."
    exit 1
fi

if [ -d $_root_dir ]; then
    echo "$_root_dir exists"
fi
if [ -d $_installer_dir ]; then
    echo "$_installer_dir exists, deleting"
    rm -rf $_installer_dir
fi
if [ -d $_sources_dir ]; then
    rm -rf $_sources_dir
fi
mkdir -p $_sources_dir

git clone https://github.com/dotnet/installer.git

cd $_installer_dir
git checkout -b "$_installer_ver-local" $_installer_ver

./build.sh -a $_arch \
    /p:ArcadeBuildTarball=true \
    /p:TarballDir=$_sources_dir

