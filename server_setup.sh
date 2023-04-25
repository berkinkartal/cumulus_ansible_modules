#!/bin/bash

# Update ansible hosts to connect to servers
echo '
[Unknown:vars]
ansible_user=ubuntu
ansible_become_pass=nvidia
ansible_ssh_pass=nvidia' >> /etc/ansible/hosts


cat <<EOT > server_setup.yaml

---
# Setup server packages, initial configs etc

- hosts: server01,server02,server03,server04
  gather_facts: no
  tasks:
    - name: install traceroute package
      become: yes
      apt:
        name: traceroute
        state: present

- hosts: server01,server02,server03,server04
  gather_facts: no
  tasks:
    - name: install net-tools package
      become: yes
      apt:
        name: net-tools
        state: present


EOT

chmod 755 server_setup.yaml

ansible-playbook server_setup.yaml
