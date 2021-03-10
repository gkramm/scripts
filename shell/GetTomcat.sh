#!/bin/bash 
# a quick and dirty script to get the latest version of tomcat 6 & 7 and create a RPM for them
#
#
tom=$(curl --connect-timeout 5 -s http://tomcat.apache.org/download-70.cgi  | awk -F\" '$0 ~ /apache-tomcat-7.*[0-9].tar.gz"/ {print $2}')
# file = the last field of $tom (the "/" is the separator)
file=${tom##*/}
ver=${file//[![:digit:]]/}
major=${ver:0:1}
minor=${ver:1:1}
patch=${ver:2:2}
echo "get $file from $tom; ver: $ver; major: $major; minor: $minor; patch: $patch"
curl --connect-timeout 5 -O  "$tom"
echo "create rpm: edit the %files line"
sleep 1
#fpm --rpm-auto-add-directories -t rpm --prefix /data/prod --license "http://www.apache.org/licenses/LICENSE-2.0" --url http://tomcat.apache.org/tomcat-7.0-doc/index.html -n tomcat"$major" -v "$major"."$minor" --iteration "$patch" -a all -m mickey@disney.com -s tar "$file"
fpm --edit -t rpm --prefix /data/prod --license "http://www.apache.org/licenses/LICENSE-2.0" --url http://tomcat.apache.org/tomcat-7.0-doc/index.html -n tomcat"$major" -v "$major"."$minor" --iteration "$patch" -a all -m mickey@disney.com -s tar "$file"

tom=$(curl --connect-timeout 5 -s http://tomcat.apache.org/download-80.cgi  | awk -F\" '$0 ~ /apache-tomcat-8.*[0-9].tar.gz"/ {print $2}')
# file = the last field of $tom (the "/" is the separator)
file=${tom##*/}
ver=${file//[![:digit:]]/}
major=${ver:0:1}
minor=${ver:1:1}
patch=${ver:2:2}
echo "get $file from $tom; ver: $ver; major: $major; minor: $minor; patch: $patch"
curl --connect-timeout 5 -O  "$tom"
echo "create rpm: edit the %files line"
sleep 1
#fpm --rpm-auto-add-directories -t rpm --prefix /data/prod --license "http://www.apache.org/licenses/LICENSE-2.0" --url http://tomcat.apache.org/tomcat-7.0-doc/index.html -n tomcat"$major" -v "$major"."$minor" --iteration "$patch" -a all -m mickey@disney.com -s tar "$file"
fpm --edit -t rpm --prefix /data/prod --license "http://www.apache.org/licenses/LICENSE-2.0" --url http://tomcat.apache.org/tomcat-8.0-doc/index.html -n tomcat"$major" -v "$major"."$minor" --iteration "$patch" -a all -m mickey@disney.com -s tar "$file"

tom=$(curl --connect-timeout 5 -s http://tomcat.apache.org/download-60.cgi  | awk -F\" '$0 ~ /apache-tomcat-6.*[0-9].tar.gz"/ {print $2}')
file=${tom##*/}
ver=${file//[![:digit:]]/}
major=${ver:0:1}
minor=${ver:1:1}
patch=${ver:2:2}
echo "get $file from $tom; ver: $ver; major: $major; minor: $minor; patch: $patch"
curl -O  "$tom"
echo "create rpm: edit the %files line"
sleep 1
fpm --edit -t rpm --prefix /data/prod --license "http://www.apache.org/licenses/LICENSE-2.0" --url http://tomcat.apache.org/tomcat-6.0-doc/index.html -n tomcat"$major" -v "$major"."$minor" --iteration "$patch" -a all -m mickey@disney.com -s tar "$file"
