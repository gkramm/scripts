#!/usr/bin/env python3
import boto3


user_data = '''#!/bin/bash
/usr/bin/yum -y update'''

client = boto3.client('ec2', region_name='us-west-2')
response = client.run_instances(
    # DryRun=True,
    MaxCount=1,
    MinCount=1,
    KeyName="aws-core",
    SubnetId='subnet-09e1247f',
    SecurityGroupIds=['sg-03ca86ce4448ca45f'],
    ImageId='ami-0e34e7b9ca0ace12d',  # Amazon Linux 2 AMI (HVM), SSD Volume Type
    # ImageId='ami-086b16d6badeb5716',  # Amazon Linux AMI 2018.03.0 (HVM), SSD Volume Type
    InstanceType='t2.medium',
    IamInstanceProfile={'Arn': 'arn:aws:iam::152192157982:instance-profile/ecscluster-nonprod-oneid-InstanceProfile-1CFPAMUS3P0MG'},
    UserData=user_data
)

print("Instance ID: {}\nIP address: {}\nRegion: {}".
      format(response['Instances'][0]['InstanceId'],
             response['Instances'][0]['PrivateIpAddress'],
             response['Instances'][0]['Placement']['AvailabilityZone']))
