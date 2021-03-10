#!/bin/bash
# $Id: blog_backup.sh,v 1.5 2008/11/04 06:39:57 gkramm Exp $
#

echo "Backing up blog" 
/usr/bin/mysqldump -h becks -p927wlir wordpress > /mnt/jungledisk/thekramms_blog.sql
