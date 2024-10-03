#!/bin/bash

function set_package_manager
{
    found_package_manager=0
    for PACKAGE_MANAGER in apt-get yum yast; do
        which $PACKAGE_MANAGER &> /dev/null
        if [[ $? -eq 0 ]]; then
            found_package_manager=1
            break
        fi
    done

    if [[ $found_package_manager -eq 0 ]]; then
        unset PACKAGE_MANAGER
        return 1
    fi

    case $PACKAGE_MANAGER in
        apt-get)
            INSTALL_CMD="apt-get install "
            SEARCH_CMD="apt-cache search "
            ;;
        yum)
            INSTALL_CMD="yum install "
            SEARCH_CMD="yum search "
            ;;
        yast)
            INSTALL_CMD="yast -i "
            ;;
    esac

    return 0
}

function install_package
{
    package=$1
    binary=$2 # optional; if not given, it is the package name

    if [ ! -v $binary ]; then
        binary=$package
    fi

    which $binary &> /dev/null
    if [[ $? -eq 0 ]]; then
        return 0
    fi

    apt-cache search $package | grep "^$package "
    if [[ $? -eq 0 ]]; then
        apt-get install $package
    else
        # TODO try to compile it from source
        # TODO: gcc 5.4.0
        echo
    fi


    return 0
}

function install_packages
{
    ### gcc ###
    install_package gcc-5 gcc
    install_package g++

    ### binutils ###
    install_package binutils ld

    ### make ###
    install_package make

    # create symbolic link for gmake
    which gmake &> /dev/null
    if [[ $? -ne 0 ]]; then
        make_location=`which make`
        ln -s $make_location `dirname $make_location`/gmake
    fi

    ### cmake ###
    install_package cmake

    ### automake ###
    install_package automake

    ### python ###
    install_package python2.7 python

    ### patchelf ###
    install_package patchelf

    ### rsync ###
    install_package rsync

    ### screen ###
    install_package screen

    ### vim ###
    install_package vim
}

if [[ `whoami` != root ]]; then
    echo This script must be run as root!
    exit 1
fi

set_package_manager
if [[ $? -ne 0 ]]; then
    echo Unknown package manager!
    exit 1
fi

install_packages
