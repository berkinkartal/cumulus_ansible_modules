

#!/bin/bash
#
# This runs as root. Users use the system as cumulus
# mind your chmods and chowns for things you want user cumulus to use
#
# clone test drive automation repo for on demand test drives
rm -rf /home/ubuntu/cumulus_ansible_modules
git clone https://github.com/berkinkartal/cumulus_ansible_modules.git /home/ubuntu/cumulus_ansible_modules
chown -R ubuntu:ubuntu /home/ubuntu/cumulus_ansible_modules
chown -R ubuntu:ubuntu /home/ubuntu/.ansible/

# add some ansible ssh convenience settings so ad hoc ansible works easily
cat <<EOT > /etc/ansible/ansible.cfg

[defaults]
roles_path = ./roles
host_key_checking = False
pipelining = True
forks = 50
deprecation_warnings = False
jinja2_extensions = jinja2.ext.do
force_handlers = True
retry_files_enabled = False
transport = paramiko
ansible_managed = # Ansible Managed File
# Time the task execution
callback_whitelist = profile_tasks
# Use the YAML callback plugin.
stdout_callback = yaml
# Use the stdout_callback when running ad-hoc commands.
# bin_ansible_callbacks = True
interpreter_python = auto_silent
#strategy = free
allow_world_readable_tmpfiles = True

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null


EOT
chmod -R 755 /etc/ansible/*

# disable ssh key checking
cat <<EOT > /home/ubuntu/.ssh/config
Host *
    StrictHostKeyChecking no
EOT
chown -R ubuntu:ubuntu /home/ubuntu/.ssh

#apt update -qy
#apt install -qy ntp

# Need gitlab-runner now that we're on ubuntu
#apt install gitlab-runner -y

# Update ansible hosts to connect to servers
#echo '

#[host:vars]
#ansible_user=ubuntu
#ansible_become_pass=nvidia
#ansible_ssh_pass=nvidia' >> /etc/ansible/hosts
