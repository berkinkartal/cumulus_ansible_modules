---
title: Data Center Interconnect Reference Guide Labs
author: Berkin Kartal
date: 12/04/2023
version: 1.0
---

This document aims at helping the user to be able to connect and use AIR labs created for DCI Reference Guide document

In general labs cover three main use cases:

- Layer-2 Fabric Extension using EVPN/VXLAN signaling
- Layer-3 routed VRF extension over EVPN/VXLAN fabric with Type-5 prefixes
- Layer-3 routed VRF extension over EVPN/VXLAN fabric with Type-5 prefixes and leaking VRF routes

<img src="/topology/DCI_Scenario-I.png" width="800px">

## AIR lab

- [NVDIA AIR Lab with generic DCI topology](https://air.nvidia.com/78798265-2a47-432a-8b69-a7f00ec7a823/Simulation)
- Connectivity via AIR web GUI or SSH console (internet exposed worker url and TCP port for SSH connection can be found inside AIR simulation)
- In order to connect to oob-mgmt-server, please open the AIR lab url and check for worker url and port
- oob-mgmt-server access credentials : ubuntu/Nvidia1!
- All switches can be connected from oob-management-server using SSH public key authentication
- Linux servers can be connected with (ubuntu/nvidia) credentials


## Ansible playbooks in repo

Repository "cumulus_ansible_modules" is cloned to the home folder (/home/ubuntu/) of oob-mgmt-server VM and consists of the following scripts & playbooks:

- backup.sh invoking backup.yml
- restore.sh invoking restore.yml
- cleanup.sh invoking cleanup/main.yaml

Topology related information, diagram in svg and in png format, topology dot file and json file are located in 'topology/' folder
| File Name                    | Description                        |
| ---------------------------- | ---------------------------------- |
| topology/DCI_Scenario-I.dot  | AIR topology file                  |
| topology/DCI_Scenario-I.json | AIR json file                      |
| topology/DCI_Scenario-I.svg  | AIR generated topology diagram     |
| topology/DCI_Scenario-I.png  | png format topology diagram        |
| topology/dci1.png            | simple hand drawn topology         |



Saved reference configuration is under 'backups/' folder
| File Name                         | Description                        |
| --------------------------------- | ---------------------------------- |
| backups/evpn_l2_dci_backups       | Layer2 stretch topology configs    |
| backups/evpn_l3_dci_backups       | Layer3 VRF stretcg topology configs    |
| backups/evpn_l3_dci_route-leaking | LLayer3 VRF stretcg topology with route leaking configs    |

## How to restore from a saved lab config 

On the server is a folder with one file called `fetch.yml`.

    user@server ~/consulting/fetch $ ls
    fetch.yml

The content of the file is very simple:

    ---
    - hosts: leaf1
      become: yes
      tasks:
        - name: Fetch ports.conf
          fetch: dest=save/{{ansible_hostname}}/startup.yaml src=/etc/nvue.d/startup.yaml flat=yes



To run the playbook, run the `ansible-playbook` command:

    user@server ~/consulting/fetch $ ansible-playbook fetch.yml

    PLAY [leaf1] ******************************************************************

    GATHERING FACTS ***************************************************************
    ok: [leaf1]

    TASK: [Fetch startup.yaml] ******************************************************
    changed: [leaf1]

    PLAY RECAP ********************************************************************
    leaf1                      : ok=5    changed=3    unreachable=0    failed=0

The playbook copies startup.yaml file used as Cumulus Linux NVUE startup configuration to the server:

| File Name               | Description                        |
| ----------------------- | ---------------------------------- |
| /etc/nvue.d/startup.yaml | Configuration file for NVUE       |


For more information on which files to back up and what Cumulus Linux uses, read [Upgrading Cumulus Linux]({{<ref "/cumulus-linux-54/Installation-Management/Upgrading-Cumulus-Linux#back-up-and-restore-configuration-with-nvue" >}}).

The playbook copies the files to a directory called `save`:

    user@server ~/consulting/fetch $ ls
    fetch.yml  save

The playbook puts the files into a directory based on the hostname. This particular example shows the playbook ran only on one switch named leaf1:

    user@server ~/consulting/fetch/save $ ls
    leaf1

The playbook stores all the files in the `leaf1` directory:

    user@server ~/consulting/fetch/save/leaf1 $ ls
    startup.yaml

## Example Copy

On the server, Ansible added a file called `copy.yml` to the directory; the file has this content:

    ---
    - hosts: leaf1
      become: yes
      tasks:
        - name: Restore startup.yaml
          copy: src=save/{{ansible_hostname}}/startup.yaml dest=/etc/nvue.d/
       
        - name : Switch - Config apply
          command: nv config apply startup -y

This file just pushes back the already saved startup.yaml file, then applies the configuration from startup.yaml file and this restarts the related processes and daemons in the background.  Instead of issuing a `service=networking` command, the `ifreload -a` command ran directly.

    user@server ~/consulting/fetch $ ansible-playbook copy.yml

    PLAY [leaf1] ******************************************************************

    GATHERING FACTS ***************************************************************
    ok: [leaf1]

    TASK: [Restore startup.yaml] *******************************************************
    ok: [leaf1]

        TASK: [Switch - Config apply] *********************************************************
    changed: [leaf1]


    PLAY RECAP ********************************************************************
               to retry, use: --limit @/home/user/copy.retry

    leaf1                      : ok=8    changed=4    unreachable=0    failed=0

With the startup.yaml file pushed back to the switch, it now operates on the previous snapshot.

You could base the `save` directory on the time of day rather than a generic folder called `save` by using:

    {{ansible_date_time.time}}

You can find more information on which facts Ansible gathers by reading {{<link url="Gathering-Ansible-Facts-on-Cumulus-Linux" text="this article">}}.
