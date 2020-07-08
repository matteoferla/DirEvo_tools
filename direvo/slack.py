import os, logging, unicodedata, re, requests

log = logging.getLogger(__name__)

def notify_admin(msg):
    """
    Send message to a slack webhook
    :param msg:
    :return:
    """
    if 'SLACK_WEBHOOK' not in os.environ:
        log.critical(f'SLACK_WEBHOOK is absent! Cannot send message {msg}')
        return
    # sanitise.
    msg = unicodedata.normalize('NFKD',msg).encode('ascii','ignore').decode('ascii')
    msg = re.sub('[^\w\s\-.,;?!@#()\[\]]','', msg)

    r = requests.post(url=os.environ['SLACK_WEBHOOK'],
                      headers={'Content-type': 'application/json'},
                      data=f"{{'text': '{msg}'}}")
    if r.status_code == 200 and r.content == b'ok':
        return True
    else:
        log.error(f'{msg} failed to send (code: {r.status_code}, {r.content}).')
        return False