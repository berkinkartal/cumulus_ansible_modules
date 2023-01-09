#!/bin/bash
set -x
ansible-playbook -i inventories/evpn_symmetric/hosts playbooks/print_variables.yml
ansible-playbook -i inventories/evpn_centralized/hosts playbooks/print_variables.yml
ansible-playbook -i inventories/evpn_l2only/hosts playbooks/print_variables.yml
ansible-playbook -i inventories/evpn_mh/hosts playbooks/print_variables.yml
