#!/bin/bash
src=$2
file=$1
#scp -q $src aws:/tmp/$file
aws s3 cp --quiet $src s3://segds-template-tests/$file && echo https://s3-us-west-2.amazonaws.com/segds-template-tests/$file?versionId=null
#ssh aws "aws s3 cp --quiet /tmp/$file s3://segds-template-tests/$file && rm /tmp/$file && echo https://s3-us-west-2.amazonaws.com/segds-template-tests/$file?versionId=null"
#ssh aws "aws s3api put-object --bucket segds-template-tests --key $file --body /tmp/$file && rm /tmp/$file echo https://s3-us-west-2.amazonaws.com/segds-template-tests/$file?versionId=null "



