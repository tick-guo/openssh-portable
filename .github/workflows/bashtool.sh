#!/bin/bash

pwd
#9.8.1.0
version=$(cat contrib/win32/openssh/version.rc | grep FILEVERSION | awk '{print $2}' | sed 's/,/./g' )
echo version=$version
cur_time=$(date '+%F_%T' | sed 's/://g' | sed 's/-//g')
echo cur_time=$cur_time

tag_name="$version-$cur_time"
name="OpenSSH-Win64 $tag_name"

echo GITHUB_ENV=$GITHUB_ENV

echo name=$name >> $GITHUB_ENV
echo tag_name=$tag_name >> $GITHUB_ENV
# 这里不包含.zip后缀
echo zip_name=Win32-OpenSSH-$tag_name >> $GITHUB_ENV

cat $GITHUB_ENV

echo

