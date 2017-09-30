#!/usr/bin/python3
import requests
import argparse
import json

parser = argparse.ArgumentParser(description='outputs arguments passed to processes in a sentry projects')
parser.add_argument('--auth_token', help='Create one in your sentry admin interface', required=True)
parser.add_argument('--project_name', help='Name of sentry project', required=True)
parser.add_argument('--filter', help='Only show arguments where commands ends with this filter', required=True)
parser.add_argument('--arg', help='Which argument to output', default=1)
parser.add_argument('--host', help='Host name of sentry server', default='localhost')
parser.add_argument('--port', help='Port of sentry server', default='9000')
args = parser.parse_args()

url = 'http://%s:%s/api/0/projects/sentry/%s/events/' % (args.host, args.port, args.project_name)
while True:
    response = requests.get(url, headers={'Authorization': 'Bearer %s' % args.auth_token})
    if not response.links['next']['results']:
        break
    url = response.links['next']['url']
    events = response.content
    i = 0
    for event in json.loads(events):
        event_args = event['context']['sys.argv']
        if len(event_args) != 2:
            continue
        if not event_args[0][1:-1].endswith(args.filter):
            continue
        print(event_args[args.arg][1:-1])
        i += 1
