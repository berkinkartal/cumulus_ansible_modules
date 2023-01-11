<!-- AIR:tour -->

# Distributed EVPN Symmetric Routing

This environment demonstrates a best-practice configuration for deploying distributed inter-VLAN routing using [EVPN symmetric](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/Inter-subnet-Routing/#symmetric-routing) model. In this demo, we use the [NVUE Object Model](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/NVIDIA-User-Experience-NVUE/NVUE-Object-Model/) and [NVUE CLI](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/NVIDIA-User-Experience-NVUE/NVUE-CLI/) to set the [VXLAN Active-Active Mode](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/VXLAN-Active-Active-Mode/) configuration to present EVPN fabric with MLAG L2 redundancy on the ToR switches.

When using the symmetric model, each VTEP bridges and routes the traffic (ingress and egress). The layer 2 traffic is being bridged (VLAN-L2VNI) on the leaf ingress host port, then routed to special transit VNI which is used for all routed VXLAN traffic, called the L3VNI. All VXLAN traffic must be routed onto this L3VNI, tunneled across the layer 3 infrastructure, and routed off the L3VNI to the appropriate VLAN at the destination VTEP and ultimately bridged to the destination host.

In this model, the leaf switches only need to host the VLANs (mapped to VNIs) located on its rack and the L3VNI and its associated VLAN. This is because the ingress leaf switch doesn’t need to know the destination VNI. 

Multitenancy requires one L3VNI per VRF, and all switches participating in that VRF must be configured with the same L3VNI. The egress leaf uses the L3VNI to identify the VRF in which to route the packet.

Check out [Cumulus Linux documentation](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/Inter-subnet-Routing/) for more information and examples.

Check out this [blog](https://developer.nvidia.com/blog/looking-behind-the-curtain-of-evpn-traffic-flows/) to deeper understand the EVPN traffic flows in a virtualized environment.

## Features and Services

This demo includes the following features and services:

 * [MLAG](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-2/Multi-Chassis-Link-Aggregation-MLAG/) L2 server redundancy 
 * [SVI](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-2/Ethernet-Bridging-VLANs/VLAN-aware-Bridge-Mode/#vlan-layer-3-addressing) gateway and [VRR](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-2/Virtual-Router-Redundancy-VRR-and-VRRP/) for L3 server redundacy
 * [BGP](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-3/Border-Gateway-Protocol-BGP/) underlay fabric using [BGP unnumbered](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-50/Layer-3/Border-Gateway-Protocol-BGP/#bgp-unnumbered) interfaces
 * Management, default and custom [VRFs](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-3/VRFs/Virtual-Routing-and-Forwarding-VRF/) for mgmt., underlay and overlay traffic 
 * [VXLAN](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/) overlay encapsulation data plane
 * [EVPN](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/) overlay control plane
 * [Distributed inter-subnet routing using EVPN Symmetric control plane](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/Inter-subnet-Routing/#symmetric-routing)
 * [SNMP](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Monitoring-and-Troubleshooting/Simple-Network-Management-Protocol-SNMP/Configure-SNMP/)
 * [NTP](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/Date-and-Time/Network-Time-Protocol-NTP/) service
 * [DNS](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-3/VRFs/Management-VRF/#management-vrf-and-dns) service
 * [Syslog](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Monitoring-and-Troubleshooting/#send-log-files-to-a-syslog-server) service
 * [TACACS+ Client](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/Authentication-Authorization-and-Accounting/TACACS/)
 * [NVUE Snippets](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/NVIDIA-User-Experience-NVUE/NVUE-Snippets/)

<!-- AIR:page -->

## Demo Topology Information 

### Devices

The topology consist of 10 switches running Cumulus Linux 5.1, 8 Ubuntu servers and 2 firewalls (Ubuntu).

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

**Note:** `server07`, `server08`, `fw1` and `fw2` are connected to the border leaves but have no configuration. They exist in the topology for your convenience in case you want to try other technologies and configurations related to this type of EVPN environment. E.g. custom fw apps to route between VRFs or services running on the servers.

<!-- AIR:page -->

### IPAM

#### Hosts

| __Hostname__| __Interface__ | __VRF__ | __VLAN__ | __IP Address__    |
| ---------   | ------------- | ------- | -------- | ----------------- |
| server01    | eth0          | mgmt.   |          | 192.168.200.10/24 |
|             | uplink        | RED     | 10       | 10.1.10.101/24    |
| server02    | eth0          | mgmt.   |          | 192.168.200.11/24 |
|             | uplink        | RED     | 20       | 10.1.20.102/24    |
| server03    | eth0          | mgmt.   |          | 192.168.200.12/24 |
|             | uplink        | BLUE    | 30       | 10.1.30.103/24    |
| server04    | eth0          | mgmt.   |          | 192.168.200.13/24 |
|             | uplink        | RED     | 10       | 10.1.10.104/24    |
| server05    | eth0          | mgmt.   |          | 192.168.200.14/24 |
|             | uplink        | RED     | 20       | 10.1.20.105/24    |
| server06    | eth0          | mgmt.   |          | 192.168.200.15/24 |
|             | uplink        | BLUE    | 30       | 10.1.30.106/24    |
| server07    | eth0          | mgmt.   |          | 192.168.200.18/24 |
| server08    | eth0          | mgmt.   |          | 192.168.200.19/24 |
| fw1         | eth0          | mgmt.   |          | 192.168.200.20/24 |
| fw2         | eth0          | mgmt.   |          | 192.168.200.21/24 |

#### Switches

| __Hostname__| __Interface__ | __VRF__ | __VLAN__ | __IP Address__    |
| ---------   | ------------- | ------- | -------- | ----------------- |
| leaf01      | eth0          | mgmt.   |          | 192.168.200.6/24  |
|             | bond1         | RED     | 10       |                   |
|             | bond2         | RED     | 20       |                   |
|             | bond3         | BLUE    | 30       |                   |
|             | vlan10        | RED     | 10       | 10.1.10.2/24      |
|             | vlan10-v0     | RED     | 10       | 10.1.10.1/24      |
|             | vlan20        | RED     | 20       | 10.1.20.2/24      |
|             | vlan20-v0     | RED     | 20       | 10.1.20.1/24      |
|             | vlan30        | BLUE    | 30       | 10.1.30.2/24      |
|             | vlan30-v0     | BLUE    | 30       | 10.1.30.1/24      |
|             | lo            | default |          | 10.10.10.1/32     |
|             | vxlan-anycast |         |          | 10.0.1.12/32      |
| leaf02      | eth0          | mgmt.   |          | 192.168.200.7/24  |
|             | bond1         | RED     | 10       |                   |
|             | bond2         | RED     | 20       |                   |
|             | bond3         | BLUE    | 30       |                   |
|             | vlan10        | RED     | 10       | 10.1.10.3/24      |
|             | vlan10-v0     | RED     | 10       | 10.1.10.1/24      |
|             | vlan20        | RED     | 20       | 10.1.20.3/24      |
|             | vlan20-v0     | RED     | 20       | 10.1.20.1/24      |
|             | vlan30        | BLUE    | 30       | 10.1.30.3/24      |
|             | vlan30-v0     | BLUE    | 30       | 10.1.30.1/24      |
|             | lo            | default |          | 10.10.10.2/32     |
|             | vxlan-anycast |         |          | 10.0.1.12/32      |
| leaf03      | eth0          | mgmt.   |          | 192.168.200.8/24  |
|             | bond1         | RED     | 10       |                   |
|             | bond2         | RED     | 20       |                   |
|             | bond3         | BLUE    | 30       |                   |
|             | vlan10        | RED     | 10       | 10.1.10.4/24      |
|             | vlan10-v0     | RED     | 10       | 10.1.10.1/24      |
|             | vlan20        | RED     | 20       | 10.1.20.4/24      |
|             | vlan20-v0     | RED     | 20       | 10.1.20.1/24      |
|             | vlan30        | BLUE    | 30       | 10.1.30.4/24      |
|             | vlan30-v0     | BLUE    | 30       | 10.1.30.1/24      |
|             | lo            | default |          | 10.10.10.3/32     |
|             | vxlan-anycast |         |          | 10.0.1.34/32      |
| leaf04      | eth0          | mgmt.   |          | 192.168.200.9/24  |
|             | bond1         | RED     | 10       |                   |
|             | bond2         | RED     | 20       |                   |
|             | bond3         | BLUE    | 30       |                   |
|             | vlan10        | RED     | 10       | 10.1.10.5/24      |
|             | vlan10-v0     | RED     | 10       | 10.1.10.1/24      |
|             | vlan20        | RED     | 20       | 10.1.20.5/24      |
|             | vlan20-v0     | RED     | 20       | 10.1.20.1/24      |
|             | vlan30        | BLUE    | 30       | 10.1.30.5/24      |
|             | vlan30-v0     | BLUE    | 30       | 10.1.30.1/24      |
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



<!-- AIR:page -->

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

<!-- AIR:page -->

## Demo Environment Access

All environment devices access are done via the jump server - `oob-mgmt-server`.

Use the default access credentials to login the `oob-mgmt-server`:
 - Username: ***ubuntu***
 - Password: ***nvidia***

***Note:*** *Once you first login, you must change the default password.*

You can use the web intergrated console or create an SSH service to access the `oob-mgmt-server` using any SSH client.  
For more information and step-by-step instructions, check out NVIDIA Air [Quick Start](https://docs.nvidia.com/networking-ethernet-software/guides/nvidia-air/Quick-Start/) guide.

Once you login the `oob-mgmt-server`, you can access any device in the topology using its hostname.

Login to the servers and firewalls using just the hostname - `ssh <hostname>` (all have the same username - `ubuntu`, which is identical to the `oob-mgmt-server` username).

Default servers credentials are:  
 - Username: ***ubuntu***
 - Password: ***nvidia*** 

```bash
ubuntu@oob-mgmt-server:~$ ssh server01
```
Login to the switches using `cumulus` username - `ssh cumulus@<hostname>`. To ease the access, `cumulus` username was set to passwordless authentication from `oob-mgmt-server`. 

```bash
ubuntu@oob-mgmt-server:~$ ssh cumulus@leaf01
```
When logging in from other environment devices, use `ssh cumulus@<ip-address>`.

Default switch credentials are:  
 - Username: ***cumulus***
 - Password: ***CumulusLinux!*** 

<!-- AIR:page -->

## Connectivity and Configuration Validation 

### Server to Server Connectivity

As `server01`, `server02`, `server04`, `server05` are in VRF `RED` and `server03`, `server06` are in VRF `BLUE`, they cannot communicate unless some kind of VRF leaking technology used (you can use the fw for that). Thus, servers connectivity works only within the same VRF.

Log into `server01`:
```bash
ubuntu@oob-mgmt-server:~$ ssh server01
ubuntu@server01's password:
Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 4.15.0-166-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun May 22 13:14:05 UTC 2022

  System load:  0.04              Processes:             93
  Usage of /:   24.4% of 9.29GB   Users logged in:       0
  Memory usage: 44%               IP address for eth0:   192.168.200.10
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

Check `server04` reachability to validate L2 intra-VLAN connectivity in VRF `RED`:
```bash
ubuntu@server01:~$ ping 10.1.10.104 -c 3
PING 10.1.10.104 (10.1.10.104) 56(84) bytes of data.
64 bytes from 10.1.10.104: icmp_seq=1 ttl=64 time=1.69 ms
64 bytes from 10.1.10.104: icmp_seq=2 ttl=64 time=1.47 ms
64 bytes from 10.1.10.104: icmp_seq=3 ttl=64 time=1.74 ms

--- 10.1.10.104 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 1.470/1.635/1.742/0.123 ms
```

Check `server02` and `server05` reachability to validate L3 inter-VLAN connectivity in VRF `RED`:
```bash
ubuntu@server01:~$ for srv in {20.102,20.105} ; do ping 10.1.${srv} -c 3; done
PING 10.1.20.102 (10.1.20.102) 56(84) bytes of data.
64 bytes from 10.1.20.102: icmp_seq=1 ttl=63 time=0.732 ms
64 bytes from 10.1.20.102: icmp_seq=2 ttl=63 time=0.696 ms
64 bytes from 10.1.20.102: icmp_seq=3 ttl=63 time=0.741 ms

--- 10.1.20.102 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2025ms
rtt min/avg/max/mdev = 0.696/0.723/0.741/0.019 ms
PING 10.1.20.105 (10.1.20.105) 56(84) bytes of data.
64 bytes from 10.1.20.105: icmp_seq=1 ttl=62 time=1.45 ms
64 bytes from 10.1.20.105: icmp_seq=2 ttl=62 time=1.49 ms
64 bytes from 10.1.20.105: icmp_seq=3 ttl=62 time=1.37 ms

--- 10.1.20.105 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 1.374/1.441/1.495/0.050 ms
```

Check `server03` and `server06` reachability to ensure that L3 inter-VLAN connectivity is not allowed between VRFs:
```bash
ubuntu@server01:~$ for srv in {30.103,30.106} ; do ping 10.1.${srv} -c 3; done
PING 10.1.30.103 (10.1.30.103) 56(84) bytes of data.
From 10.1.10.2 icmp_seq=1 Destination Host Unreachable
From 10.1.10.2 icmp_seq=2 Destination Host Unreachable
From 10.1.10.2 icmp_seq=3 Destination Host Unreachable

--- 10.1.30.103 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2047ms

PING 10.1.30.106 (10.1.30.106) 56(84) bytes of data.
From 10.1.10.2 icmp_seq=1 Destination Host Unreachable
From 10.1.10.2 icmp_seq=2 Destination Host Unreachable
From 10.1.10.2 icmp_seq=3 Destination Host Unreachable

--- 10.1.30.106 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2046ms
```

Login to `server03` and ping `server06` to validate L2 intra-VLAN connectivity in VRF `BLUE`:
```bash
ubuntu@oob-mgmt-server:~$ ssh server03
ubuntu@server03's password:
Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 4.15.0-166-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Sun May 22 13:37:11 UTC 2022

  System load:  0.08              Processes:             94
  Usage of /:   24.4% of 9.29GB   Users logged in:       0
  Memory usage: 44%               IP address for eth0:   192.168.200.12
  Swap usage:   0%                IP address for uplink: 10.1.30.103

17 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

New release '20.04.4 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

*** System restart required ***
#########################################################
#      You are successfully logged in to: server03      #
#########################################################
Last login: Sun May 22 13:37:08 2022 from 192.168.200.1
```
```bash
ubuntu@server03:~$ ping 10.1.30.106 -c 3
PING 10.1.30.106 (10.1.30.106) 56(84) bytes of data.
64 bytes from 10.1.30.106: icmp_seq=1 ttl=64 time=1.56 ms
64 bytes from 10.1.30.106: icmp_seq=2 ttl=64 time=1.52 ms
64 bytes from 10.1.30.106: icmp_seq=3 ttl=64 time=1.26 ms

--- 10.1.30.106 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 1.269/1.454/1.568/0.135 ms
```
<!-- AIR:page -->

### Switches Configuration 

Althought Cumulus Linux 5.1 uses NVUE `configuration` commands, it still has limited `show` commands. Thus, as for now, to verify switch configuration, present states and get information, you can use the old NCLU `show` commands. In future Cumulus releases, NCLU `show` commands will no longer be avaliable and will be replaced with the new NVUE commands.

In the verification steps below, we use the combination of NVUE, Linux and NCLU commands. We present all outputs on `leaf01` as referance.  

Login to `leaf01`:
```bash
ubuntu@oob-mgmt-server:~$ ssh cumulus@leaf01
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
      vrr:
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
      global:
        anycast-mac: 44:38:39:BE:EF:12
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
      BLUE:
        evpn:
          enable: on
          vni:
            '4002': {}
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
            router-id: 10.10.10.1
      RED:
        evpn:
          enable: on
          vni:
            '4001': {}
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
            router-id: 10.10.10.1
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
      vlan10:
        ip:
          address:
            10.1.10.2/24: {}
          vrr:
            address:
              10.1.10.1/24: {}
            mac-address: 00:00:00:00:00:10
        vlan: 10
      vlan10,20:
        ip:
          vrf: RED
      vlan10,20,30:
        ip:
          vrr:
            enable: on
            state:
              up: {}
        type: svi
      vlan20:
        ip:
          address:
            10.1.20.2/24: {}
          vrr:
            address:
              10.1.20.1/24: {}
            mac-address: 00:00:00:00:00:20
        vlan: 20
      vlan30:
        ip:
          address:
            10.1.30.2/24: {}
          vrf: BLUE
          vrr:
            address:
              10.1.30.1/24: {}
            mac-address: 00:00:00:00:00:30
        vlan: 30
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
nv set router vrr enable on
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
nv set system global anycast-mac 44:38:39:BE:EF:12
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
nv set vrf BLUE evpn enable on
nv set vrf BLUE evpn vni 4002
nv set vrf BLUE router bgp address-family ipv4-unicast enable on
nv set vrf BLUE router bgp address-family ipv4-unicast redistribute connected enable on
nv set vrf BLUE router bgp address-family l2vpn-evpn enable on
nv set vrf BLUE router bgp autonomous-system 65101
nv set vrf BLUE router bgp enable on
nv set vrf BLUE router bgp router-id 10.10.10.1
nv set vrf RED evpn enable on
nv set vrf RED evpn vni 4001
nv set vrf RED router bgp address-family ipv4-unicast enable on
nv set vrf RED router bgp address-family ipv4-unicast redistribute connected enable on
nv set vrf RED router bgp address-family l2vpn-evpn enable on
nv set vrf RED router bgp autonomous-system 65101
nv set vrf RED router bgp enable on
nv set vrf RED router bgp router-id 10.10.10.1
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
nv set interface vlan10 ip address 10.1.10.2/24
nv set interface vlan10 ip vrr address 10.1.10.1/24
nv set interface vlan10 ip vrr mac-address 00:00:00:00:00:10
nv set interface vlan10 vlan 10
nv set interface vlan10,20 ip vrf RED
nv set interface vlan10,20,30 ip vrr enable on
nv set interface vlan10,20,30 ip vrr state up
nv set interface vlan10,20,30 type svi
nv set interface vlan20 ip address 10.1.20.2/24
nv set interface vlan20 ip vrr address 10.1.20.1/24
nv set interface vlan20 ip vrr mac-address 00:00:00:00:00:20
nv set interface vlan20 vlan 20
nv set interface vlan30 ip address 10.1.30.2/24
nv set interface vlan30 ip vrf BLUE
nv set interface vlan30 ip vrr address 10.1.30.1/24
nv set interface vlan30 ip vrr mac-address 00:00:00:00:00:30
nv set interface vlan30 vlan 30
```

To view the startup-configuration, you can print the `startup.yaml` file by `cat /etc/nvue.d/startup.yaml`.

**Note:** NVUE is a declerative CLI which allows you to handle switch configuration as a regular Git repository. It uses Git based configuration engine to enable commit, revert, branch, stash and diff behaviors. Check out the [Configuration Management Commands](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/NVIDIA-User-Experience-NVUE/NVUE-CLI/#configuration-management-commands) for more information.

<!-- AIR:page -->

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
[vlan]           4024
[vlan]           4036
[mdb]                                     Set of mdb entries in the bridge domain
[router-port]    1                        Set of multicast router ports
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
peer-priority   32768                                      Mlag Peer Priority
peer-role       secondary                                  Mlag Peer Role
```

Verify MLAG interfaces state:
```bash
cumulus@leaf01:mgmt:~$ net show clag
The peer is alive
     Our Priority, ID, and Role: 1000 44:38:39:00:00:01 primary
    Peer Priority, ID, and Role: 32768 44:38:39:00:00:02 secondary
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
Interface  Conflict  LocalValue              Parameter         PeerValue
---------  --------  ----------------------  ----------------  ----------------------
+ bond1    -         yes                     bridge-learning   yes
  bond1    -         1                       clag-id           1
  bond1    -         44:38:39:be:ef:aa       lacp-actor-mac    44:38:39:be:ef:aa
  bond1    -         44:38:39:00:00:2d       lacp-partner-mac  44:38:39:00:00:2d
  bond1    -         br_default              master            NOT-SYNCED
  bond1    -         9000                    mtu               9000
  bond1    -         10                      native-vlan       10
  bond1    -         10                      vlan-id           10
+ bond2    -         yes                     bridge-learning   yes
  bond2    -         2                       clag-id           2
  bond2    -         44:38:39:be:ef:aa       lacp-actor-mac    44:38:39:be:ef:aa
  bond2    -         44:38:39:00:00:2b       lacp-partner-mac  44:38:39:00:00:2b
  bond2    -         br_default              master            NOT-SYNCED
  bond2    -         9000                    mtu               9000
  bond2    -         20                      native-vlan       20
  bond2    -         20                      vlan-id           20
+ bond3    -         yes                     bridge-learning   yes
  bond3    -         3                       clag-id           3
  bond3    -         44:38:39:be:ef:aa       lacp-actor-mac    44:38:39:be:ef:aa
  bond3    -         44:38:39:00:00:33       lacp-partner-mac  44:38:39:00:00:33
  bond3    -         br_default              master            NOT-SYNCED
  bond3    -         9000                    mtu               9000
  bond3    -         30                      native-vlan       30
  bond3    -         30                      vlan-id           30
+ vxlan48  -         br_default              master            NOT-SYNCED
  vxlan48  -         10, 20, 30, 4024, 4036  vlan              10, 20, 30, 4024, 4036
  vxlan48  -         10, 20, 30, 4001->4002  vni               10, 20, 30, 4001->4002
  vxlan48  -         vxlan48                 vxlan-intf        vxlan48
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
BGP table version 21
RIB entries 25, using 5000 bytes of memory
Peers 5, using 114 KiB of memory
Peer groups 1, using 64 bytes of memory

Neighbor              V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt
leaf02(peerlink.4094) 4      65102       779       766        0    0    0 00:29:18           12       13
spine01(swp51)        4      65100       784       772        0    0    0 00:29:20            8       13
spine02(swp52)        4      65100       784       772        0    0    0 00:29:20            8       13
spine03(swp53)        4      65100       785       772        0    0    0 00:29:19            8       13
spine04(swp54)        4      65100       785       772        0    0    0 00:29:20            8       13

Total number of neighbors 5


show bgp ipv6 unicast summary
=============================
% No BGP neighbors found


show bgp l2vpn evpn summary
===========================
BGP router identifier 10.10.10.1, local AS number 65101 vrf-id 0
BGP table version 0
RIB entries 23, using 4600 bytes of memory
Peers 5, using 114 KiB of memory
Peer groups 1, using 64 bytes of memory

Neighbor              V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt
leaf02(peerlink.4094) 4      65102       779       766        0    0    0 00:29:18           44       68
spine01(swp51)        4      65100       784       772        0    0    0 00:29:20           44       68
spine02(swp52)        4      65100       785       772        0    0    0 00:29:20           44       68
spine03(swp53)        4      65100       785       772        0    0    0 00:29:19           44       68
spine04(swp54)        4      65100       785       772        0    0    0 00:29:20           44       68

Total number of neighbors 5
```
Verify EVPN VNI entries:
```bash
cumulus@leaf01:mgmt:~$ net show evpn vni
VNI        Type VxLAN IF              # MACs   # ARPs   # Remote VTEPs  Tenant VRF
10         L2   vxlan48               11       4        1               RED
30         L2   vxlan48               10       4        1               BLUE
20         L2   vxlan48               10       4        1               RED
4001       L3   vxlan48               1        1        n/a             RED
4002       L3   vxlan48               1        1        n/a             BLUE
```
```bash
cumulus@leaf01:mgmt:~$ net show bgp evpn vni
Advertise Gateway Macip: Disabled
Advertise SVI Macip: Disabled
Advertise All VNI flag: Enabled
BUM flooding: Head-end replication
Number of L2 VNIs: 3
Number of L3 VNIs: 2
Flags: * - Kernel
  VNI        Type RD                    Import RT                 Export RT                 Tenant VRF
* 20         L2   10.10.10.1:4          65101:20                  65101:20                 RED
* 30         L2   10.10.10.1:5          65101:30                  65101:30                 BLUE
* 10         L2   10.10.10.1:6          65101:10                  65101:10                 RED
* 4001       L3   10.10.10.1:2          65101:4001                65101:4001               RED
* 4002       L3   10.10.10.1:3          65101:4002                65101:4002               BLUE
```

Verify MAC entries are being learned on bridge `br_default`:
```bash
cumulus@leaf01:mgmt:~$ nv show bridge domain br_default mac-table
      age   bridge-domain  entry-type  interface   last-update  mac                src-vni  vlan  vni   Summary
----  ----  -------------  ----------  ----------  -----------  -----------------  -------  ----  ----  ---------------------
+ 0   1506  br_default                 bond2       1506         44:38:39:00:00:29           20
+ 1   135   br_default                 bond2       1771         46:38:39:00:00:2b           20
+ 10  65    br_default                 bond3       405          44:38:39:00:00:33           30
+ 11  1909  br_default     permanent   bond3       1909         44:38:39:00:00:32
+ 12  410   br_default                 vxlan48     410          44:38:39:be:ef:34           4036  None  remote-dst: 10.0.1.34
+ 13  1490  br_default                 vxlan48     1490         44:38:39:00:00:7e           30    None  remote-dst: 10.0.1.34
+ 14  1486  br_default                 vxlan48     1486         44:38:39:00:00:80           30    None  remote-dst: 10.0.1.34
+ 15  1502  br_default                 vxlan48     1502         44:38:39:00:00:35           10    None  remote-dst: 10.0.1.34
+ 16  1771  br_default                 vxlan48     1771         46:38:39:00:00:37           10    None  remote-dst: 10.0.1.34
+ 17  1771  br_default                 vxlan48     1771         46:38:39:00:00:3b           20    None  remote-dst: 10.0.1.34
+ 18  1771  br_default                 vxlan48     1771         46:38:39:00:00:3f           30    None  remote-dst: 10.0.1.34
+ 19  1779  br_default                 vxlan48     1779         46:38:39:00:00:35           10    None  remote-dst: 10.0.1.34
+ 2   6     br_default                 bond2       1779         46:38:39:00:00:29           20
+ 20  1779  br_default                 vxlan48     1779         46:38:39:00:00:39           20    None  remote-dst: 10.0.1.34
+ 21  1779  br_default                 vxlan48     1779         46:38:39:00:00:3d           30    None  remote-dst: 10.0.1.34
+ 22  1787  br_default                 vxlan48     1787         44:38:39:00:00:3f           30    None  remote-dst: 10.0.1.34
+ 23  1787  br_default                 vxlan48     1787         44:38:39:00:00:37           10    None  remote-dst: 10.0.1.34
+ 24  1787  br_default                 vxlan48     1787         44:38:39:00:00:3b           20    None  remote-dst: 10.0.1.34
+ 25  1909  br_default     permanent   vxlan48     1909         9a:4e:24:32:dd:6c                 None
+ 26  1900                 permanent   vxlan48     453          00:00:00:00:00:00  20             None  remote-dst: 10.0.1.34
+ 27  1506  br_default                 bond1       1506         44:38:39:00:00:2f           10
+ 28  135   br_default                 bond1       1771         46:38:39:00:00:2d           10
+ 29  6     br_default                 bond1       1779         46:38:39:00:00:2f           10
+ 3   1     br_default                 bond2       1786         44:38:39:00:00:2b           20
+ 30  27    br_default                 bond1       459          44:38:39:00:00:2d           10
+ 31  1909  br_default     permanent   bond1       1909         44:38:39:00:00:30
+ 32                       permanent   br_default               00:00:00:00:00:10
+ 33                       permanent   br_default               00:00:00:00:00:20
+ 34                       permanent   br_default               44:38:39:be:ef:12
+ 35                       permanent   br_default               00:00:00:00:00:30
+ 36  1908  br_default     permanent   br_default  1908         44:38:39:00:00:7a           4036
+ 4   1909  br_default     permanent   bond2       1909         44:38:39:00:00:2a
+ 5   1897  br_default     static      peerlink    65           44:38:39:00:00:7c           30
+ 6   1909  br_default     permanent   peerlink    1909         44:38:39:00:00:01
+ 7   1506  br_default                 bond3       1506         44:38:39:00:00:31           30
+ 8   135   br_default                 bond3       1771         46:38:39:00:00:33           30
+ 9   6     br_default                 bond3       1779         46:38:39:00:00:31           30
```

Verify neighbor (ARP) entries are being learned (you can also use `arp -n` command as well):
```bash
cumulus@leaf01:mgmt:~$ ip neigh show
192.168.200.250 dev eth0 lladdr 44:38:39:00:00:90 REACHABLE
10.1.20.102 dev vlan20-v0 lladdr 44:38:39:00:00:2b STALE
10.1.10.104 dev vlan10 lladdr 44:38:39:00:00:37 extern_learn  NOARP proto zebra
192.168.200.22 dev eth0 lladdr 44:38:39:00:00:65 STALE
10.1.30.103 dev vlan30 lladdr 44:38:39:00:00:33 REACHABLE
10.0.1.34 dev vlan4036_l3 lladdr 44:38:39:be:ef:34 extern_learn  NOARP proto zebra
10.1.20.105 dev vlan20 lladdr 44:38:39:00:00:3b extern_learn  NOARP proto zebra
10.1.10.101 dev vlan10-v0 lladdr 44:38:39:00:00:2d STALE
169.254.0.1 dev swp53 lladdr 44:38:39:00:00:0e PERMANENT proto zebra
169.254.0.1 dev swp54 lladdr 44:38:39:00:00:10 PERMANENT proto zebra
10.0.1.34 dev vlan4024_l3 lladdr 44:38:39:be:ef:34 extern_learn  NOARP proto zebra
169.254.0.1 dev swp52 lladdr 44:38:39:00:00:0c PERMANENT proto zebra
10.1.10.3 dev vlan10 lladdr 44:38:39:00:00:7c PERMANENT
10.1.10.101 dev vlan10 lladdr 44:38:39:00:00:2d REACHABLE
10.0.1.34 dev vxlan48 lladdr 44:38:39:be:ef:34 extern_learn  NOARP proto zebra
192.168.200.1 dev eth0 lladdr 44:38:39:00:00:66 REACHABLE
10.1.30.106 dev vlan30 lladdr 44:38:39:00:00:3f extern_learn  NOARP proto zebra
169.254.0.1 dev swp51 lladdr 44:38:39:00:00:0a PERMANENT proto zebra
10.1.20.102 dev vlan20 lladdr 44:38:39:00:00:2b REACHABLE
169.254.0.1 dev peerlink.4094 lladdr 44:38:39:00:00:02 PERMANENT proto zebra
10.1.20.3 dev vlan20 lladdr 44:38:39:00:00:7c PERMANENT
10.1.30.3 dev vlan30 lladdr 44:38:39:00:00:7c PERMANENT
...
```

Verify routes are learned over L3VNI for inter-VLAN routed peers on VRFs RED and BLUE:
```bash
cumulus@leaf01:mgmt:~$ net show route vrf RED
show ip route vrf RED
======================
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
       F - PBR, f - OpenFabric, Z - FRR,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

VRF RED:
K>* 0.0.0.0/0 [255/8192] unreachable (ICMP unreachable), 00:34:14
C * 10.1.10.0/24 [0/1024] is directly connected, vlan10-v0, 00:34:03
C>* 10.1.10.0/24 is directly connected, vlan10, 00:34:03
B>* 10.1.10.104/32 [20/0] via 10.0.1.34, vlan4024_l3 onlink, weight 1, 00:10:09
C * 10.1.20.0/24 [0/1024] is directly connected, vlan20-v0, 00:34:03
C>* 10.1.20.0/24 is directly connected, vlan20, 00:34:03
B>* 10.1.20.105/32 [20/0] via 10.0.1.34, vlan4024_l3 onlink, weight 1, 00:09:59
...
```
```bash
cumulus@leaf01:mgmt:~$ net show route vrf BLUE
show ip route vrf BLUE
=======================
Codes: K - kernel route, C - connected, S - static, R - RIP,
       O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, D - SHARP,
       F - PBR, f - OpenFabric, Z - FRR,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

VRF BLUE:
K>* 0.0.0.0/0 [255/8192] unreachable (ICMP unreachable), 00:35:10
C * 10.1.30.0/24 [0/1024] is directly connected, vlan30-v0, 00:35:00
C>* 10.1.30.0/24 is directly connected, vlan30, 00:35:00
B>* 10.1.30.106/32 [20/0] via 10.0.1.34, vlan4036_l3 onlink, weight 1, 00:10:13
...
```

Verify that MAC address of gateway is being populated into EVPN:
```bash
cumulus@leaf01:mgmt:~$ net show bgp l2vpn evpn route
BGP table version is 13, local router ID is 10.10.10.1
Status codes: s suppressed, d damped, h history, * valid, > best, i - internal
Origin codes: i - IGP, e - EGP, ? - incomplete
EVPN type-1 prefix: [1]:[ESI]:[EthTag]:[IPlen]:[VTEP-IP]:[Frag-id]
EVPN type-2 prefix: [2]:[EthTag]:[MAClen]:[MAC]:[IPlen]:[IP]
EVPN type-3 prefix: [3]:[EthTag]:[IPlen]:[OrigIP]
EVPN type-4 prefix: [4]:[ESI]:[IPlen]:[OrigIP]
EVPN type-5 prefix: [5]:[EthTag]:[IPlen]:[IP]

   Network          Next Hop            Metric LocPrf Weight Path
                    Extended Community
Route Distinguisher: 10.10.10.1:4
*> [2]:[0]:[48]:[44:38:39:00:00:29] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[44:38:39:00:00:2b] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[44:38:39:00:00:2b]:[32]:[10.1.20.102] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[44:38:39:00:00:2b]:[128]:[fe80::4638:39ff:fe00:2b] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20
*> [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[46:38:39:00:00:29] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[46:38:39:00:00:2b] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:be:ef:12
*> [3]:[0]:[32]:[10.0.1.12] RD 10.10.10.1:4
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20
Route Distinguisher: 10.10.10.1:5
*> [2]:[0]:[48]:[44:38:39:00:00:31] RD 10.10.10.1:5
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[44:38:39:00:00:33] RD 10.10.10.1:5
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[44:38:39:00:00:33]:[32]:[10.1.30.103] RD 10.10.10.1:5
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[44:38:39:00:00:33]:[128]:[fe80::4638:39ff:fe00:33] RD 10.10.10.1:5
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30
*> [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.1:5
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[46:38:39:00:00:31] RD 10.10.10.1:5
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[46:38:39:00:00:33] RD 10.10.10.1:5
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:be:ef:12
*> [3]:[0]:[32]:[10.0.1.12] RD 10.10.10.1:5
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30
Route Distinguisher: 10.10.10.1:6
*> [2]:[0]:[48]:[44:38:39:00:00:2d] RD 10.10.10.1:6
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[44:38:39:00:00:2d]:[32]:[10.1.10.101] RD 10.10.10.1:6
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[44:38:39:00:00:2d]:[128]:[fe80::4638:39ff:fe00:2d] RD 10.10.10.1:6
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10
*> [2]:[0]:[48]:[44:38:39:00:00:2f] RD 10.10.10.1:6
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.1:6
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[46:38:39:00:00:2d] RD 10.10.10.1:6
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:be:ef:12
*> [2]:[0]:[48]:[46:38:39:00:00:2f] RD 10.10.10.1:6
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:be:ef:12
*> [3]:[0]:[32]:[10.0.1.12] RD 10.10.10.1:6
                    10.0.1.12 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10
Route Distinguisher: 10.10.10.3:4
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:4
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:4
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:4
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:4
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.3:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.3:4
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.3:4
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.3:4
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.3:4
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.3:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.3:4
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.3:4
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.3:4
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.3:4
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:4
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:4
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:4
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:4
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:4
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:4
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:4
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:4
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:4
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*> [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:4
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:4
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:4
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
Route Distinguisher: 10.10.10.3:5
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:5
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:5
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:5
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:5
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.3:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.3:5
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.3:5
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.3:5
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.3:5
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.3:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.3:5
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.3:5
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.3:5
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.3:5
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:5
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:5
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:5
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:5
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:5
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:5
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:5
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:5
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:5
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*> [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:5
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:5
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:5
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
Route Distinguisher: 10.10.10.3:6
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:6
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:6
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:6
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:6
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:6
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:6
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:6
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:6
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.3:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.3:6
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.3:6
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.3:6
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.3:6
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.3:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.3:6
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.3:6
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.3:6
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.3:6
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:6
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:6
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.3:6
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:0.10.3:6
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:6
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:6
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:6
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:6
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65103 i
                    RT:65103:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:6
                    10.0.1.34 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*> [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:6
                    10.0.1.34 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:6
                    10.0.1.34 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.3:6
                    10.0.1.34 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
Route Distinguisher: 10.10.10.4:4
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.4:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.4:4
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.4:4
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.4:4
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.4:4
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.4:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.4:4
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.4:4
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.4:4
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.4:4
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.4:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.4:4
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.4:4
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.4:4
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.4:4
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:4
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:4
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:4
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:4
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:4
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:4
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:4
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:4
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:4
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:4
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:4
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:4
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:4
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:4
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*> [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:4
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:4
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:4
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
Route Distinguisher: 10.10.10.4:5
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.4:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.4:5
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.4:5
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.4:5
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.4:5
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.4:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.4:5
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.4:5
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.4:5
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.4:5
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.4:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.4:5
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.4:5
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.4:5
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.4:5
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:5
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:5
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:5
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:5
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:5
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:5
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:5
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:5
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:5
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:5
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:5
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:5
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:be:ef:34
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:5
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:5
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*> [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:5
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:5
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:5
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
Route Distinguisher: 10.10.10.4:6
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:6
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:6
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:6
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:6
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:6
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:6
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:6
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:6
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.4:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.4:6
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.4:6
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.4:6
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.4:6
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.4:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.4:6
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.4:6
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.4:6
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.4:6
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:6
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:6
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:6
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.4:6
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:6
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:6
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:6
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:6
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:6
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*> [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:6
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:6
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:6
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:be:ef:34
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:6
                    10.0.1.34 (leaf02)
                                                           0 65102 65100 65104 i
                    RT:65104:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:6
                    10.0.1.34 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*> [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:6
                    10.0.1.34 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:6
                    10.0.1.34 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [3]:[0]:[32]:[10.0.1.34] RD 10.10.10.4:6
                    10.0.1.34 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8

Displayed 65 prefixes (229 paths)
```

<!-- AIR:page -->

### SNMP 

Run `snmpget` from the `oob-mgmt-server` for the the switch `hostname` and `version` MIBs:
```bash
ubuntu@oob-mgmt-server:~$ snmpget -v2c -c public 192.168.200.6 iso.3.6.1.2.1.1.5.0
iso.3.6.1.2.1.1.5.0 = STRING: "leaf01"
ubuntu@oob-mgmt-server:~$ snmpget -v2c -c public 192.168.200.6 iso.3.6.1.2.1.1.1.0
iso.3.6.1.2.1.1.1.0 = STRING: "Cumulus-Linux 5.1.0 (Linux Kernel 4.19.237-1+cl5.1.0u1)"
```
You can examine all MIBs by running `snmpwalk` command:
```bash
ubuntu@oob-mgmt-server:~$ snmpwalk -v2c -c public 192.168.200.6 
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

Check that the switches send syslog messages to the syslog server (`oob-mgmt-server`):
```bash
ubuntu@oob-mgmt-server:~$ cat /var/log/syslog | grep 192.168.200.6
Jun  7 07:50:00 oob-mgmt-server dhcpd[1899]: DHCPOFFER on 192.168.200.6 to 44:38:39:00:00:70 via eth1
Jun  7 07:50:00 oob-mgmt-server dhcpd[1899]: DHCPREQUEST for 192.168.200.6 (192.168.200.1) from 44:38:39:00:00:70 via eth1
Jun  7 07:50:00 oob-mgmt-server dhcpd[1899]: DHCPACK on 192.168.200.6 to 44:38:39:00:00:70 via eth1
Jun  7 08:47:34 oob-mgmt-server tac_plus[31103]: connect from 192.168.200.6 [192.168.200.6]
Jun  7 08:47:34 oob-mgmt-server tac_plus[31106]: connect from 192.168.200.6 [192.168.200.6]
...
```
Cumulus Linux sends logs through `rsyslog`, which writes them to files in the local `/var/log` directory. There are default rules in the `/etc/rsyslog.d/` directory such as `10-rules.conf`, `20-clagd.conf`, `22-linkstate.conf` and more. Check out [Syslog documenation](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Monitoring-and-Troubleshooting/#send-log-files-to-a-syslog-server) for more infomration.
For Syslog server configuration, you can check out the [RSyslog official documentation](https://www.rsyslog.com/doc/master/).

<!-- AIR:page -->

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
cumulus@oob-mgmt-server:mgmt:~$ netq check bgp
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
cumulus@oob-mgmt-server:mgmt:~$ netq check mlag
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
cumulus@oob-mgmt-server:mgmt:~$ netq check 
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
cumulus@oob-mgmt-server:mgmt:~$ netq trace 10.1.20.105 from 10.1.10.101 detail
Number of Paths: 16
Number of Paths with Errors: 0
Number of Paths with Warnings: 0
Path MTU: 9000

Id  Hop Hostname        InPort          InVlan InTunnel              InRtrIf         InVRF           OutRtrIf        OutVRF          OutTunnel             OutPort         OutVlan
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
1   1   server01                                                                                     uplink          default                               eth2
    2   leaf02          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 20               swp54
    3   spine04         swp2                                         swp2            default         swp3            default                               swp3
    4   leaf03          swp54                  vni: 20               vlan20          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
2   1   server01                                                                                     uplink          default                               eth2
    2   leaf02          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 10               swp54
    3   spine04         swp2                                         swp2            default         swp3            default                               swp3
    4   leaf03          swp54                  vni: 10               vlan10          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
3   1   server01                                                                                     uplink          default                               eth2
    2   leaf02          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 20               swp53
    3   spine03         swp2                                         swp2            default         swp3            default                               swp3
    4   leaf03          swp53                  vni: 20               vlan20          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
4   1   server01                                                                                     uplink          default                               eth2
    2   leaf02          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 10               swp53
    3   spine03         swp2                                         swp2            default         swp3            default                               swp3
    4   leaf03          swp53                  vni: 10               vlan10          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
5   1   server01                                                                                     uplink          default                               eth2
    2   leaf02          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 20               swp52
    3   spine02         swp2                                         swp2            default         swp3            default                               swp3
    4   leaf03          swp52                  vni: 20               vlan20          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
6   1   server01                                                                                     uplink          default                               eth2
    2   leaf02          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 10               swp52
    3   spine02         swp2                                         swp2            default         swp3            default                               swp3
    4   leaf03          swp52                  vni: 10               vlan10          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
7   1   server01                                                                                     uplink          default                               eth2
    2   leaf02          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 20               swp51
    3   spine01         swp2                                         swp2            default         swp3            default                               swp3
    4   leaf03          swp51                  vni: 20               vlan20          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
8   1   server01                                                                                     uplink          default                               eth2
    2   leaf02          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 10               swp51
    3   spine01         swp2                                         swp2            default         swp3            default                               swp3
    4   leaf03          swp51                  vni: 10               vlan10          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
9   1   server01                                                                                     uplink          default                               eth1
    2   leaf01          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 20               swp54
    3   spine04         swp1                                         swp1            default         swp3            default                               swp3
    4   leaf03          swp54                  vni: 20               vlan20          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
10  1   server01                                                                                     uplink          default                               eth1
    2   leaf01          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 10               swp54
    3   spine04         swp1                                         swp1            default         swp3            default                               swp3
    4   leaf03          swp54                  vni: 10               vlan10          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
11  1   server01                                                                                     uplink          default                               eth1
    2   leaf01          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 20               swp53
    3   spine03         swp1                                         swp1            default         swp3            default                               swp3
    4   leaf03          swp53                  vni: 20               vlan20          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
12  1   server01                                                                                     uplink          default                               eth1
    2   leaf01          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 10               swp53
    3   spine03         swp1                                         swp1            default         swp3            default                               swp3
    4   leaf03          swp53                  vni: 10               vlan10          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
13  1   server01                                                                                     uplink          default                               eth1
    2   leaf01          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 20               swp52
    3   spine02         swp1                                         swp1            default         swp3            default                               swp3
    4   leaf03          swp52                  vni: 20               vlan20          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
14  1   server01                                                                                     uplink          default                               eth1
    2   leaf01          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 10               swp52
    3   spine02         swp1                                         swp1            default         swp3            default                               swp3
    4   leaf03          swp52                  vni: 10               vlan10          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
15  1   server01                                                                                     uplink          default                               eth1
    2   leaf01          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 20               swp51
    3   spine01         swp1                                         swp1            default         swp3            default                               swp3
    4   leaf03          swp51                  vni: 20               vlan20          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
16  1   server01                                                                                     uplink          default                               eth1
    2   leaf01          swp1            10                           vlan10          RED             vlan4024_l3     RED             vni: 10               swp51
    3   spine01         swp1                                         swp1            default         swp3            default                               swp3
    4   leaf03          swp51                  vni: 10               vlan10          RED             vlan20          RED                                   swp2            20
    5   server05        uplink
--- --- --------------- --------------- ------ --------------------- --------------- --------------- --------------- --------------- --------------------- --------------- -------
```
**Note:** Some checks (e.g. Link MTU Consistency, Autoneg) could fail between devices like the border leaves and the unconfigured servers/fws. 
```bash
cumulus@oob-mgmt-server:mgmt:~$ netq check mtu
mtu check result summary:

Total nodes         : 21
Checked nodes       : 21
Failed nodes        : 6
Rotten nodes        : 0
Warning nodes       : 0
Skipped nodes       : 0

Additional summary:
Checked Links       : 273
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
cumulus@oob-mgmt-server:mgmt:~$ netq show vxlan

Matching vxlan records:
Hostname          VNI        Protocol     VTEP IP          VLAN   Replication List                    Last Changed
----------------- ---------- ------------ ---------------- ------ ----------------------------------- -------------------------
border01          4001       EVPN         10.0.1.255       4024                                       Tue Jun  7 12:34:19 2022
border01          4002       EVPN         10.0.1.255       4036                                       Tue Jun  7 12:34:19 2022
border02          4001       EVPN         10.0.1.255       4024                                       Tue Jun  7 12:34:18 2022
border02          4002       EVPN         10.0.1.255       4036                                       Tue Jun  7 10:20:27 2022
leaf01            4001       EVPN         10.0.1.12        4024                                       Tue Jun  7 10:44:45 2022
leaf01            20         EVPN         10.0.1.12        20     10.0.1.34(leaf04, leaf03)           Tue Jun  7 10:44:45 2022
leaf01            10         EVPN         10.0.1.12        10     10.0.1.34(leaf04, leaf03)           Tue Jun  7 10:44:45 2022
leaf01            4002       EVPN         10.0.1.12        4036                                       Tue Jun  7 10:44:45 2022
leaf01            30         EVPN         10.0.1.12        30     10.0.1.34(leaf04, leaf03)           Tue Jun  7 10:44:45 2022
leaf02            4001       EVPN         10.0.1.12        4024                                       Tue Jun  7 10:32:50 2022
leaf02            20         EVPN         10.0.1.12        20     10.0.1.34(leaf04, leaf03)           Tue Jun  7 10:32:50 2022
leaf02            10         EVPN         10.0.1.12        10     10.0.1.34(leaf04, leaf03)           Tue Jun  7 10:32:50 2022
leaf02            4002       EVPN         10.0.1.12        4036                                       Tue Jun  7 10:20:27 2022
leaf02            30         EVPN         10.0.1.12        30     10.0.1.34(leaf04, leaf03)           Tue Jun  7 10:32:50 2022
leaf03            4001       EVPN         10.0.1.34        4024                                       Tue Jun  7 12:53:04 2022
leaf03            20         EVPN         10.0.1.34        20     10.0.1.12(leaf01, leaf02)           Tue Jun  7 12:53:04 2022
leaf03            10         EVPN         10.0.1.34        10     10.0.1.12(leaf01, leaf02)           Tue Jun  7 12:53:04 2022
leaf03            4002       EVPN         10.0.1.34        4036                                       Tue Jun  7 10:20:27 2022
leaf03            30         EVPN         10.0.1.34        30     10.0.1.12(leaf01, leaf02)           Tue Jun  7 12:53:04 2022
leaf04            4001       EVPN         10.0.1.34        4024                                       Tue Jun  7 13:28:03 2022
leaf04            20         EVPN         10.0.1.34        20     10.0.1.12(leaf01, leaf02)           Tue Jun  7 13:28:03 2022
leaf04            10         EVPN         10.0.1.34        10     10.0.1.12(leaf01, leaf02)           Tue Jun  7 13:28:03 2022
leaf04            4002       EVPN         10.0.1.34        4036                                       Tue Jun  7 10:20:27 2022
leaf04            30         EVPN         10.0.1.34        30     10.0.1.12(leaf01, leaf02)           Tue Jun  7 13:28:03 2022
```

<!-- AIR:page -->


## Automation

In case you want to make configueration changes or re-apply all/partial original demo configuration without rebuilding the simulation, you can use the `nvue.yaml` playbook (fully/specific roles) stored on the `oob-mgmt-server`. 

1. Login to the `oob-mgmt-server`
2. Enter to the `cumulus_ansible_modules` folder:
```bash
ubuntu@oob-mgmt-server:~$ cd cumulus_ansible_modules/
```
3. Make sure you are on the `evpn_demo_nvue` branch:
```bash
ubuntu@oob-mgmt-server:~/cumulus_ansible_modules$ git status | grep evpn_demo_nvue
On branch evpn_demo_nvue
Your branch is up to date with 'origin/evpn_demo_nvue'.
```
*In case you or on other branch, use the `git checkout` command to move the `evpn_demo_nvue` branch*
```bash
ubuntu@oob-mgmt-server:~/cumulus_ansible_modules$ git checkout evpn_demo_nvue
```
4. Vreify `oob-mgmt-server` still can connect to all topology devices using ansible `ping` module:
```bash
ubuntu@oob-mgmt-server:~/cumulus_ansible_modules$ ansible pod1 -i inventories/evpn_symmetric/hosts -m ping
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
5. Run `nvue.yaml` ansible playbook to deploy the demo on the fabric:
```bash
ubuntu@oob-mgmt-server:~/cumulus_ansible_modules$ ansible-playbook playbooks/nvue.yml -i inventories/evpn_symmetric/hosts
```

### Playbook Structure

The playbooks have the following important structure:
* Variables and inventories are stored in the same directory `inventories/`
* Backup configurations are stored in `config/` folder of the inventory 
```bash
ubuntu@oob-mgmt-server:~/cumulus_ansible_modules$ cd inventories/evpn_symmetric/config
```

<!-- AIR:tour -->
