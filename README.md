---
title: Data Center Interconnect Reference Guide Labs
author: Berkin Kartal
date: 19/04/2023
version: 1.1
---

This document aims at helping the user to be able to connect and use AIR labs created for DCI Reference Guide document

In general labs cover three main use cases:

- Layer-2 Fabric Extension using EVPN/VXLAN signaling
- Layer-3 routed VRF extension over EVPN/VXLAN fabric with Type-5 prefixes
- Layer-3 routed VRF extension over EVPN/VXLAN fabric with Type-5 prefixes and leaking VRF routes

<img src="/topology/DCI_Scenario-I.png" width="800px">

## Related reading material


Before doing any further reading on this lab guide, please make sure that you read and digest the following reference guide which is the foundation of all this lab.
DCI reference guide :   [DCI-v1_draft.docx](https://nvidia-my.sharepoint.com/:w:/p/berkink/EfGN74tRbLVFgA6mOJ-OEHABr_GdBoS58FsQFpt7nk6FFw) 


## AIR lab

- [NVDIA AIR Lab with generic DCI topology](https://air.nvidia.com/78798265-2a47-432a-8b69-a7f00ec7a823/Simulation)
- Connectivity via AIR web GUI or SSH console (internet exposed worker url and TCP port for SSH connection can be found inside AIR simulation)
- In order to connect to oob-mgmt-server, please open the AIR lab url and check for worker url and port
- oob-mgmt-server access credentials : ubuntu/Nvidia1!
- All switches can be connected from oob-management-server using SSH public key authentication
- Linux servers can be connected with (ubuntu/nvidia) credentials


## Ansible playbooks in repo

Repository "cumulus_ansible_modules" is cloned to the home folder (/home/ubuntu/) of oob-mgmt-server VM and consists of the following scripts & playbooks:

- In order to run the scripting, the user should be in /home/ubuntu/cumulus_ansible_modules folder, which is the root for the repo
```
ubuntu@oob-mgmt-server:~$ cd cumulus_ansible_modules/
ubuntu@oob-mgmt-server:~/cumulus_ansible_modules$
```
- "lab_setup.sh" : a bash script in the repository which call necessary ansible playbooks with required arguments in order to save/backup and restore existing configurations
- all configs are stored in the repo directory structure, so it's easy to revert back to previously prepared config or save your existing config
- There's a cleanup function implemented in the script which wipes everything but the hostname of the switch

Topology related information, diagram in svg and in png format, topology dot file and json file are located in 'topology/' folder
| File Name                    | Description                        |
| ---------------------------- | ---------------------------------- |
| topology/DCI_Scenario-I.dot  | AIR topology file                  |
| topology/DCI_Scenario-I.json | AIR json file                      |
| topology/DCI_Scenario-I.svg  | AIR generated topology diagram     |
| topology/DCI_Scenario-I.png  | png format topology diagram        |
| topology/dci1.png            | Simple hand drawn topology         |



Saved reference configuration is under 'backups/' folder
| File Name                         | Description                        |
| --------------------------------- | ---------------------------------- |
| backups/evpn_l2_dci_backups       | Layer2 stretch topology configs    |
| backups/evpn_l3_dci_backups       | Layer3 VRF stretch topology configs    |
| backups/evpn_l3_dci_route-leaking | Layer3 VRF stretch topology with route leaking configs    |


Users can save their own  configuration is under 'backups2/' folder when a custom change needs to be made or a previously prepared custom config must be loaded which is different than reference configuration
| File Name                         | Description                        |
| --------------------------------- | ---------------------------------- |
| backups2/evpn_l2_dci_backups       | Layer2 stretch topology configs    |
| backups2/evpn_l3_dci_backups       | Layer3 VRF stretch topology configs    |
| backups2/evpn_l3_dci_route-leaking | Layer3 VRF stretch topology with route leaking configs    |


## Scripting functions
All the configuration backup and restore operations in this lab is scripted and there's a quick healthcheck function added into the main 'lab_setup.sh' bash script.
Here're the following functions implemented in this script:
| Function                         | Description                                                                      | Command line argument  |
| -------------------------------- | -------------------------------------------------------------------------------- | ---------------------- |
| Restore from Reference Config    | Load configuration based on a selected use case (1|2|3) from Reference configs   | '-R'                     |
| Restore from customized Config   | Load configuration based on a selected use case (1|2|3) from customized configs  | '-r'                     |
| Backup as customized Config      | Backup customized configuration for a selected use case (1|2|3)                  | '-b'                     |
| Select use case                  | Select a use case for Backup/Restore/Test operations                             | '-t <1|2|3>'             |
| Clean up all configs             | Clean up all configs with a minimum default configuration                        | '-C'                     |
| Run end to end connectivity tests| Run ping tests from server to server based on a selected use case (1|2|3)        | '-p'                     |

## How to restore from a saved lab config 

The script 'lab_setup.sh' should be provided with command line arguments what will select corresponding use case and desired restore action (either from custom saved config or from predefined reference config)

These are the use cases covered in this lab:

| Use Case ID | Use Case Name              | Description                                                |
| ------------| -------------------------- | ---------------------------------------------------------- |
| 1           | evpn_l2_dci_backups        | Layer2 stretch topology use case                           |
| 2           | evpn_l3_dci_backups        | Layer3 VRF stretch topology use case                       |
| 3           | evpn_l3_dci_route-leaking  | Layer3 VRF stretch topology with route leaking use case   |

Based on the use case, user must select the corresponding "Use case ID" (1 | 2 | 3) in order to restore the right config on simulated environment.

Additonally the correct restore action must be selected as a command line argument:
| Argument  | Description                                   |
| --------- | --------------------------------------------- |
| -r        | restore custom config from Backups2 folder    |
| -R        | Restore reference config from Backups folder  |

### Examples

Following example restores switch and server configs `Layer2 stretch topology use case` from reference config

```
./lab_setup.sh -t 1 -R
```

Following example restores switch and server configs `Layer3 VRF stretch topology use case` from reference config

```
./lab_setup.sh -t 2 -R
```

Following example restores switch and server configs `Layer3 VRF stretch topology with route leaking use case` from custom config store (under backups2 folder)

```
./lab_setup.sh -t 3 -r
```

## How to save / backup config from existing lab to oob-mgmt-server


If you'd like to save your custom config changes to oob-mgmt-server and pull the config for later use:
| Argument  | Description                                           |
| --------- | ----------------------------------------------------- |
| -b        | Backup custom config from AIR lab to Backups2 folder  |


### Examples

Following example backs up switch and server configs for `Layer2 stretch topology use case` into repo

```
./lab_setup.sh -t 1 -b
```

Following example backs up switch and server configs for `Layer3 VRF stretch topology use case` into repo

```
./lab_setup.sh -t 2 -R
```


## How to clean up all switch configs in AIR


If you'd like to start the lab from scratch and configure everything yourself, it's possible to wipe out all switch configs from the script:use:
| Argument  | Description                                           |
| --------- | ----------------------------------------------------- |
| -C        | Clean up all switch configs from AIR lab              |


### Example

```
./lab_setup.sh -C
```
## How to run end to end tests

If you'd like to run a simple end to end ping test between servers attached to the fabric, there're four servers attached to the topology (please see the diagram for server01, server02, server03 and server04). Based on the selected use case (1|2|3) topology these servers have particular connecitivity in between each other. For example in use case #1 (L2 stretch), server01 and server03 are in the same broadcast domand and in the same IP subnet. Therefore they're L2 adjacent to each other and should see each others' MAC in their ARP cache, same for server02 and server04. However they cannot communicate cross VRF (server01 <==> server02 or server01 <==> server04>). Details of each use cases' connetivity options are explained in the DCI reference guide (linked top of this file).


### Examples

Following example runs pre-defined test commands for use case #1
```
./lab_setup.sh -t 1 -p
```

Following example runs pre-defined test commands for use case #1
```
./lab_setup.sh -t 2 -p
```