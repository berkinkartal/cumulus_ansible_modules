#!/usr/bin/env python

import json
import sys
import os
from air_sdk import AirApi

#check for staging
if "staging" in os.getenv('CI_COMMIT_REF_NAME'):
    print ("ON staging branch. using air staging")
    air = AirApi(api_url='https://staging.air.cumulusnetworks.com/api/', username=os.getenv('AIR_USERNAME'), password=os.getenv('AIR_PASSWORD'))
else:
    print ("Didn't detect staging branch. Using air prod")
    air = AirApi(username=os.getenv('AIR_USERNAME'), password=os.getenv('AIR_PASSWORD'))

########## Delete the sim we cloned for test
# pull back in simulation id
simulation_response = {}
with open('simulation_duplicate_response.json') as json_file:
    simulation_response = json.load(json_file)

tested_simulation = air.simulations.get(simulation_response["id"])

# Uncomment if we want to unconditionally dispose of the test sim
#tested_simulation.delete()

# Uncomment if we want to store and power off the test simulation
#tested_simulation.store()

print("")
print("")
print("Simulation Passed:")
print("")
print("Simulation Owner: " + tested_simulation.name)
#print("Simulation Title: " + tested_simulation.name)
print("Simulation API URL: " + tested_simulation.url)
print("Simulation ID: " + tested_simulation.id)
print("NetQ Username: " + tested_simulation.netq_username)
print("NetQ Password: " + tested_simulation.netq_password)
print("NetQ URL: https://air.netq.cumulusnetworks.com")
print("AIR UI Simulation Access URL: https://air.cumulusnetworks.com/" + tested_simulation.id + "/Simulation")
print("")
