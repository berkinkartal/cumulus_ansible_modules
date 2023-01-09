#!/usr/bin/env python

import os
import json
import sys
import re
from air_sdk import AirApi
from datetime import datetime, timedelta

# argv[0],[1],[2] is len of 3
if len(sys.argv) == 3:
    SITE = sys.argv[1]
    PARENT_PIPELINE_ID = sys.argv[2]
else:
    print("Arg error. Abort")
    sys.exit(1)

#check for staging
if "staging" in os.getenv('CI_COMMIT_REF_NAME'):
    print ("ON staging branch. using air staging")
    air = AirApi(api_url='https://staging.air.cumulusnetworks.com/api/', username=os.getenv('AIR_USERNAME'), password=os.getenv('AIR_PASSWORD'))
else:
    print ("Didn't detect staging branch. Using air prod")
    air = AirApi(username=os.getenv('AIR_USERNAME'), password=os.getenv('AIR_PASSWORD'))

# Get the current CITC simulation & output for report
citc_simulation = air.simulations.get_citc_simulation()
print (citc_simulation.__dict__)

#clone that simulation
cloned_simulation, response = air.simulations.duplicate(citc_simulation)
#cloned_simulation, response = air.simulations.duplicate("65b56ce4-827f-430f-bd88-ce470f7ce4df")

print("Simulation clone response:")
print(response)
print("")
print("Cloned simulation object dump:")
print(cloned_simulation.__dict__)
print("")

### Next update/set cloned sim details
# calculate sleep/expires timers for CI run
now_time = datetime.now()
expires_at = now_time + timedelta(hours=4)
#sleep_at = now_time + timedelta(hours=4)

# generate some strings we'll use to update the simulation details with
sim_name = SITE + ":" + PARENT_PIPELINE_ID
title = "PRA CI Simulation " + SITE

# update sim name
cloned_simulation.update(name=sim_name, title=title, expires_at=expires_at.isoformat(), sleep="false")

print("Cloned sim details post update:")
print(cloned_simulation.__dict__)
print("")

# Enable permissions/visibility on AIR by email address:
with open('cicd/email-permissions.txt') as f:
    emails = f.read().splitlines()

#print (emails)
for email in emails:
    try:
        print ("Enabling permission for: " + email)
        cloned_simulation.add_permission(email)
    except:
        print(f'Invalid email address detected: {email}')

#store elements of the duplicated simulation that I care about for later CI jobs. Only the ID for now.
simulation_duplicate_response = {}
simulation_duplicate_response["id"] = cloned_simulation.id
print("Duplicated sim id:")
print(json.dumps(simulation_duplicate_response, indent=4))
print("Writing to file...")
with open('simulation_duplicate_response.json', 'w') as outfile:
    json.dump(simulation_duplicate_response, outfile)
