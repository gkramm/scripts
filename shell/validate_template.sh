#!/bin/bash
src=$2
file=$1
scp -q $src tecate:/tmp/$file
ssh tecate "aws cloudformation validate-template --template-body file:///tmp/$file && rm /tmp/$file"

