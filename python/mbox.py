#!/usr/bin/env python3
"""
convert email to mbox format
and look for spam
"""
import json
import datetime
import re
import boto3
import base64
import string
import random
import logging
import os


def basic(data):
    """
    take the mial message pull out
    message body and reciept (so spam fucntion can
    look at the headers
    add sender and date to first line of
    message to make it mbox compliant
    """
    logger.debug("func start")
    client = boto3.client('s3')
    now = datetime.datetime.now()
    jdata = (json.loads(data))
    logger.debug("jdata type: ", type(jdata))
    content = (base64.b64decode(jdata["content"]).decode('utf8'))
    sender = (jdata["mail"]["commonHeaders"]["from"][0])
    receipt = (jdata["receipt"])
    emails = re.findall(r'[\w\.-]+@[\w\.-]+', sender)
    body = ("From {} {}\n{}".format(emails[0], now.strftime("%a %b %d %H:%M:%S %Y %z"), content))
    res = ''.join(random.choices(string.ascii_letters + string.digits, k=12))
    logger.debug("basic func s3 work")
    if pass_spam_check(receipt):
        response = client.put_object(
            Bucket='mailbox.thekramms.com',
            Key="mails/" + str(res),
            Body=body)
        logger.debug("s3 response: {}".format(response))
    logger.debug("func end")


def pass_spam_check(rcpt):
    """
    Spam Check
    check headers for spam results and
    exit out if spam is dected
    """
    logger.debug("func start")
    if (rcpt['spfVerdict']['status'] == 'FAIL' or rcpt['dkimVerdict']['status'] == 'FAIL' or rcpt['spamVerdict']['status'] == 'FAIL' or rcpt['virusVerdict']['status'] == 'FAIL'):
        logger.error("[spam] FAILED!")
        return False
    logger.debug("reciept spamVerdict status: {}".format(json.dumps(rcpt["spamVerdict"]["status"])))
    logger.debug("reciept dkimVerdict status: {}".format(json.dumps(rcpt["dkimVerdict"]["status"])))
    logger.debug("reciept virusVerdict status: {}".format(json.dumps(rcpt["virusVerdict"]["status"])))
    logger.debug("func end")
    return True


def lambda_handler(event, context):
    """
    lambda_handler function
    """
    logger.debug("func start")
    data = json.dumps(event['Records'][0]['Sns']['Message'])
    newdata = json.loads(data)
    basic(newdata)
    logger.debug("func end")


if __name__ == '__main__':
    """
    main function
    """
    LOG_FORMAT = "%(asctime)s %(levelname)s - %(funcName)s - %(message)s"
    # logging.basicConfig(level='INFO', format=LOG_FORMAT)
    logging.basicConfig(level=os.environ.get('LOG_LEVEL'), format=LOG_FORMAT)
    logger = logging.getLogger()
    f = open("mail2.json", "r")
    basic(f.read())
