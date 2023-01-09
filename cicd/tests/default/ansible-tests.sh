#!/bin/bash
# Test all playbooks

set -x

####
ansible-playbook -i inventories/evpn_symmetric/hosts playbooks/deploy.yml -t interfaces,frr,backup,servers
ansible -i inventories/evpn_symmetric/hosts leaf:spine:border -a "reboot" -b
sleep 60
ansible-playbook -i inventories/evpn_symmetric/hosts playbooks/pingtest.yml

####
ansible-playbook -i inventories/evpn_centralized/hosts playbooks/deploy.yml -t interfaces,frr,backup,servers
ansible -i inventories/evpn_centralized/hosts leaf:spine:border -a "reboot" -b
sleep 60
ansible-playbook -i inventories/evpn_centralized/hosts playbooks/pingtest.yml

####
ansible-playbook -i inventories/evpn_l2only/hosts playbooks/deploy.yml -t interfaces,frr,backup,servers
ansible -i inventories/evpn_l2only/hosts leaf:spine:border -a "reboot" -b
sleep 60
ansible-playbook -i inventories/evpn_l2only/hosts playbooks/pingtest.yml

####
ansible-playbook -i inventories/evpn_mh/hosts playbooks/deploy.yml -t interfaces,frr,backup,servers
ansible -i inventories/evpn_mh/hosts leaf:spine:border -a "reboot" -b
sleep 60
ansible-playbook -i inventories/evpn_mh/hosts playbooks/pingtest.yml
