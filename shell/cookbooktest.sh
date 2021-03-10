#!/bin/bash


cwd=$1
arr=(${cwd//\// })
c=1
for i in "${arr[@]}"; do
  if [[ $i =~ cookbooks ]] ; then   cookbook=${arr[$c]}; d=$c; fi
  let c+=1
done
a=0
while [ "$a" -lt $d ]
do 
  path=${path}/${arr[$a]}
  let a+=1
done
#echo "cookbook is [ $cookbook ] path is $path"
knife cookbook test "$cookbook" -o "$path"
