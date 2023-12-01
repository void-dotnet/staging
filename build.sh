#! /usr/bin/bash

echo "Dotnet sdk stage builder"

_root_dir=$PWD
_installer_dir=$_root_dir/installer
_sources_dir=$_root_dir/sources
_dist_dir=$_root_dir/dist
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
echo "Distribution dir: $_dist_dir"

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
if [ ! -d $_dist_dir ]; then
    echo "Making distribution directory"
    mkdir -p $_dist_dir
fi

git clone https://github.com/dotnet/installer.git

cd $_installer_dir
git checkout -b "$_installer_ver-local" $_installer_ver

./build.sh -a $_arch \
    /p:ArcadeBuildTarball=true \
    /p:TarballDir=$_sources_dir

#cd $_source_dir
#_target_name=dotnet-sdk-source-$_installer_ver-$_arch
#_target_tarball=$_dist_dir/$_target_name.tbz
#_target_checksum=$_dist_dir/$_target_name.tbz.sha256

#if [ -d $_target_tarball ]; then
#    echo "Clearing file $_target_tarball"
#    rm -f $_target_tarball
#fi
#if [ -d $_target_checksum ]; then
#    echo "Clearing file $_target_checksum"
#    rm -f $_target_checksum
#fi
#tar -cjvf $_target_tarball ./
#sha256sum $_target_tarball > $_target_checksum


