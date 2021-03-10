#!/bin/bash
#


echo "Begin Mail Backup  $(date)"
echo ""
echo "aws s3 sync /home/gkramm/Mail s3://backup.thekramms.com/Mail"
aws s3 sync /home/gkramm/Mail s3://backup.thekramms.com/Mail
echo ""
echo "Finish Mail Backup $(date)"
