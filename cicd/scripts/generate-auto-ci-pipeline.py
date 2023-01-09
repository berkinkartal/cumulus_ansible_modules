#!/usr/bin/env python

import os
from jinja2 import Environment, FileSystemLoader

#pull inventories
sites = os.listdir('inventories')

#load template
file_loader = FileSystemLoader('cicd/templates')
env = Environment(loader=file_loader)
template = env.get_template('gitlab-auto-ci-template.j2')

### Render template to create autoci pipeline
print (sites)
#render template
output = template.render(sites=sites)
print (output)
print ("*************** end of template **************")
# write the yml to file - formatting part of template
outputfile = open("auto-ci-pipeline.yml", "w")
outputfile.write(output)
outputfile.close()
