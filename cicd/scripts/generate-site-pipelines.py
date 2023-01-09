#!/usr/bin/env python

import os
from jinja2 import Environment, FileSystemLoader

#pull inventories
sites = os.listdir('inventories')

#get the current parent pipeline id (I'm in the parent pipeline now)
parent_pipeline_id = os.getenv('CI_PIPELINE_ID')

#load template
file_loader = FileSystemLoader('cicd/templates')
env = Environment(loader=file_loader)
template = env.get_template('site-ci-template.j2')

for site in sites:
  print (site)
  #render template
  output = template.render(site=site, parent_pipeline_id=parent_pipeline_id)
  print (output)
  print ("*************** end of template **************")
  # write the yml to file - formatting part of template
  outputfile = open(site + "-pipeline.yml", "w")
  outputfile.write(output)
  outputfile.close()
