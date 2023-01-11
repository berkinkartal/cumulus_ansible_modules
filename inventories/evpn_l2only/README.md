# Layer 2 Extension with EVPN ControI Plane

This repository holds the best-practice configuration for deployment of the [EVPN Layer 2 Extension](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/Basic-Configuration/) configuration on a redundanent pair of TOR switches and VXLAN-EVPN fabric. In this demo, we demonstrate the [EVPN Centrazlied Routing](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/Configuration-Examples/#evpn-centralized-routing) configuration using the [NVUE Object Model](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/NVIDIA-User-Experience-NVUE/NVUE-Object-Model/) and [NVUE CLI](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/NVIDIA-User-Experience-NVUE/NVUE-CLI/).

When layer 2 domains are divided by layer 3 fabrics and need to be stretched over them (e.g. some legacy L2 apps, ESF, etc.), we have to use VXLAN encapsulation to tunnel the layer 2 traffic over the layer 3 underlay network. Each ToR (leaf) is a VTEP and hosts the VLANs (mapped to VNIs) located on its rack. For having an extended layer 2 domain, the same VNI has to be set on all VTEPs where the specific subnet is located.

Using this type of environment doesn't allow inter-VLAN connectivity. Thus, to route between different VNIs, [EVPN Centralized](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/Configuration-Examples/#evpn-centralized-routing) or [Distributed Symmetric](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/Inter-subnet-Routing/#symmetric-routing) routing need to be used.

Check out [Cumulus Linux documentation](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/Inter-subnet-Routing/) for more information and examples.

Check out this [blog](https://developer.nvidia.com/blog/looking-behind-the-curtain-of-evpn-traffic-flows/) to deeper understand the EVPN traffic flows in a virtualized environment.

## Features and Services

This demo includes the following features and services:

 * [MLAG](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-2/Multi-Chassis-Link-Aggregation-MLAG/) L2 server redundancy 
 * [BGP](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-3/Border-Gateway-Protocol-BGP/) underlay fabric using [BGP unnumbered](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-50/Layer-3/Border-Gateway-Protocol-BGP/#bgp-unnumbered) interfaces
 * Management and default [VRFs](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-3/VRFs/Virtual-Routing-and-Forwarding-VRF/) for mgmt., underlay and overlay traffic 
 * [VXLAN](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/) overlay encapsulation data plane
 * [EVPN](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/) overlay control plane
 * [EVPN Layer 2 Extension](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/Basic-Configuration/)
 * [SNMP](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Monitoring-and-Troubleshooting/Simple-Network-Management-Protocol-SNMP/Configure-SNMP/)
 * [NTP](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/Date-and-Time/Network-Time-Protocol-NTP/) service
 * [DNS](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-3/VRFs/Management-VRF/#management-vrf-and-dns) service
 * [Syslog](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Monitoring-and-Troubleshooting/#send-log-files-to-a-syslog-server) service
 * [TACACS+ Client](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/Authentication-Authorization-and-Accounting/TACACS/)
 * [NVUE Snippets](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/NVIDIA-User-Experience-NVUE/NVUE-Snippets/)
 
## Demo Topology Information 

### Devices

The sample topology consist of 10 switches running Cumulus Linux 5.1, 8 Ubuntu servers and 2 firewalls (Ubuntu).

| __Leaf__ | __Border__ | __Spine__ | __Server__ | __Firewall__ | 
| -------- | ---------- | --------- | ---------- | ------------ |
| leaf01   | border01   | spine01   | server01   | fw1          |
| leaf02   | border02   | spine02   | server02   | fw2          |
| leaf02   |            | spine03   | server03   |              |
| leaf04   |            | spine04   | server04   |              |
|          |            |           | server05   |              |
|          |            |           | server06   |              |
|          |            |           | server07   |              |
|          |            |           | server08   |              |

**Note:** `server07`, `server08`, `fw1` and `fw2` are connected to the border leaves but have no configuration. They exist in the topology for your convenience in case you want to try other technologies and configurations related to this type of EVPN environment. `border01` and `border02` are configured with all VXLAN-EVPN configuration (NVE, VNIs, etc.) but doesn't participate in traffic forwarding in this scenario. You can use them to add centralized routing for example. 

### IPAM

#### Hosts

| __Hostname__| __Interface__ | __VRF__ | __VLAN__ | __IP Address__    |
| ---------   | ------------- | ------- | -------- | ----------------- |
| server01    | eth0          | mgmt.   |          | 192.168.200.10/24 |
|             | uplink        | default | 10       | 10.1.10.101/24    |
| server02    | eth0          | mgmt.   |          | 192.168.200.11/24 |
|             | uplink        | default | 20       | 10.1.20.102/24    |
| server03    | eth0          | mgmt.   |          | 192.168.200.12/24 |
|             | uplink        | default | 30       | 10.1.30.103/24    |
| server04    | eth0          | mgmt.   |          | 192.168.200.13/24 |
|             | uplink        | default | 10       | 10.1.10.104/24    |
| server05    | eth0          | mgmt.   |          | 192.168.200.14/24 |
|             | uplink        | default | 20       | 10.1.20.105/24    |
| server06    | eth0          | mgmt.   |          | 192.168.200.15/24 |
|             | uplink        | default | 30       | 10.1.30.106/24    |
| server07    | eth0          | mgmt.   |          | 192.168.200.18/24 |
| server08    | eth0          | mgmt.   |          | 192.168.200.19/24 |
| fw1         | eth0          | mgmt.   |          | 192.168.200.20/24 |
| fw2         | eth0          | mgmt.   |          | 192.168.200.21/24 |

#### Switches

| __Hostname__| __Interface__ | __VRF__ | __VLAN__ | __IP Address__    |
| ---------   | ------------- | ------- | -------- | ----------------- |
| leaf01      | eth0          | mgmt.   |          | 192.168.200.6/24  |
|             | bond1         | default | 10       |                   |
|             | bond2         | default | 20       |                   |
|             | bond3         | default | 30       |                   |
|             | lo            | default |          | 10.10.10.1/32     |
|             | vxlan-anycast |         |          | 10.0.1.12/32      |
| leaf02      | eth0          | mgmt.   |          | 192.168.200.7/24  |
|             | bond1         | default | 10       |                   |
|             | bond2         | default | 20       |                   |
|             | bond3         | default | 30       |                   |
|             | lo            | default |          | 10.10.10.2/32     |
|             | vxlan-anycast |         |          | 10.0.1.12/32      |
| leaf03      | eth0          | mgmt.   |          | 192.168.200.8/24  |
|             | bond1         | default | 10       |                   |
|             | bond2         | default | 20       |                   |
|             | bond3         | default | 30       |                   |
|             | lo            | default |          | 10.10.10.3/32     |
|             | vxlan-anycast |         |          | 10.0.1.34/32      |
| leaf04      | eth0          | mgmt.   |          | 192.168.200.9/24  |
|             | bond1         | default | 10       |                   |
|             | bond2         | default | 20       |                   |
|             | bond3         | default | 30       |                   |
|             | lo            | default |          | 10.10.10.4/32     |
|             | vxlan-anycast |         |          | 10.0.1.34/32      |
| border01    | eth0          | mgmt.   |          | 192.168.200.16/24 |
|             | lo            | default |          | 10.10.10.63/32    |
|             | vxlan-anycast |         |          | 10.0.1.255/32     |
| border02    | eth0          | mgmt.   |          | 192.168.200.17/24 |
|             | lo            | default |          | 10.10.10.64/32    |
|             | vxlan-anycast |         |          | 10.0.1.255/32     |
| spine01     | eth0          | mgmt.   |          | 192.168.200.2/24  |
|             | lo            | default |          | 10.10.10.101/32   |
| spine02     | eth0          | mgmt.   |          | 192.168.200.3/24  |
|             | lo            | default |          | 10.10.10.102/32   |
| spine03     | eth0          | mgmt.   |          | 192.168.200.4/24  |
|             | lo            | default |          | 10.10.10.103/32   |
| spine04     | eth0          | mgmt.   |          | 192.168.200.5/24  |
|             | lo            | default |          | 10.10.10.104/32   |

Servers are configured for access VLAN on the leaf switches. They also use a default route for `10.0.0.0/8` via the VRR interfaces - `10.1.<VLAN_ID>.1`.

### Physical Connectivity

__Hostname__| __Local Port__ | __Remote Port__ | __Remote Device__ |
----------- | -------------- | --------------- | ----------------- |
| leaf01    | swp1           | eth1(uplink)    | server01          |
|           | swp2           | eth1(uplink)    | server02          |
|           | swp3           | eth1(uplink)    | server03          |
|           | swp49          | swp49           | leaf02            |
|           | swp50          | swp50           | leaf02            |
|           | swp51          | swp1            | spine01           |
|           | swp52          | swp1            | spine02           |
|           | swp53          | swp1            | spine03           |
|           | swp54          | swp1            | spine04           |
| leaf02    | swp1           | eth2(uplink)    | server01          |
|           | swp2           | eth2(uplink)    | server02          |
|           | swp3           | eth2(uplink)    | server03          |
|           | swp49          | swp49           | leaf01            |
|           | swp50          | swp50           | leaf01            |
|           | swp51          | swp2            | spine01           |
|           | swp52          | swp2            | spine02           |
|           | swp53          | swp2            | spine03           |
|           | swp54          | swp2            | spine04           |
| leaf03    | swp1           | eth1(uplink)    | server04          |
|           | swp2           | eth1(uplink)    | server05          |
|           | swp3           | eth1(uplink)    | server06          |
|           | swp49          | swp49           | leaf04            |
|           | swp50          | swp50           | leaf04            |
|           | swp51          | swp3            | spine01           |
|           | swp52          | swp3            | spine02           |
|           | swp53          | swp3            | spine03           |
|           | swp54          | swp3            | spine04           |
| leaf04    | swp1           | eth2(uplink)    | server04          |
|           | swp2           | eth2(uplink)    | server05          |
|           | swp3           | eth2(uplink)    | server06          |
|           | swp49          | swp49           | leaf03            |
|           | swp50          | swp50           | leaf03            |
|           | swp51          | swp4            | spine01           |
|           | swp52          | swp4            | spine02           |
|           | swp53          | swp4            | spine03           |
|           | swp54          | swp4            | spine04           |
| border01  | swp1           | eth1            | server07          |
|           | swp2           | eth1            | server08          |
|           | swp3           | eth1            | fw1               |
|           | swp4           | eth1            | fw2               |
|           | swp49          | swp49           | border02          |
|           | swp50          | swp50           | border02          |
|           | swp51          | swp5            | spine01           |
|           | swp52          | swp5            | spine02           |
|           | swp53          | swp5            | spine03           |
|           | swp54          | swp5            | spine04           |
| border02  | swp1           | eth2            | server07          |
|           | swp2           | eth2            | server08          |
|           | swp3           | eth2            | fw1               |
|           | swp4           | eth2            | fw2               |
|           | swp49          | swp49           | border01          |
|           | swp50          | swp50           | border01          |
|           | swp51          | swp6            | spine01           |
|           | swp52          | swp6            | spine02           |
|           | swp53          | swp6            | spine03           |
|           | swp54          | swp6            | spine04           |

## Automation

### Ansible

To configure the topoloty to EVPN Layer 2 Extension inter-subnet routing make sure to start the Cumulus Linux Reference Topology.<br>
Then follow the below steps from a shell session on the ansible server (`oob-mgmt-server` if in NVIDIA Air)

1) Clone the `cumulus_ansible_modules` repo:
```
ubuntu@server:~$ git clone https://gitlab.com/cumulus-consulting/goldenturtle/cumulus_ansible_modules
```

2) Navigate to the `evpn_demo_nvue` branch:
```bash
ubuntu@server:~$ cd cumulus_ansible_modules/
ubuntu@server:~/cumulus_ansible_modules$ git checkout evpn_demo_nvue
```

3) Test ansible server and topology devices connectivity using ansible `ping` module:
```bash
ubuntu@server:~/cumulus_ansible_modules$ ansible pod1 -i inventories/evpn_l2only/hosts -m ping
fw1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
spine01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
spine04 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
spine03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
fw2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
border01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
border02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
spine02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
leaf04 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
leaf01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
leaf03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
leaf02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
server02 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
server01 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
server03 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
server04 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
server05 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
server06 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
server08 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
server07 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```

3) Run `nvue.yaml` ansible playbook to deploy the demo on the fabric:
```bash
ubuntu@server:~/cumulus_ansible_modules$ ansible-playbook playbooks/nvue.yml -i inventories/evpn_l2only/hosts --diff
```

### Playbook Structure

The playbooks have the following important structure:
* Variables and inventories are stored in the same directory `inventories/`
* Backup configurations are stored in `configs/` folder of the invetory 
```bash
ubuntu@server:~/cumulus_ansible_modules$ cd inventories/evpn_l2only/config
```

## Network Configuratrion and Connectivity Validation

### Device Access

To enable device login using its hostname, you need to set its IP address in the ansible server `etc/hosts` file. 

e.g.
```bash
192.168.200.2 spine01
192.168.200.3 spine02
192.168.200.4 spine03
192.168.200.5 spine04
192.168.200.6 leaf01
192.168.200.7 leaf02
192.168.200.8 leaf03
192.168.200.9 leaf04
192.168.200.10 server01
192.168.200.11 server02
192.168.200.12 server03
192.168.200.13 server04
192.168.200.14 server05
192.168.200.15 server06
192.168.200.16 border01
192.168.200.17 border02
192.168.200.18 server07
192.168.200.19 server08
192.168.200.20 fw1
192.168.200.21 fw2
192.168.200.250 netq-ts
```

Login to the servers and firewalls using `ubuntu` username - `ssh ubuntu@<hostname>` or `ssh ubuntu@<ip-address>`.

Default servers credentials are:<br> 
Username: ***ubuntu***<br>
Password: ***nvidia*** 
```bash
ubuntu@server:~$ ssh ubuntu@server01
```
Login to the switches using `cumulus` username - `ssh cumulus@<hostname>` or `ssh cumulus@<ip-address>`.

Default switches credentials are:<br> 
Username: ***cumulus***<br>
Password: ***CumulusLinux!*** 
```bash
ubuntu@server:~$ ssh cumulus@leaf01
```

## Connectivity and Configuration Validation 

### Server to Server Connectivity

Log into `server01`:
```bash
ubuntu@server:~$ ssh server01
ubuntu@server01's password:
Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 4.15.0-166-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Jul  4 13:17:52 UTC 2022

  System load:  0.0               Processes:             94
  Usage of /:   24.5% of 9.29GB   Users logged in:       0
  Memory usage: 43%               IP address for eth0:   192.168.200.10
  Swap usage:   0%                IP address for uplink: 10.1.10.101

17 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

New release '20.04.4 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

*** System restart required ***
#########################################################
#      You are successfully logged in to: server01      #
#########################################################
Last login: Sun May 22 12:39:42 2022 from 192.168.200.1
ubuntu@server01:~$
```

Check `server04` reachability to validate L2 intra-VLAN connectivity:
```bash
ubuntu@server01:~$ ping 10.1.10.104 -c 3
PING 10.1.10.104 (10.1.10.104) 56(84) bytes of data.
64 bytes from 10.1.10.104: icmp_seq=1 ttl=64 time=2.70 ms
64 bytes from 10.1.10.104: icmp_seq=2 ttl=64 time=1.88 ms
64 bytes from 10.1.10.104: icmp_seq=3 ttl=64 time=1.96 ms

--- 10.1.10.104 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 1.887/2.186/2.709/0.374 ms
```

Check `server02`, `server03`, `server05` and `server06` reachability to validate that L3 inter-VLAN connectivity is not avaliable:
```bash
ubuntu@server01:~$  for srv in {20.102,30.103,20.105,30.106} ; do ping 10.1.${srv} -c 3; done
PING 10.1.20.102 (10.1.20.102) 56(84) bytes of data.
From 10.1.10.101 icmp_seq=1 Destination Host Unreachable
From 10.1.10.101 icmp_seq=2 Destination Host Unreachable
From 10.1.10.101 icmp_seq=3 Destination Host Unreachable

--- 10.1.20.102 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2026ms
PING 10.1.30.103 (10.1.30.103) 56(84) bytes of data.
From 10.1.10.101 icmp_seq=1 Destination Host Unreachable
From 10.1.10.101 icmp_seq=2 Destination Host Unreachable
From 10.1.10.101 icmp_seq=3 Destination Host Unreachable

--- 10.1.30.103 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2046ms
PING 10.1.20.105 (10.1.20.105) 56(84) bytes of data.
From 10.1.10.101 icmp_seq=1 Destination Host Unreachable
From 10.1.10.101 icmp_seq=2 Destination Host Unreachable
From 10.1.10.101 icmp_seq=3 Destination Host Unreachable

--- 10.1.20.105 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2046ms
PING 10.1.30.106 (10.1.30.106) 56(84) bytes of data.
From 10.1.10.101 icmp_seq=1 Destination Host Unreachable
From 10.1.10.101 icmp_seq=2 Destination Host Unreachable
From 10.1.10.101 icmp_seq=3 Destination Host Unreachable

--- 10.1.30.106 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2047ms
```

### Switches Configuration 

Althought Cumulus Linux 5.1 uses NVUE `configuration` commands, it still has limited `show` commands. Thus, as for now, to verify switch configuration, present states and get information, you can use the old NCLU `show` commands. In future Cumulus releases, NCLU `show` commands will no longer be avaliable and will be replaced with the new NVUE commands.

In the verification steps below, we use the combination of NVUE, Linux and NCLU commands. We present all outputs on `leaf01` as referance. 

Login to `leaf01`:
```bash
ubuntu@server:~$ ssh cumulus@leaf01
#####################################################################################
#  Welcome to NVIDIA Cumulus VX (TM) 5.1                                            #
#  NVIDIA Cumulus VX (TM) is a community supported virtual appliance designed       #
#  for experiencing, testing and prototyping NVIDIA Cumulus' latest technology.     #
#  For any questions or technical support, visit our community site at:             #
#  https://www.nvidia.com/en-us/support                                             #
#####################################################################################
Linux leaf01 4.19.0-cl-1-amd64 #1 SMP Debian 4.19.237-1+cl5.1.0u1 (2022-05-12) x86_64
#####################################################################################
#                     You are successfully logged in to: leaf01                     #
#####################################################################################
Last login: Sun May 22 12:36:45 2022 from 192.168.200.1
cumulus@leaf01:mgmt:~$
```

Check switch `applied` configuration (running-config):
```bash
cumulus@leaf01:mgmt:~$ nv config show
- set:
    bridge:
      domain:
        br_default:
          type: vlan-aware
          vlan:
            '10':
              vni:
                '10': {}
            '20':
              vni:
                '20': {}
            '30':
              vni:
                '30': {}
    evpn:
      enable: on
    mlag:
      backup:
        10.10.10.2: {}
      enable: on
      init-delay: 10
      mac-address: 44:38:39:BE:EF:AA
      peer-ip: linklocal
      priority: 1000
    nve:
      vxlan:
        arp-nd-suppress: on
        enable: on
        mlag:
          shared-address: 10.0.1.12
        source:
          address: 10.10.10.1
    router:
      bgp:
        enable: on
    service:
      dns:
        mgmt:
          server:
            1.1.1.1: {}
            8.8.8.8: {}
      ntp:
        mgmt:
          server:
            0.cumulusnetworks.pool.ntp.org:
              iburst: on
            1.cumulusnetworks.pool.ntp.org:
              iburst: on
            2.cumulusnetworks.pool.ntp.org:
              iburst: on
            3.cumulusnetworks.pool.ntp.org:
              iburst: on
      syslog:
        mgmt:
          server:
            192.168.200.1: {}
    system:
      config:
        snippet:
          snmp-config:
            content: |
              agentAddress 192.168.200.6@mgmt
              agentAddress udp6:[::1]:161
              rocommunity public
              # Cumulus specific
              view   systemonly  included   .1.3.6.1.4.1.40310.1
              view   systemonly  included   .1.3.6.1.4.1.40310.2
              # Memory utilization
              view   systemonly  included   .1.3.6.1.4.1.2021.4
              # CPU utilization
              view   systemonly  included   .1.3.6.1.4.1.2021.11
            file: /etc/snmp/snmpd.conf
            services:
              snmp:
                action: restart
                service: snmpd
          tacacs-config:
            content: |-
              secret=tacacskey
              server=192.168.200.1
              vrf=mgmt
            file: /etc/tacplus_servers
      hostname: leaf01
      message:
        post-login: |-
          #####################################################################################
          #                     You are successfully logged in to: leaf01                     #
          #####################################################################################
        pre-login: |-
          #####################################################################################
          #  Welcome to NVIDIA Cumulus VX (TM) 5.1                                            #
          #  NVIDIA Cumulus VX (TM) is a community supported virtual appliance designed       #
          #  for experiencing, testing and prototyping NVIDIA Cumulus' latest technology.     #
          #  For any questions or technical support, visit our community site at:             #
          #  https://www.nvidia.com/en-us/support                                             #
          #####################################################################################
      timezone: Etc/UTC
    vrf:
      default:
        router:
          bgp:
            address-family:
              ipv4-unicast:
                enable: on
                redistribute:
                  connected:
                    enable: on
              l2vpn-evpn:
                enable: on
            autonomous-system: 65101
            enable: on
            neighbor:
              peerlink.4094:
                peer-group: underlay
                type: unnumbered
              swp51:
                peer-group: underlay
                type: unnumbered
              swp52:
                peer-group: underlay
                type: unnumbered
              swp53:
                peer-group: underlay
                type: unnumbered
              swp54:
                peer-group: underlay
                type: unnumbered
            peer-group:
              underlay:
                address-family:
                  l2vpn-evpn:
                    enable: on
                remote-as: external
            router-id: 10.10.10.1
      mgmt:
        router:
          static:
            0.0.0.0/0:
              address-family: ipv4-unicast
              via:
                192.168.200.1:
                  type: ipv4-address
    interface:
      bond1-3:
        bond:
          lacp-bypass: on
          mlag:
            enable: on
          mode: lacp
        bridge:
          domain:
            br_default:
              stp:
                admin-edge: on
                auto-edge: on
                bpdu-guard: on
        link:
          mtu: 9000
        type: bond
      bond1:
        bond:
          member:
            swp1: {}
          mlag:
            id: 1
        bridge:
          domain:
            br_default:
              access: 10
      bond2:
        bond:
          member:
            swp2: {}
          mlag:
            id: 2
        bridge:
          domain:
            br_default:
              access: 20
      bond3:
        bond:
          member:
            swp3: {}
          mlag:
            id: 3
        bridge:
          domain:
            br_default:
              access: 30
      eth0:
        ip:
          address:
            192.168.200.6/24: {}
          vrf: mgmt
        type: eth
      lo:
        ip:
          address:
            10.10.10.1/32: {}
        type: loopback
      peerlink:
        bond:
          member:
            swp49: {}
            swp50: {}
        bridge:
          domain:
            br_default: {}
        type: peerlink
      peerlink.4094:
        base-interface: peerlink
        type: sub
        vlan: 4094
      swp51-54:
        link:
          state:
            up: {}
        type: swp
```
You can also check the exact CLI commands set into the system by using the `nv config show -o commands` command:
```bash
cumulus@leaf01:mgmt:~$ nv config show -o commands
nv set bridge domain br_default type vlan-aware
nv set bridge domain br_default vlan 10 vni 10
nv set bridge domain br_default vlan 20 vni 20
nv set bridge domain br_default vlan 30 vni 30
nv set evpn enable on
nv set mlag backup 10.10.10.2
nv set mlag enable on
nv set mlag init-delay 10
nv set mlag mac-address 44:38:39:BE:EF:AA
nv set mlag peer-ip linklocal
nv set mlag priority 1000
nv set nve vxlan arp-nd-suppress on
nv set nve vxlan enable on
nv set nve vxlan mlag shared-address 10.0.1.12
nv set nve vxlan source address 10.10.10.1
nv set router bgp enable on
nv set service dns mgmt server 1.1.1.1
nv set service dns mgmt server 8.8.8.8
nv set service ntp mgmt server 0.cumulusnetworks.pool.ntp.org iburst on
nv set service ntp mgmt server 1.cumulusnetworks.pool.ntp.org iburst on
nv set service ntp mgmt server 2.cumulusnetworks.pool.ntp.org iburst on
nv set service ntp mgmt server 3.cumulusnetworks.pool.ntp.org iburst on
nv set service syslog mgmt server 192.168.200.1
nv set system config snippet snmp-config content 'agentAddress 192.168.200.6@mgmt
agentAddress udp6:[::1]:161
rocommunity public
# Cumulus specific
view   systemonly  included   .1.3.6.1.4.1.40310.1
view   systemonly  included   .1.3.6.1.4.1.40310.2
# Memory utilization
view   systemonly  included   .1.3.6.1.4.1.2021.4
# CPU utilization
view   systemonly  included   .1.3.6.1.4.1.2021.11
'
nv set system config snippet snmp-config file /etc/snmp/snmpd.conf
nv set system config snippet snmp-config services snmp action restart
nv set system config snippet snmp-config services snmp service snmpd
nv set system config snippet tacacs-config content 'secret=tacacskey
server=192.168.200.1
vrf=mgmt'
nv set system config snippet tacacs-config file /etc/tacplus_servers
nv set system hostname leaf01
nv set system message post-login '#####################################################################################
#                     You are successfully logged in to: leaf01                     #
#####################################################################################'
nv set system message pre-login '#####################################################################################
#  Welcome to NVIDIA Cumulus VX (TM) 5.1                                            #
#  NVIDIA Cumulus VX (TM) is a community supported virtual appliance designed       #
#  for experiencing, testing and prototyping NVIDIA Cumulus'"'"' latest technology.     #
#  For any questions or technical support, visit our community site at:             #
#  https://www.nvidia.com/en-us/support                                             #
#####################################################################################'
nv set system timezone Etc/UTC
nv set vrf default router bgp address-family ipv4-unicast enable on
nv set vrf default router bgp address-family ipv4-unicast redistribute connected enable on
nv set vrf default router bgp address-family l2vpn-evpn enable on
nv set vrf default router bgp autonomous-system 65101
nv set vrf default router bgp enable on
nv set vrf default router bgp neighbor peerlink.4094 peer-group underlay
nv set vrf default router bgp neighbor peerlink.4094 type unnumbered
nv set vrf default router bgp neighbor swp51 peer-group underlay
nv set vrf default router bgp neighbor swp51 type unnumbered
nv set vrf default router bgp neighbor swp52 peer-group underlay
nv set vrf default router bgp neighbor swp52 type unnumbered
nv set vrf default router bgp neighbor swp53 peer-group underlay
nv set vrf default router bgp neighbor swp53 type unnumbered
nv set vrf default router bgp neighbor swp54 peer-group underlay
nv set vrf default router bgp neighbor swp54 type unnumbered
nv set vrf default router bgp peer-group underlay address-family l2vpn-evpn enable on
nv set vrf default router bgp peer-group underlay remote-as external
nv set vrf default router bgp router-id 10.10.10.1
nv set vrf mgmt router static 0.0.0.0/0 address-family ipv4-unicast
nv set vrf mgmt router static 0.0.0.0/0 via 192.168.200.1 type ipv4-address
nv set interface bond1-3 bond lacp-bypass on
nv set interface bond1-3 bond mlag enable on
nv set interface bond1-3 bond mode lacp
nv set interface bond1-3 bridge domain br_default stp admin-edge on
nv set interface bond1-3 bridge domain br_default stp auto-edge on
nv set interface bond1-3 bridge domain br_default stp bpdu-guard on
nv set interface bond1-3 link mtu 9000
nv set interface bond1-3 type bond
nv set interface bond1 bond member swp1
nv set interface bond1 bond mlag id 1
nv set interface bond1 bridge domain br_default access 10
nv set interface bond2 bond member swp2
nv set interface bond2 bond mlag id 2
nv set interface bond2 bridge domain br_default access 20
nv set interface bond3 bond member swp3
nv set interface bond3 bond mlag id 3
nv set interface bond3 bridge domain br_default access 30
nv set interface eth0 ip address 192.168.200.6/24
nv set interface eth0 ip vrf mgmt
nv set interface eth0 type eth
nv set interface lo ip address 10.10.10.1/32
nv set interface lo type loopback
nv set interface peerlink bond member swp49
nv set interface peerlink bond member swp50
nv set interface peerlink bridge domain br_default
nv set interface peerlink type peerlink
nv set interface peerlink.4094 base-interface peerlink
nv set interface peerlink.4094 type sub
nv set interface peerlink.4094 vlan 4094
nv set interface swp51-54 link state up
nv set interface swp51-54 type swp
```

To view the startup-configuration, you can print the `startup.yaml` file by `cat /etc/nvue.d/startup.yaml`.

**Note:** NVUE is a declerative CLI which allows you to handle switch configuration as a regular Git repository. It uses Git based configuration engine to enable commit, revert, branch, stash and diff behaviors. Check out the [Configuration Management Commands](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/NVIDIA-User-Experience-NVUE/NVUE-CLI/#configuration-management-commands) for more information.

### Protocols State

Verify bridge `br_default` is configured correctly:
```bash
cumulus@leaf01:mgmt:~$ nv show bridge domain br_default
                 operational  applied     description
---------------  -----------  ----------  ----------------------------------------------------------------------
encap            802.1Q       802.1Q      Interfaces added to this domain will, by default, use this encapsul...
mac-address                   auto        Override global mac address
type             vlan-aware   vlan-aware  Type of bridge domain.
untagged                      1           Interfaces added to this domain will, by default, be trunk interfac...
vlan-vni-offset               0           A VNI offset while (automatically) mapping VLANs to VNIs
multicast
  snooping
    enable       off          off         Turn the feature 'on' or 'off'.  The default is 'off'.
    querier
      enable     off                      Turn the feature 'on' or 'off'.  The default is 'off'.
stp
  priority       32768        32768       stp priority. The priority value must be a number between 4096 and...
  state          up           up          The state of STP on the bridge
[vlan]           10           10          Set of vlans in the bridge domain.  Only applicable when the domain...
[vlan]           20           20
[vlan]           30           30
[mdb]                                     Set of mdb entries in the bridge domain
[router-port]                             Set of multicast router ports
```

Verify MLAG operational state:
```bash
cumulus@leaf01:mgmt:~$ nv show mlag
                operational             applied            description
--------------  ----------------------  -----------------  ------------------------------------------------------
enable                                  on                 Turn the feature 'on' or 'off'.  The default is 'off'.
debug                                   off                Enable MLAG debugging
init-delay                              10                 The delay, in seconds, before bonds are brought up.
mac-address     44:38:39:be:ef:aa       44:38:39:BE:EF:AA  Override anycast-mac and anycast-id
peer-ip         fe80::4638:39ff:fe00:2  linklocal          Peer Ip Address
priority        1000                    1000               Mlag Priority
[backup]        10.10.10.2              10.10.10.2         Set of MLAG backups
anycast-ip      10.0.1.12                                  Vxlan Anycast Ip address
backup-active   True                                       Mlag Backup Status
backup-reason                                              Mlag Backup Reason
local-id        44:38:39:00:00:01                          Mlag Local Unique Id
local-role      primary                                    Mlag Local Role
peer-alive      True                                       Mlag Peer Alive Status
peer-id         44:38:39:00:00:02                          Mlag Peer Unique Id
peer-interface  peerlink.4094                              Mlag Peerlink Interface
peer-priority   1000                                       Mlag Peer Priority
peer-role       secondary                                  Mlag Peer Role
```
Verify MLAG interfaces state:
```bash
cumulus@leaf01:mgmt:~$ net show clag
The peer is alive
     Our Priority, ID, and Role: 1000 44:38:39:00:00:01 primary
    Peer Priority, ID, and Role: 1000 44:38:39:00:00:02 secondary
          Peer Interface and IP: peerlink.4094 fe80::4638:39ff:fe00:2 (linklocal)
               VxLAN Anycast IP: 10.0.1.12
                      Backup IP: 10.10.10.2 (active)
                     System MAC: 44:38:39:be:ef:aa

CLAG Interfaces
Our Interface      Peer Interface     CLAG Id   Conflicts              Proto-Down Reason
----------------   ----------------   -------   --------------------   -----------------
           bond1   bond1              1         -                      -
           bond2   bond2              2         -                      -
           bond3   bond3              3         -                      -
         vxlan48   vxlan48            -         -                      -
```

Verify that no configuration conflicts exist between the two MLAG peers:
```bash
cumulus@leaf01:mgmt:~$ nv show mlag consistency-checker global
Parameter                LocalValue              PeerValue               Conflict  Summary
-----------------------  ----------------------  ----------------------  --------  -------
+ anycast-ip             10.0.1.12               10.0.1.12               -
+ bridge-priority        32768                   32768                   -
+ bridge-stp             on                      on                      -
+ bridge-type            vlan-aware              vlan-aware              -
+ clag-pkg-version       1.6.0-cl5.1.0u18        1.6.0-cl5.1.0u18        -
+ clag-protocol-version  1.6.0                   1.6.0                   -
+ peer-ip                fe80::4638:39ff:fe00:2  fe80::4638:39ff:fe00:2  -
+ peerlink-master        br_default              NOT-SYNCED              -
+ peerlink-mtu           9216                    9216                    -
+ peerlink-native-vlan   1                       1                       -
+ peerlink-vlans         1, 10, 20, 30           1, 10, 20, 30           -
+ redirect2-enable       yes                     yes                     -
+ system-mac             44:38:39:be:ef:aa       44:38:39:be:ef:aa       -
```
```bash
cumulus@leaf01:mgmt:~$ nv show interface --view=mlag-cc
Interface  Conflict  LocalValue         Parameter         PeerValue
---------  --------  -----------------  ----------------  -----------------
+ bond1    -         yes                bridge-learning   yes
  bond1    -         1                  clag-id           1
  bond1    -         44:38:39:be:ef:aa  lacp-actor-mac    44:38:39:be:ef:aa
  bond1    -         44:38:39:00:00:2d  lacp-partner-mac  44:38:39:00:00:2d
  bond1    -         br_default         master            NOT-SYNCED
  bond1    -         9000               mtu               9000
  bond1    -         10                 native-vlan       10
  bond1    -         10                 vlan-id           10
+ bond2    -         yes                bridge-learning   yes
  bond2    -         2                  clag-id           2
  bond2    -         44:38:39:be:ef:aa  lacp-actor-mac    44:38:39:be:ef:aa
  bond2    -         44:38:39:00:00:2b  lacp-partner-mac  44:38:39:00:00:2b
  bond2    -         br_default         master            NOT-SYNCED
  bond2    -         9000               mtu               9000
  bond2    -         20                 native-vlan       20
  bond2    -         20                 vlan-id           20
+ bond3    -         yes                bridge-learning   yes
  bond3    -         3                  clag-id           3
  bond3    -         44:38:39:be:ef:aa  lacp-actor-mac    44:38:39:be:ef:aa
  bond3    -         44:38:39:00:00:33  lacp-partner-mac  44:38:39:00:00:33
  bond3    -         br_default         master            NOT-SYNCED
  bond3    -         9000               mtu               9000
  bond3    -         30                 native-vlan       30
  bond3    -         30                 vlan-id           30
+ vxlan48  -         br_default         master            NOT-SYNCED
  vxlan48  -         10, 20, 30         vlan              10, 20, 30
  vxlan48  -         10, 20, 30         vni               10, 20, 30
  vxlan48  -         vxlan48            vxlan-intf        vxlan48
```

On any MLAG configuration change, Cumulus Linux automatically validates the corresponding parameters on both MLAG peers and takes action based on the type of conflict it sees. For every conflict, the `/var/log/clagd.log` file records a log message. For more infomration about MLAG consistency-checker and other MLAG validations, check out the [MLAG Troubleshooting](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-2/Multi-Chassis-Link-Aggregation-MLAG/#troubleshooting) section in Cumulus Linux documentation.

Verify NVE interface (VTEP) state and configuration:
```bash
cumulus@leaf01:mgmt:~$ nv show nve vxlan
                          operational  applied     description
------------------------  -----------  ----------  ----------------------------------------------------------------------
enable                    on           on          Turn the feature 'on' or 'off'.  The default is 'off'.
arp-nd-suppress           on           on          Controls dynamic MAC learning over VXLAN tunnels based on received...
mac-learning              off          off         Controls dynamic MAC learning over VXLAN tunnels based on received...
mtu                       9216         9216        interface mtu
port                      4789         4789        UDP port for VXLAN frames
flooding
  enable                  on           on          Turn the feature 'on' or 'off'.  The default is 'off'.
  [head-end-replication]  evpn         evpn        BUM traffic is replicated and individual copies sent to remote dest...
mlag
  shared-address          10.0.1.12    10.0.1.12   shared anycast address for MLAG peers
source
  address                 10.10.10.1   10.10.10.1  IP addresses of this node's VTEP or 'auto'.  If 'auto', use the pri...
```

Verify BGP peerings (IPv4 and EVPN AF):
```bash
cumulus@leaf01:mgmt:~$ net show bgp summary
show bgp ipv4 unicast summary
=============================
BGP router identifier 10.10.10.1, local AS number 65101 vrf-id 0
BGP table version 16
RIB entries 25, using 5000 bytes of memory
Peers 5, using 114 KiB of memory
Peer groups 1, using 64 bytes of memory

Neighbor              V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt
leaf02(peerlink.4094) 4      65102       415       421        0    0    0 00:14:58           12       13
spine01(swp51)        4      65100       405       432        0    0    0 00:15:02            8       13
spine02(swp52)        4      65100       413       431        0    0    0 00:15:02            8       13
spine03(swp53)        4      65100       405       432        0    0    0 00:15:02            8       13
spine04(swp54)        4      65100       407       431        0    0    0 00:15:02            8       13

Total number of neighbors 5


show bgp ipv6 unicast summary
=============================
% No BGP neighbors found


show bgp l2vpn evpn summary
===========================
BGP router identifier 10.10.10.1, local AS number 65101 vrf-id 0
BGP table version 0
RIB entries 35, using 7000 bytes of memory
Peers 5, using 114 KiB of memory
Peer groups 1, using 64 bytes of memory

Neighbor              V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt
leaf02(peerlink.4094) 4      65102       415       421        0    0    0 00:14:59           34       49
spine01(swp51)        4      65100       405       432        0    0    0 00:15:03           34       49
spine02(swp52)        4      65100       413       431        0    0    0 00:15:03           34       49
spine03(swp53)        4      65100       405       432        0    0    0 00:15:03           34       49
spine04(swp54)        4      65100       407       431        0    0    0 00:15:03           34       49

Total number of neighbors 5
```

Verify EVPN VNI entries:
```bash
cumulus@leaf01:mgmt:~$ net show evpn vni
VNI        Type VxLAN IF              # MACs   # ARPs   # Remote VTEPs  Tenant VRF
10         L2   vxlan48               8        0        2               default
30         L2   vxlan48               8        0        2               default
20         L2   vxlan48               8        0        2               default
```
```bash
cumulus@leaf01:mgmt:~$ net show bgp evpn vni
Advertise Gateway Macip: Disabled
Advertise SVI Macip: Disabled
Advertise All VNI flag: Enabled
BUM flooding: Head-end replication
Number of L2 VNIs: 3
Number of L3 VNIs: 0
Flags: * - Kernel
  VNI        Type RD                    Import RT                 Export RT                 Tenant VRF
* 20         L2   10.10.10.1:2          65101:20                  65101:20                 default
* 30         L2   10.10.10.1:3          65101:30                  65101:30                 default
* 10         L2   10.10.10.1:4          65101:10                  65101:10                 default
```

Verify MAC entries are being learned on bridge `br_default`:
```bash
cumulus@leaf01:mgmt:~$ nv show bridge domain br_default mac-table
      age  bridge-domain  entry-type  interface   last-update  mac                src-vni  vlan  vni   Summary
----  ---  -------------  ----------  ----------  -----------  -----------------  -------  ----  ----  ---------------------
+ 0   993  br_default     permanent   peerlink    993          44:38:39:00:00:01
+ 1   283  br_default                 bond2       617          44:38:39:00:00:29           20
+ 10  856  br_default                 vxlan48     856          46:38:39:00:00:3b           20    None  remote-dst:  10.0.1.34
+ 11  856  br_default                 vxlan48     856          46:38:39:00:00:3f           30    None  remote-dst:  10.0.1.34
+ 12  858  br_default                 vxlan48     858          46:38:39:00:00:39           20    None  remote-dst:  10.0.1.34
+ 13  858  br_default                 vxlan48     858          46:38:39:00:00:3d           30    None  remote-dst:  10.0.1.34
+ 14  858  br_default                 vxlan48     858          46:38:39:00:00:35           10    None  remote-dst:  10.0.1.34
+ 15  879  br_default                 vxlan48     879          44:38:39:00:00:3f           30    None  remote-dst:  10.0.1.34
+ 16  879  br_default                 vxlan48     879          44:38:39:00:00:3b           20    None  remote-dst:  10.0.1.34
+ 17  880  br_default                 vxlan48     880          44:38:39:00:00:37           10    None  remote-dst:  10.0.1.34
+ 18  993  br_default     permanent   vxlan48     993          ea:6a:bf:4b:c0:73                 None
+ 19  986                 permanent   vxlan48     280          00:00:00:00:00:00  20             None  remote-dst: 10.0.1.255
  19                                                                                                   remote-dst:  10.0.1.34
+ 2   37   br_default                 bond2       857          46:38:39:00:00:2b           20
+ 20  283  br_default                 bond3       617          44:38:39:00:00:31           30
+ 21  37   br_default                 bond3       857          46:38:39:00:00:33           30
+ 22  21   br_default                 bond3       865          46:38:39:00:00:31           30
+ 23  37   br_default                 bond3       878          44:38:39:00:00:33           30
+ 24  993  br_default     permanent   bond3       993          44:38:39:00:00:32
+ 25  283  br_default                 bond1       617          44:38:39:00:00:2f           10
+ 26  37   br_default                 bond1       857          46:38:39:00:00:2d           10
+ 27  22   br_default                 bond1       865          46:38:39:00:00:2f           10
+ 28  37   br_default                 bond1       148          44:38:39:00:00:2d           10
+ 29  993  br_default     permanent   bond1       993          44:38:39:00:00:30
+ 3   29   br_default                 bond2       865          46:38:39:00:00:29           20
+ 30  993  br_default     permanent   br_default  993          44:38:39:00:00:7a
+ 4   37   br_default                 bond2       878          44:38:39:00:00:2b           20
+ 5   993  br_default     permanent   bond2       993          44:38:39:00:00:2a
+ 6   617  br_default                 vxlan48     617          44:38:39:00:00:35           10    None  remote-dst:  10.0.1.34
+ 7   617  br_default                 vxlan48     617          44:38:39:00:00:39           20    None  remote-dst:  10.0.1.34
+ 8   617  br_default                 vxlan48     617          44:38:39:00:00:3d           30    None  remote-dst:  10.0.1.34
+ 9   856  br_default                 vxlan48     856          46:38:39:00:00:37           10    None  remote-dst:  10.0.1.34
```

Verify neighbor (ARP) entries are being learned (you can also use `arp -n` command as well):
```bash
cumulus@leaf01:mgmt:~$ ip neigh show
169.254.0.1 dev swp52 lladdr 44:38:39:00:00:0c PERMANENT proto zebra
169.254.0.1 dev swp54 lladdr 44:38:39:00:00:10 PERMANENT proto zebra
169.254.0.1 dev peerlink.4094 lladdr 44:38:39:00:00:02 PERMANENT proto zebra
192.168.200.22 dev eth0 lladdr 44:38:39:00:00:65 STALE
192.168.200.1 dev eth0 lladdr 44:38:39:00:00:66 REACHABLE
169.254.0.1 dev swp51 lladdr 44:38:39:00:00:0a PERMANENT proto zebra
169.254.0.1 dev swp53 lladdr 44:38:39:00:00:0e PERMANENT proto zebra
192.168.200.250 dev eth0 lladdr 44:38:39:00:00:90 REACHABLE
...
```

Verify all underlay routes and VTEP IPs are learned over the default VRF:
```bash
cumulus@leaf01:mgmt:~$ net show route vrf default
show ip route vrf default
==========================
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
       F - PBR, f - OpenFabric, Z - FRR,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure
C>* 10.0.1.12/32 is directly connected, lo, 00:17:05
B>* 10.0.1.34/32 [20/0] via fe80::4638:39ff:fe00:a, swp51, weight 1, 00:16:58
  *                     via fe80::4638:39ff:fe00:c, swp52, weight 1, 00:16:58
  *                     via fe80::4638:39ff:fe00:e, swp53, weight 1, 00:16:58
  *                     via fe80::4638:39ff:fe00:10, swp54, weight 1, 00:16:58
B>* 10.0.1.255/32 [20/0] via fe80::4638:39ff:fe00:a, swp51, weight 1, 00:17:06
  *                      via fe80::4638:39ff:fe00:c, swp52, weight 1, 00:17:06
  *                      via fe80::4638:39ff:fe00:e, swp53, weight 1, 00:17:06
  *                      via fe80::4638:39ff:fe00:10, swp54, weight 1, 00:17:06
C>* 10.10.10.1/32 is directly connected, lo, 00:17:14
B>* 10.10.10.2/32 [20/0] via fe80::4638:39ff:fe00:2, peerlink.4094, weight 1, 00:17:05
B>* 10.10.10.3/32 [20/0] via fe80::4638:39ff:fe00:a, swp51, weight 1, 00:17:09
  *                      via fe80::4638:39ff:fe00:c, swp52, weight 1, 00:17:09
  *                      via fe80::4638:39ff:fe00:e, swp53, weight 1, 00:17:09
  *                      via fe80::4638:39ff:fe00:10, swp54, weight 1, 00:17:09
B>* 10.10.10.4/32 [20/0] via fe80::4638:39ff:fe00:a, swp51, weight 1, 00:17:09
  *                      via fe80::4638:39ff:fe00:c, swp52, weight 1, 00:17:09
  *                      via fe80::4638:39ff:fe00:e, swp53, weight 1, 00:17:09
  *                      via fe80::4638:39ff:fe00:10, swp54, weight 1, 00:17:09
B>* 10.10.10.63/32 [20/0] via fe80::4638:39ff:fe00:a, swp51, weight 1, 00:17:09
  *                       via fe80::4638:39ff:fe00:c, swp52, weight 1, 00:17:09
  *                       via fe80::4638:39ff:fe00:e, swp53, weight 1, 00:17:09
  *                       via fe80::4638:39ff:fe00:10, swp54, weight 1, 00:17:09
B>* 10.10.10.64/32 [20/0] via fe80::4638:39ff:fe00:a, swp51, weight 1, 00:05:19
  *                       via fe80::4638:39ff:fe00:c, swp52, weight 1, 00:05:19
  *                       via fe80::4638:39ff:fe00:e, swp53, weight 1, 00:05:19
  *                       via fe80::4638:39ff:fe00:10, swp54, weight 1, 00:05:19
B>* 10.10.10.101/32 [20/0] via fe80::4638:39ff:fe00:a, swp51, weight 1, 00:17:10
B>* 10.10.10.102/32 [20/0] via fe80::4638:39ff:fe00:c, swp52, weight 1, 00:17:10
B>* 10.10.10.103/32 [20/0] via fe80::4638:39ff:fe00:e, swp53, weight 1, 00:17:10
B>* 10.10.10.104/32 [20/0] via fe80::4638:39ff:fe00:10, swp54, weight 1, 00:17:09
...
```

Verify that MAC address of gateway is being populated into EVPN:
```bash
cumulus@leaf01:mgmt:~$ net show bgp l2vpn evpn route
BGP table version is 5, local router ID is 10.10.10.1
Status codes: s suppressed, d damped, h history, * valid, > best, i - internal
Origin codes: i - IGP, e - EGP, ? - incomplete
EVPN type-1 prefix: [1]:[ESI]:[EthTag]:[IPlen]:[VTEP-IP]:[Frag-id]
EVPN type-2 prefix: [2]:[EthTag]:[MAClen]:[MAC]:[IPlen]:[IP]
EVPN type-3 prefix: [3]:[EthTag]:[IPlen]:[OrigIP]
EVPN type-4 prefix: [4]:[ESI]:[IPlen]:[OrigIP]
EVPN type-5 prefix: [5]:[EthTag]:[IPlen]:[IP]

   Network          Next Hop            Metric LocPrf Weight Path
                    Extended Community
Route Distinguisher: 10.10.10.1:2
*> [2]:[0]:[48]:[44:38:39:00:00:29] RD 10.10.10.1:2
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20
*> [2]:[0]:[48]:[44:38:39:00:00:2b] RD 10.10.10.1:2
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20
*> [2]:[0]:[48]:[46:38:39:00:00:29] RD 10.10.10.1:2
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20
*> [2]:[0]:[48]:[46:38:39:00:00:2b] RD 10.10.10.1:2
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20
*> [3]:[0]:[32]:[10.0.1.12] RD 10.10.10.1:2
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20
Route Distinguisher: 10.10.10.1:3
*> [2]:[0]:[48]:[44:38:39:00:00:31] RD 10.10.10.1:3
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30
*> [2]:[0]:[48]:[44:38:39:00:00:33] RD 10.10.10.1:3
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30
*> [2]:[0]:[48]:[46:38:39:00:00:31] RD 10.10.10.1:3
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30
*> [2]:[0]:[48]:[46:38:39:00:00:33] RD 10.10.10.1:3
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30
*> [3]:[0]:[32]:[10.0.1.12] RD 10.10.10.1:3
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30
Route Distinguisher: 10.10.10.1:4
*> [2]:[0]:[48]:[44:38:39:00:00:2d] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10
*> [2]:[0]:[48]:[44:38:39:00:00:2f] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10
*> [2]:[0]:[48]:[46:38:39:00:00:2d] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10
*> [2]:[0]:[48]:[46:38:39:00:00:2f] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10
*> [3]:[0]:[32]:[10.0.1.12] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10
Route Distinguisher: 10.10.10.3:2
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.3:2
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.3:2
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.3:2
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.3:2
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.3:2
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:2
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:2
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:2
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:2
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:2
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:2
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:2
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:2
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:2
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:2
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.3:2
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:20 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.3:2
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.3:2
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.3:2
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.3:2
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:2
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:20 ET:8
*> [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:2
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:2
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:2
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:2
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
Route Distinguisher: 10.10.10.3:3
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.3:3
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.3:3
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.3:3
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.3:3
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.3:3
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:3
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:3
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:3
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:3
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:3
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:3
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:3
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:3
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:3
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:3
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.3:3
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:30 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.3:3
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.3:3
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.3:3
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.3:3
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:3
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:30 ET:8
*> [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:3
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:3
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:3
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:3
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
Route Distinguisher: 10.10.10.3:4
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:4
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:4
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:4
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:4
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:4
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:4
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:4
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:4
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:4
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:4
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:4
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:4
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.3:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:10 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.3:4
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.3:4
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.3:4
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.3:4
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:10 ET:8
*> [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:4
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:4
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:4
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:4
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
Route Distinguisher: 10.10.10.4:2
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.4:2
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.4:2
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.4:2
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.4:2
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.4:2
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:2
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:2
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:2
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:2
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:2
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:2
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:2
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:2
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:2
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:2
                    10.0.1.34 (spine01)
104:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:2
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:2
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:2
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:2
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*> [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:2
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
Route Distinguisher: 10.10.10.4:3
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.4:3
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.4:3
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.4:3
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.4:3
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.4:3
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:3
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:3
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:3
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:3
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:3
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:3
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:3
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:3
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:3
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:3
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:3
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:3
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:3
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:3
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*> [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:3
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
Route Distinguisher: 10.10.10.4:4
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:4
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:4
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:4
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:4
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:4
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:4
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:4
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:4
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:4
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:4
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:4
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:4
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:4
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:4
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:4
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:4
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:4
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:4
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:4
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*> [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:4
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
Route Distinguisher: 10.10.10.63:2
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:2
                    10.0.1.255 (leaf02)
                                                           0 65102 65100 65163 i
                    RT:65163:20 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:2
                    10.0.1.255 (spine04)
                                                           0 65100 65163 i
                    RT:65163:20 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:2
                    10.0.1.255 (spine02)
                                                           0 65100 65163 i
                    RT:65163:20 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:2
                    10.0.1.255 (spine03)
                                                           0 65100 65163 i
                    RT:65163:20 ET:8
*> [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:2
                    10.0.1.255 (spine01)
                                                           0 65100 65163 i
                    RT:65163:20 ET:8
Route Distinguisher: 10.10.10.63:3
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:3
                    10.0.1.255 (leaf02)
                                                           0 65102 65100 65163 i
                    RT:65163:30 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:3
                    10.0.1.255 (spine04)
                                                           0 65100 65163 i
                    RT:65163:30 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:3
                    10.0.1.255 (spine02)
                                                           0 65100 65163 i
                    RT:65163:30 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:3
                    10.0.1.255 (spine03)
                                                           0 65100 65163 i
                    RT:65163:30 ET:8
*> [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:3
                    10.0.1.255 (spine01)
                                                           0 65100 65163 i
                    RT:65163:30 ET:8
Route Distinguisher: 10.10.10.63:4
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:4
                    10.0.1.255 (leaf02)
                                                           0 65102 65100 65163 i
                    RT:65163:10 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:4
                    10.0.1.255 (spine04)
                                                           0 65100 65163 i
                    RT:65163:10 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:4
                    10.0.1.255 (spine02)
                                                           0 65100 65163 i
                    RT:65163:10 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:4
                    10.0.1.255 (spine03)
                                                           0 65100 65163 i
                    RT:65163:10 ET:8
*> [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.63:4
                    10.0.1.255 (spine01)
                                                           0 65100 65163 i
                    RT:65163:10 ET:8
Route Distinguisher: 10.10.10.64:2
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:2
                    10.0.1.255 (leaf02)
                                                           0 65102 65100 65164 i
                    RT:65164:20 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:2
                    10.0.1.255 (spine04)
                                                           0 65100 65164 i
                    RT:65164:20 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:2
                    10.0.1.255 (spine03)
                                                           0 65100 65164 i
                    RT:65164:20 ET:8
*> [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:2
                    10.0.1.255 (spine01)
                                                           0 65100 65164 i
                    RT:65164:20 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:2
                    10.0.1.255 (spine02)
                                                           0 65100 65164 i
                    RT:65164:20 ET:8
Route Distinguisher: 10.10.10.64:3
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:3
                    10.0.1.255 (leaf02)
                                                           0 65102 65100 65164 i
                    RT:65164:30 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:3
                    10.0.1.255 (spine04)
                                                           0 65100 65164 i
                    RT:65164:30 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:3
                    10.0.1.255 (spine03)
                                                           0 65100 65164 i
                    RT:65164:30 ET:8
*> [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:3
                    10.0.1.255 (spine01)
                                                           0 65100 65164 i
                    RT:65164:30 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:3
                    10.0.1.255 (spine02)
                                                           0 65100 65164 i
                    RT:65164:30 ET:8
Route Distinguisher: 10.10.10.64:4
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:4
                    10.0.1.255 (leaf02)
                                                           0 65102 65100 65164 i
                    RT:65164:10 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:4
                    10.0.1.255 (spine04)
                                                           0 65100 65164 i
                    RT:65164:10 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:4
                    10.0.1.255 (spine03)
                                                           0 65100 65164 i
                    RT:65164:10 ET:8
*> [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:4
                    10.0.1.255 (spine01)
                                                           0 65100 65164 i
                    RT:65164:10 ET:8
*  [3]:[0]:[32]:[10.0.1.255] RD 10.10.10.64:4
                    10.0.1.255 (spine02)
                                                           0 65100 65164 i
                    RT:65164:10 ET:8

Displayed 49 prefixes (185 paths)
```

### SNMP 

Run `snmpget` from the ansible server for the the switch `hostname` and `version` MIBs:
```bash
ubuntu@server:~$ snmpget -v2c -c public 192.168.200.6 iso.3.6.1.2.1.1.5.0
iso.3.6.1.2.1.1.5.0 = STRING: "leaf01"
ubuntu@server:~$ snmpget -v2c -c public 192.168.200.6 iso.3.6.1.2.1.1.1.0
iso.3.6.1.2.1.1.1.0 = STRING: "Cumulus-Linux 5.1.0 (Linux Kernel 4.19.237-1+cl5.1.0u1)"
```
You can examine all MIBs by running `snmpwalk` command:
```bash
ubuntu@server:~$ snmpwalk -v2c -c public 192.168.200.6 
iso.3.6.1.2.1.1.1.0 = STRING: "Cumulus-Linux 5.1.0 (Linux Kernel 4.19.237-1+cl5.1.0u1)"
iso.3.6.1.2.1.1.2.0 = OID: iso.3.6.1.4.1.40310
iso.3.6.1.2.1.1.3.0 = Timeticks: (524215) 1:27:22.15
iso.3.6.1.2.1.1.4.0 = STRING: "root"
iso.3.6.1.2.1.1.5.0 = STRING: "leaf01"
iso.3.6.1.2.1.1.6.0 = STRING: "Unknown"
iso.3.6.1.2.1.1.7.0 = INTEGER: 72
iso.3.6.1.2.1.1.8.0 = Timeticks: (0) 0:00:00.00
...
```
Check out all Cumulus supported [MIBs](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Monitoring-and-Troubleshooting/Simple-Network-Management-Protocol-SNMP/Supported-MIBs/).  

You can use MIB names instead of OIDs, which greatly improves the readability of the snmpd.conf file. You enable this by installing the `snmp-mibs-downloader`, which downloads SNMP MIBs to the switch before enabling traps. Check out the [MIB to OID Translation](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Monitoring-and-Troubleshooting/Simple-Network-Management-Protocol-SNMP/Configure-SNMP-Traps/#enable-mib-to-oid-translation) tool for more information.

### Syslog

Check that the switches send syslog messages to the syslog server (`ansible-server`):
```bash
ubuntu@server:~$ cat /var/log/syslog | grep 192.168.200.6
Jun  7 07:50:00 server dhcpd[1899]: DHCPOFFER on 192.168.200.6 to 44:38:39:00:00:70 via eth1
Jun  7 07:50:00 server dhcpd[1899]: DHCPREQUEST for 192.168.200.6 (192.168.200.1) from 44:38:39:00:00:70 via eth1
Jun  7 07:50:00 server dhcpd[1899]: DHCPACK on 192.168.200.6 to 44:38:39:00:00:70 via eth1
Jun  7 08:47:34 server tac_plus[31103]: connect from 192.168.200.6 [192.168.200.6]
Jun  7 08:47:34 server tac_plus[31106]: connect from 192.168.200.6 [192.168.200.6]
...
```
Cumulus Linux sends logs through `rsyslog`, which writes them to files in the local `/var/log` directory. There are default rules in the `/etc/rsyslog.d/` directory such as `10-rules.conf`, `20-clagd.conf`, `22-linkstate.conf` and more. Check out [Syslog documenation](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Monitoring-and-Troubleshooting/#send-log-files-to-a-syslog-server) for more infomration.
For Syslog server configuration, you can check out the [RSyslog official documentation](https://www.rsyslog.com/doc/master/).

## NetQ

[NetQ](https://docs.nvidia.com/networking-ethernet-software/cumulus-netq-42/Get-Started/) allows you to perform [monitor](https://docs.nvidia.com/networking-ethernet-software/cumulus-netq-42/Monitor-Operations/Monitor-Virtual-Network-Overlays/) and [validation](https://docs.nvidia.com/networking-ethernet-software/cumulus-netq-42/Validate-Operations/) operations on your environment. You can monitor the physical layer, devices inventory, underlay and overlay networks, validate services and protocols, and much more. 

In addition, you can leverage NetQ to [vefiry network connectivity](https://docs.nvidia.com/networking-ethernet-software/cumulus-netq-42/Verify-Network-Connectivity/) using the powerfull [NetQ Trace](https://docs.nvidia.com/networking-ethernet-software/cumulus-netq-42/Verify-Network-Connectivity/) feature. 

Both [NetQ CLI](https://docs.nvidia.com/networking-ethernet-software/cumulus-netq-42/Get-Started/NetQ-Command-Line-Overview/) and [NetQ UI](https://docs.nvidia.com/networking-ethernet-software/cumulus-netq-42/Get-Started/NetQ-User-Interface-Overview/Access-the-UI/) are avaliable in this Air demo environment. So you can access the UI from the Air sidebar or use the NetQ CLI commands directly from the switches/servers. 

Below are a few of NetQ CLI examples:
* Network services and protocols validation (e.g. EVPN, BGP, MLAG, NTP, etc.) 
* Network connectivity check using NetQ trace 
* Overlay network monitoring   

For more information, features and usage, check out the [NetQ documenations](https://docs.nvidia.com/networking-ethernet-software/cumulus-netq-42/).

Protocols and services validations:
```bash
ubuntu@server:mgmt:~$ netq check bgp
bgp check result summary:

Total nodes         : 10
Checked nodes       : 10
Failed nodes        : 0
Rotten nodes        : 0
Warning nodes       : 0
Skipped Nodes       : 0

Additional summary:
Total Sessions      : 54
Failed Sessions     : 0

Session Establishment Test   : passed
Address Families Test        : passed
Router ID Test               : passed
```
```bash
ubuntu@server:mgmt:~$ netq check mlag
clag check result summary:

Total nodes         : 6
Checked nodes       : 6
Failed nodes        : 0
Rotten nodes        : 0
Warning nodes       : 0
Skipped Nodes       : 0

Peering Test             : passed
Backup IP Test           : passed
Clag SysMac Test         : passed
VXLAN Anycast IP Test    : passed
Bridge Membership Test   : passed
Spanning Tree Test       : passed
Dual Home Test           : passed
Single Home Test         : passed
Conflicted Bonds Test    : passed
ProtoDown Bonds Test     : passed
SVI Test                 : passed
```
Check all available netq validations using the `netq check <tab>` command:
```bash
ubuntu@server:mgmt:~$ netq check 
    addresses   :  IPv4/v6 addresses
    agents      :  Netq agent
    bgp         :  BGP info
    cl-version  :  Cumulus Linux version
    clag        :  Cumulus Multi-chassis LAG
    evpn        :  EVPN
    interfaces  :  network interface port
    mlag        :  Multi-chassis LAG (alias of clag)
    mtu         :  Link MTU
    ntp         :  NTP
    ospf        :  OSPF info
    sensors     :  Temperature/Fan/PSU sensors
    vlan        :  VLAN
    vxlan       :  VxLAN
```
Network connectivity check (could take a few minutes):
```bash
ubuntu@server:mgmt:~$ netq trace 10.1.10.101 from 10.1.10.104 detail
Number of Paths: 8
Number of Paths with Errors: 0
Number of Paths with Warnings: 0
Path MTU: 9000

Id  Hop Hostname        InPort          InVlan InTunnel              InRtrIf         InVRF           OutRtrIf        OutVRF          OutTunnel             OutPort         OutVlan
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
1   1   server04                                                                                     uplink          default                               eth2
    2   leaf04          swp1            10                                                                                           vni: 10               swp54
    3   spine04         swp4                                         swp4            default         swp1            default                               swp1
    4   leaf01          swp54                  vni: 10                                                                                                     swp1            10
    5   server01        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
2   1   server04                                                                                     uplink          default                               eth2
    2   leaf04          swp1            10                                                                                           vni: 10               swp53
    3   spine03         swp4                                         swp4            default         swp1            default                               swp1
    4   leaf01          swp53                  vni: 10                                                                                                     swp1            10
    5   server01        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
3   1   server04                                                                                     uplink          default                               eth2
    2   leaf04          swp1            10                                                                                           vni: 10               swp52
    3   spine02         swp4                                         swp4            default         swp1            default                               swp1
    4   leaf01          swp52                  vni: 10                                                                                                     swp1            10
    5   server01        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
4   1   server04                                                                                     uplink          default                               eth2
    2   leaf04          swp1            10                                                                                           vni: 10               swp51
    3   spine01         swp4                                         swp4            default         swp1            default                               swp1
    4   leaf01          swp51                  vni: 10                                                                                                     swp1            10
    5   server01        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
5   1   server04                                                                                     uplink          default                               eth1
    2   leaf03          swp1            10                                                                                           vni: 10               swp54
    3   spine04         swp3                                         swp3            default         swp1            default                               swp1
    4   leaf01          swp54                  vni: 10                                                                                                     swp1            10
    5   server01        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
6   1   server04                                                                                     uplink          default                               eth1
    2   leaf03          swp1            10                                                                                           vni: 10               swp53
    3   spine03         swp3                                         swp3            default         swp1            default                               swp1
    4   leaf01          swp53                  vni: 10                                                                                                     swp1            10
    5   server01        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
7   1   server04                                                                                     uplink          default                               eth1
    2   leaf03          swp1            10                                                                                           vni: 10               swp52
    3   spine02         swp3                                         swp3            default         swp1            default                               swp1
    4   leaf01          swp52                  vni: 10                                                                                                     swp1            10
    5   server01        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
8   1   server04                                                                                     uplink          default                               eth1
    2   leaf03          swp1            10                                                                                           vni: 10               swp51
    3   spine01         swp3                                         swp3            default         swp1            default                               swp1
    4   leaf01          swp51                  vni: 10                                                                                                     swp1            10
    5   server01        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
```
**Note:** Some checks (e.g. Link MTU Consistency, Autoneg) could fail between devices like the border leaves and the unconfigured servers/fws. 
```bash
ubuntu@server:mgmt:~$ netq check mtu
mtu check result summary:

Total nodes         : 21
Checked nodes       : 21
Failed nodes        : 6
Rotten nodes        : 0
Warning nodes       : 0
Skipped nodes       : 0

Additional summary:
Checked Links       : 207
Failed Links        : 16
Warn Links          : 0


Link MTU Consistency Test   : 0 warnings, 16 errors
VLAN interface Test         : passed
Bridge interface Test       : passed


Link MTU Consistency Test details:
Hostname          Interface                 MTU    Peer              Peer Interface            Peer MTU Reason
----------------- ------------------------- ------ ----------------- ------------------------- -------- ---------------------------------------------
border01          swp1                      9216   server07          eth1                      1500     MTU Mismatch
border01          swp2                      9216   server08          eth1                      1500     MTU Mismatch
border01          swp3                      9216   fw1               eth1                      1500     MTU Mismatch
border01          swp4                      9216   fw2               eth1                      1500     MTU Mismatch
border02          swp1                      9216   server07          eth2                      1500     MTU Mismatch
border02          swp2                      9216   server08          eth2                      1500     MTU Mismatch
border02          swp3                      9216   fw1               eth2                      1500     MTU Mismatch
border02          swp4                      9216   fw2               eth2                      1500     MTU Mismatch
fw1               eth1                      1500   border01          swp3                      9216     MTU Mismatch
fw1               eth2                      1500   border02          swp3                      9216     MTU Mismatch
fw2               eth1                      1500   border01          swp4                      9216     MTU Mismatch
fw2               eth2                      1500   border02          swp4                      9216     MTU Mismatch
server07          eth1                      1500   border01          swp1                      9216     MTU Mismatch
server07          eth2                      1500   border02          swp1                      9216     MTU Mismatch
server08          eth1                      1500   border01          swp2                      9216     MTU Mismatch
server08          eth2                      1500   border02          swp2                      9216     MTU Mismatch
```

Overlay network monitoring:
```bash
ubuntu@server:mgmt:~$ netq show vxlan

Matching vxlan records:
Hostname          VNI        Protocol     VTEP IP          VLAN   Replication List                    Last Changed
----------------- ---------- ------------ ---------------- ------ ----------------------------------- -------------------------
border01          20         EVPN         10.0.1.255       20     10.0.1.12(leaf01, leaf02),          Mon Jul 11 12:25:21 2022
                                                                  10.0.1.34(leaf03, leaf04)
border01          10         EVPN         10.0.1.255       10     10.0.1.12(leaf01, leaf02),          Mon Jul 11 12:25:21 2022
                                                                  10.0.1.34(leaf03, leaf04)
border01          30         EVPN         10.0.1.255       30     10.0.1.12(leaf01, leaf02),          Mon Jul 11 12:25:21 2022
                                                                  10.0.1.34(leaf03, leaf04)
border02          20         EVPN         10.0.1.255       20     10.0.1.12(leaf01, leaf02),          Mon Jul 11 12:31:07 2022
                                                                  10.0.1.34(leaf03, leaf04)
border02          10         EVPN         10.0.1.255       10     10.0.1.12(leaf01, leaf02),          Mon Jul 11 12:31:07 2022
                                                                  10.0.1.34(leaf03, leaf04)
border02          30         EVPN         10.0.1.255       30     10.0.1.12(leaf01, leaf02),          Mon Jul 11 12:31:07 2022
                                                                  10.0.1.34(leaf03, leaf04)
leaf01            20         EVPN         10.0.1.12        20     10.0.1.255(border02, border01),     Mon Jul 11 12:12:21 2022
                                                                  10.0.1.34(leaf03, leaf04)
leaf01            10         EVPN         10.0.1.12        10     10.0.1.255(border02, border01),     Mon Jul 11 12:12:21 2022
                                                                  10.0.1.34(leaf03, leaf04)
leaf01            30         EVPN         10.0.1.12        30     10.0.1.255(border02, border01),     Mon Jul 11 12:12:21 2022
                                                                  10.0.1.34(leaf03, leaf04)
leaf02            20         EVPN         10.0.1.12        20     10.0.1.255(border02, border01),     Mon Jul 11 12:12:21 2022
                                                                  10.0.1.34(leaf03, leaf04)
leaf02            10         EVPN         10.0.1.12        10     10.0.1.255(border02, border01),     Mon Jul 11 12:12:21 2022
                                                                  10.0.1.34(leaf03, leaf04)
leaf02            30         EVPN         10.0.1.12        30     10.0.1.255(border02, border01),     Mon Jul 11 12:12:21 2022
                                                                  10.0.1.34(leaf03, leaf04)
leaf03            20         EVPN         10.0.1.34        20     10.0.1.255(border02, border01),     Mon Jul 11 12:12:21 2022
                                                                  10.0.1.12(leaf01, leaf02)
leaf03            10         EVPN         10.0.1.34        10     10.0.1.255(border02, border01),     Mon Jul 11 12:12:21 2022
                                                                  10.0.1.12(leaf01, leaf02)
leaf03            30         EVPN         10.0.1.34        30     10.0.1.255(border02, border01),     Mon Jul 11 12:12:21 2022
                                                                  10.0.1.12(leaf01, leaf02)
leaf04            20         EVPN         10.0.1.34        20     10.0.1.255(border02, border01),     Mon Jul 11 12:12:21 2022
                                                                  10.0.1.12(leaf01, leaf02)
leaf04            10         EVPN         10.0.1.34        10     10.0.1.255(border02, border01),     Mon Jul 11 12:12:21 2022
                                                                  10.0.1.12(leaf01, leaf02)
leaf04            30         EVPN         10.0.1.34        30     10.0.1.255(border02, border01),     Mon Jul 11 12:12:21 2022
                                                                  10.0.1.12(leaf01, leaf02)
```