#!/usr/bin/env python

import json
import sys
import os
import requests
from air_sdk import AirApi
from jinja2 import Environment, FileSystemLoader

# return dict/json as in file
def get_artifact(artifact_name):
    artifact = {}
    with open(artifact_name) as json_file:
        artifact = json.load(json_file)

    return artifact

def get_simulation_node(air, simulation_id, nodestr):
    try: # get simulation node
        simulation_node = air.simulation_nodes.list(simulation=simulation_id, name=nodestr)
        if len(simulation_node) > 1:
            print (f'More than one simulation node returned by sim.id and name {nodestr}')
            sys.exit(1)
        simulation_node = simulation_node[0]
    except:
        print(f'Unexpected error while getting the simulation-node for {simulation_node}')
        raise

    return simulation_node

def send_file_executor_instruction(node, data):
    try:
        node.create_instructions(data=json.dumps(data), executor='file')
        print(f'created instruction for: {node}')
    except:
        print(f'Error while creating instruction for: {node}')
        raise

def drop_runner_reg_instruction(node, file_str):
    #build oob-mgmt-server instructions
    data = {}
    data["/home/cumulus/runner-script.sh"] = file_str
    data["post_cmd"] = ["sh /home/cumulus/runner-script.sh"]

    # debugging
    print(f'{file_str} instruction data is:')
    print(f'{data} data dict we are about to send:')

    send_file_executor_instruction(node, data)

if __name__ == '__main__':
    #check for staging
    if "staging" in os.getenv('CI_COMMIT_REF_NAME'):
        print ("ON staging branch. using air staging")
        AIR = AirApi(api_url='https://staging.air.cumulusnetworks.com/api/', username=os.getenv('AIR_USERNAME'), password=os.getenv('AIR_PASSWORD'))
    else:
        print ("Didn't detect staging branch. Using air prod")
        AIR = AirApi(username=os.getenv('AIR_USERNAME'), password=os.getenv('AIR_PASSWORD'))

    # set SITE var from args. Bail if not passed in.
    if len(sys.argv) > 2:
        SITE = sys.argv[1]
        PARENT_PIPELINE_ID = sys.argv[2]
    else:
        print("Arg error. Abort")
        sys.exit(1)

    # this is just a json {"id":"66c9ed73-d076-4e1a-858d-61667bb60c5e"}
    SIMULATION_ID = get_artifact('simulation_duplicate_response.json')["id"]

    OOB_NODE = get_simulation_node(AIR, SIMULATION_ID, "oob-mgmt-server")
    NETQ_TS_NODE = get_simulation_node(AIR, SIMULATION_ID, "netq-ts")

    #load template
    file_loader = FileSystemLoader('cicd/templates')
    env = Environment(loader=file_loader)
    template = env.get_template('runner-reg-instructions.sh.j2')

    #render the template/script into a string
    OOB_REG_SCRIPT = template.render(site=SITE, parent_pipeline_id=PARENT_PIPELINE_ID, simulation_node_name="oob-mgmt-server", ci_server_url=os.getenv('CI_SERVER_URL'), runner_reg_token=os.getenv('RUNNER_REG_TOKEN'))
    NETQ_TS_REG_SCRIPT = template.render(site=SITE, parent_pipeline_id=PARENT_PIPELINE_ID, simulation_node_name="netq-ts", ci_server_url=os.getenv('CI_SERVER_URL'), runner_reg_token=os.getenv('RUNNER_REG_TOKEN'))

    #render template and send instruction for runner register
    drop_runner_reg_instruction(OOB_NODE, OOB_REG_SCRIPT)
    drop_runner_reg_instruction(NETQ_TS_NODE, NETQ_TS_REG_SCRIPT)

    print ("Done")
