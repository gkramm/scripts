#!/bin/bash


cwd=$1
arr=(${cwd//\// })
c=1
for i in "${arr[@]}"; do
  if [[ $i =~ cookbooks ]] ; then   cookbook=${arr[$c]}; d=$c; fi
  let c+=1
done
a=0
while [ "$a" -lt "$d" ]
do 
  path=${path}/${arr[$a]}
  let a+=1
done
#echo "cookbook is [ $cookbook ] path is $path"
if [ $2 = "prod" ]; then
  knife cookbook upload "$cookbook" -o "$path" -c /Users/kramg003/.chef/knife-did.rb
else
  knife cookbook upload "$cookbook" -o "$path" -c /Users/kramg003/.chef/knife-did-qa.rb

fi

