#!/usr/bin/env python

import gitlab
import os
import sys

# argv[0] and argv[1] is len of 2
if len(sys.argv) == 2:
    site = sys.argv[1]
else:
    print("Arg error. Abort")
    sys.exit(1)

TOKEN = os.getenv('API_KEY') # has write priv to actually delete runners: gitlab project var
URL = os.getenv('CI_SERVER_URL')
PROJECT_ID = os.getenv('CI_PROJECT_ID')
OOB_RUNNER_STR = "oob-mgmt-server:" + site
NETQ_TS_STR = "netq-ts:" + site

gl = gitlab.Gitlab(URL, private_token=TOKEN)

project = gl.projects.get(PROJECT_ID)

for p_runner in project.runners.list(all=True):
    try:
        if p_runner.attributes['status'] == "not_connected" and (NETQ_TS_STR in p_runner.attributes['description'] or OOB_RUNNER_STR in p_runner.attributes['description']):
            print("Removing not connected runner:")
            print(p_runner)
            runner = gl.runners.get(p_runner.id)
            print(runner)
            runner.delete()
        if p_runner.attributes['status'] == "offline" and (NETQ_TS_STR in p_runner.attributes['description'] or OOB_RUNNER_STR in p_runner.attributes['description']):
            print("Removing offline runner:")
            print(p_runner)
            runner = gl.runners.get(p_runner.id)
            print(runner)
            runner.delete()
    # e.g. when runner is associated with multiple projects
    except Exception as ex:
        print(ex)
