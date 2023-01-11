<!-- AIR:tour -->

# Distributed EVPN Symmetric Routing With Multi-Homing

This environment demonstrates a best-practice configuration for deploying distributed inter-VLAN routing using [EVPN symmetric](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/Inter-subnet-Routing/#symmetric-routing) model. In this demo, we use the [NVUE Object Model](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/NVIDIA-User-Experience-NVUE/NVUE-Object-Model/) and [NVUE CLI](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/NVIDIA-User-Experience-NVUE/NVUE-CLI/) to set all-active server redundant environment with [EVPN Multihoming](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/EVPN-Multihoming/) configuration to present EVPN fabric with **standardized L2 redundancy** on the ToR switches.

When using the symmetric model, each VTEP bridges and routes the traffic (ingress and egress). The layer 2 traffic is being bridged (VLAN-L2VNI) on the leaf ingress host port, then routed to special transit VNI which is used for all routed VXLAN traffic, called the L3VNI. All VXLAN traffic must be routed onto this L3VNI, tunneled across the layer 3 infrastructure, and routed off the L3VNI to the appropriate VLAN at the destination VTEP and ultimately bridged to the destination host.

In this model, the leaf switches only need to host the VLANs (mapped to VNIs) located on its rack and the L3VNI and its associated VLAN. This is because the ingress leaf switch doesn’t need to know the destination VNI. 

Multitenancy requires one L3VNI per VRF, and all switches participating in that VRF must be configured with the same L3VNI. The egress leaf uses the L3VNI to identify the VRF in which to route the packet.

Check out [Cumulus Linux documentation](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/Inter-subnet-Routing/) for more information and examples.

Check out this [blog](https://developer.nvidia.com/blog/looking-behind-the-curtain-of-evpn-traffic-flows/) to deeper understand the EVPN traffic flows in a virtualized environment.

EVPN Multihoming [EVPN-MH](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/EVPN-Multihoming/) is the standards-based replacement for [MLAG](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-2/Multi-Chassis-Link-Aggregation-MLAG/) to provide L2 server redundancy on to the Top-of-Rack level.

When using EVPN-MH you get these benefits:
 * No peerlink (ISL) is needed between the ToR switches
 * More than two ToR can be used
 * Single BGP-EVPN control plane
 * Multi-vendor interoperability

With EVPN-MH ToR switches are divided into Ethernet Segments (ES). All segment peers synchronize their MAC database based on their unique ES-ID to forward traffic to the connected servers. 

Using the default Head-End-Replication (HER) method to replicate BUM (Broadcast, Unknown-Unicast and Multicast) overlay traffic in this deployment type is not optimal as there can be much more VTEPs than in other deployment types. So in EVPN-MH environments, we use [Protocol Independent Multicast Sparse Mode - PIM-SM](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-3/Protocol-Independent-Multicast-PIM/) to handle the BUM traffic. To forward BUM traffic to remote VTEPs, L2 VNIs (VLANs) are added to a multicast group. Then, BUM traffic is forwarded to the group member VTEPs. That way, only the group members receive the traffic rather than all VTEPs on the HER list. Each L2 VNI (VLAN) should be set to a single multicast group for optimal underlay bandwidth utilization.

Check out [EVPN BUM Traffic with PIM-SM documentation](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/EVPN-PIM/) for more information and configuration examples.

## Features and Services

This demo includes the following features and services:

 * [SVI](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-2/Ethernet-Bridging-VLANs/VLAN-aware-Bridge-Mode/#vlan-layer-3-addressing) gateway and [VRR](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-2/Virtual-Router-Redundancy-VRR-and-VRRP/) for L3 server redundacy
 * [BGP](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-3/Border-Gateway-Protocol-BGP/) underlay fabric using [BGP unnumbered](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-50/Layer-3/Border-Gateway-Protocol-BGP/#bgp-unnumbered) interfaces
 * [PIM](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-3/Protocol-Independent-Multicast-PIM/) to handle BUM traffic replication
 * Management, default and custom [VRFs](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-3/VRFs/Virtual-Routing-and-Forwarding-VRF/) for mgmt., underlay and overlay traffic 
 * [VXLAN](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/) overlay encapsulation data plane
 * [EVPN](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/) overlay control plane
 * [EVPN-MH](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Network-Virtualization/Ethernet-Virtual-Private-Network-EVPN/EVPN-Multihoming/)
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
| border01    | eth0          | mgmt.   |          | 192.168.200.16/24 |
|             | lo            | default |          | 10.10.10.63/32    |
| border02    | eth0          | mgmt.   |          | 192.168.200.17/24 |
|             | lo            | default |          | 10.10.10.64/32    |
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
|           | swp51          | swp1            | spine01           |
|           | swp52          | swp1            | spine02           |
|           | swp53          | swp1            | spine03           |
|           | swp54          | swp1            | spine04           |
| leaf02    | swp1           | eth2(uplink)    | server01          |
|           | swp2           | eth2(uplink)    | server02          |
|           | swp3           | eth2(uplink)    | server03          |
|           | swp51          | swp2            | spine01           |
|           | swp52          | swp2            | spine02           |
|           | swp53          | swp2            | spine03           |
|           | swp54          | swp2            | spine04           |
| leaf03    | swp1           | eth1(uplink)    | server04          |
|           | swp2           | eth1(uplink)    | server05          |
|           | swp3           | eth1(uplink)    | server06          |
|           | swp51          | swp3            | spine01           |
|           | swp52          | swp3            | spine02           |
|           | swp53          | swp3            | spine03           |
|           | swp54          | swp3            | spine04           |
| leaf04    | swp1           | eth2(uplink)    | server04          |
|           | swp2           | eth2(uplink)    | server05          |
|           | swp3           | eth2(uplink)    | server06          |
|           | swp51          | swp4            | spine01           |
|           | swp52          | swp4            | spine02           |
|           | swp53          | swp4            | spine03           |
|           | swp54          | swp4            | spine04           |
| border01  | swp1           | eth1            | server07          |
|           | swp2           | eth1            | server08          |
|           | swp3           | eth1            | fw1               |
|           | swp4           | eth1            | fw2               |
|           | swp51          | swp5            | spine01           |
|           | swp52          | swp5            | spine02           |
|           | swp53          | swp5            | spine03           |
|           | swp54          | swp5            | spine04           |
| border02  | swp1           | eth2            | server07          |
|           | swp2           | eth2            | server08          |
|           | swp3           | eth2            | fw1               |
|           | swp4           | eth2            | fw2               |
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
Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 4.15.0-188-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed Jul 20 14:24:57 UTC 2022

  System load:  0.0               Processes:             94
  Usage of /:   26.2% of 9.29GB   Users logged in:       0
  Memory usage: 42%               IP address for eth0:   192.168.200.10
  Swap usage:   0%                IP address for uplink: 10.1.10.101

 * Super-optimized for small spaces - read how we shrank the memory
   footprint of MicroK8s to make it the smallest full K8s around.

   https://ubuntu.com/blog/microk8s-memory-optimisation

0 updates can be applied immediately.

New release '20.04.4 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


*** System restart required ***
#########################################################
#      You are successfully logged in to: server01      #
#########################################################
Last login: Wed Jul 20 14:24:12 2022 from 192.168.200.1
ubuntu@server01:~$
```

Check `server04` reachability to validate L2 intra-VLAN connectivity in VRF `RED`:
```bash
ubuntu@server01:~$ ping 10.1.10.104 -c 3
PING 10.1.10.104 (10.1.10.104) 56(84) bytes of data.
64 bytes from 10.1.10.104: icmp_seq=1 ttl=64 time=2.63 ms
64 bytes from 10.1.10.104: icmp_seq=2 ttl=64 time=1.58 ms
64 bytes from 10.1.10.104: icmp_seq=3 ttl=64 time=1.58 ms

--- 10.1.10.104 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 1.582/1.935/2.634/0.494 ms
```

Check `server02` and `server05` reachability to validate L3 inter-VLAN connectivity in VRF `RED`:
```bash
ubuntu@server01:~$ for srv in {20.102,20.105} ; do ping 10.1.${srv} -c 3; done
PING 10.1.20.102 (10.1.20.102) 56(84) bytes of data.
64 bytes from 10.1.20.102: icmp_seq=1 ttl=63 time=1.86 ms
64 bytes from 10.1.20.102: icmp_seq=2 ttl=63 time=0.990 ms
64 bytes from 10.1.20.102: icmp_seq=3 ttl=63 time=0.790 ms

--- 10.1.20.102 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 0.790/1.213/1.861/0.466 ms
PING 10.1.20.105 (10.1.20.105) 56(84) bytes of data.
64 bytes from 10.1.20.105: icmp_seq=1 ttl=62 time=3.73 ms
64 bytes from 10.1.20.105: icmp_seq=2 ttl=62 time=1.60 ms
64 bytes from 10.1.20.105: icmp_seq=3 ttl=62 time=1.73 ms

--- 10.1.20.105 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 1.609/2.360/3.736/0.974 ms
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
Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 4.15.0-188-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed Jul 20 14:29:01 UTC 2022

  System load:  0.0               Processes:             93
  Usage of /:   26.2% of 9.29GB   Users logged in:       0
  Memory usage: 43%               IP address for eth0:   192.168.200.12
  Swap usage:   0%                IP address for uplink: 10.1.30.103

 * Super-optimized for small spaces - read how we shrank the memory
   footprint of MicroK8s to make it the smallest full K8s around.

   https://ubuntu.com/blog/microk8s-memory-optimisation

0 updates can be applied immediately.

New release '20.04.4 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


*** System restart required ***
#########################################################
#      You are successfully logged in to: server03      #
#########################################################
Last login: Wed Jul 20 13:52:47 2022 from 192.168.200.1
```
```bash
ubuntu@server03:~$ ping 10.1.30.106 -c 3
PING 10.1.30.106 (10.1.30.106) 56(84) bytes of data.
64 bytes from 10.1.30.106: icmp_seq=1 ttl=64 time=3.13 ms
64 bytes from 10.1.30.106: icmp_seq=2 ttl=64 time=1.91 ms
64 bytes from 10.1.30.106: icmp_seq=3 ttl=64 time=2.00 ms

--- 10.1.30.106 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 1.918/2.350/3.133/0.557 ms
```
<!-- AIR:page -->

### Switches Configuration 

Althought Cumulus Linux 5.1 uses NVUE `configuration` commands, it still has limited `show` commands. Thus, as for now, to verify switch configuration, present states and get information, you can use the old NCLU `show` commands. In future Cumulus releases, NCLU `show` commands will no longer be avaliable and will be replaced with the new NVUE commands.

In the verification steps below, we use the combination of NVUE, Linux and NCLU commands. We present all outputs on `leaf01` as referance. The border leaves serve as the Multicast Rendezvous Points (RP), they have additional PIM configuration and will be presented on `border01`.

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
Last login: Wed Jul 20 14:22:05 2022 from 192.168.200.1
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
                '10':
                  flooding:
                    enable: on
                    multicast-group: 224.1.1.10
            '20':
              vni:
                '20':
                  flooding:
                    enable: on
                    multicast-group: 224.1.1.20
            '30':
              vni:
                '30':
                  flooding:
                    enable: on
                    multicast-group: 224.1.1.30
    evpn:
      enable: on
      multihoming:
        enable: on
        startup-delay: 10
      route-advertise:
        svi-ip: on
    nve:
      vxlan:
        arp-nd-suppress: on
        enable: on
        source:
          address: 10.10.10.1
    router:
      bgp:
        enable: on
      pim:
        enable: on
        timers:
          keep-alive: 3600
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
        anycast-mac: 44:38:39:BE:EF:AA
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
          pim:
            address-family:
              ipv4-unicast:
                rp:
                  10.10.100.100:
                    group-range:
                      224.1.1.0/24: {}
            ecmp:
              enable: on
            enable: on
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
          mode: lacp
        bridge:
          domain:
            br_default:
              stp:
                admin-edge: on
                auto-edge: on
                bpdu-guard: on
        evpn:
          multihoming:
            segment:
              df-preference: 50000
              enable: on
              mac-address: 44:38:39:BE:EF:AA
        link:
          mtu: 9000
        type: bond
      bond1:
        bond:
          member:
            swp1: {}
        bridge:
          domain:
            br_default:
              access: 10
        evpn:
          multihoming:
            segment:
              local-id: 1
      bond2:
        bond:
          member:
            swp2: {}
        bridge:
          domain:
            br_default:
              access: 20
        evpn:
          multihoming:
            segment:
              local-id: 2
      bond3:
        bond:
          member:
            swp3: {}
        bridge:
          domain:
            br_default:
              access: 30
        evpn:
          multihoming:
            segment:
              local-id: 3
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
        router:
          pim:
            address-family:
              ipv4-unicast:
                use-source: 10.10.10.1
        type: loopback
      lo,swp51-54,vlan10,20,30:
        router:
          pim:
            enable: on
      swp51-54:
        evpn:
          multihoming:
            uplink: on
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
      vlan10,20,30:
        ip:
          igmp:
            enable: on
          vrr:
            enable: on
            state:
              up: {}
        type: svi
      vlan10,20:
        ip:
          vrf: RED
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
Border leaf extra PIM RP configuration:
```bash
          pim:
          ...
          ...
            msdp-mesh-group:
              rpmesh:
                member-address:
                  10.10.10.64: {}
                source-address: 10.10.10.63
...
...
      lo:
        ip:
          address:
            10.10.10.63/32: {}
            10.10.100.100/32: {}
```

You can also check the exact CLI commands set into the system by using the `nv config show -o commands` command:
```bash
cumulus@leaf01:mgmt:~$ nv config show -o commands
nv set bridge domain br_default type vlan-aware
nv set bridge domain br_default vlan 10 vni 10 flooding enable on
nv set bridge domain br_default vlan 10 vni 10 flooding multicast-group 224.1.1.10
nv set bridge domain br_default vlan 20 vni 20 flooding enable on
nv set bridge domain br_default vlan 20 vni 20 flooding multicast-group 224.1.1.20
nv set bridge domain br_default vlan 30 vni 30 flooding enable on
nv set bridge domain br_default vlan 30 vni 30 flooding multicast-group 224.1.1.30
nv set evpn enable on
nv set evpn multihoming enable on
nv set evpn multihoming startup-delay 10
nv set evpn route-advertise svi-ip on
nv set nve vxlan arp-nd-suppress on
nv set nve vxlan enable on
nv set nve vxlan source address 10.10.10.1
nv set router bgp enable on
nv set router pim enable on
nv set router pim timers keep-alive 3600
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
nv set system global anycast-mac 44:38:39:BE:EF:AA
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
nv set vrf default router pim address-family ipv4-unicast rp 10.10.100.100 group-range 224.1.1.0/24
nv set vrf default router pim ecmp enable on
nv set vrf default router pim enable on
nv set vrf mgmt router static 0.0.0.0/0 address-family ipv4-unicast
nv set vrf mgmt router static 0.0.0.0/0 via 192.168.200.1 type ipv4-address
nv set interface bond1-3 bond lacp-bypass on
nv set interface bond1-3 bond mode lacp
nv set interface bond1-3 bridge domain br_default stp admin-edge on
nv set interface bond1-3 bridge domain br_default stp auto-edge on
nv set interface bond1-3 bridge domain br_default stp bpdu-guard on
nv set interface bond1-3 evpn multihoming segment df-preference 50000
nv set interface bond1-3 evpn multihoming segment enable on
nv set interface bond1-3 evpn multihoming segment mac-address 44:38:39:BE:EF:AA
nv set interface bond1-3 link mtu 9000
nv set interface bond1-3 type bond
nv set interface bond1 bond member swp1
nv set interface bond1 bridge domain br_default access 10
nv set interface bond1 evpn multihoming segment local-id 1
nv set interface bond2 bond member swp2
nv set interface bond2 bridge domain br_default access 20
nv set interface bond2 evpn multihoming segment local-id 2
nv set interface bond3 bond member swp3
nv set interface bond3 bridge domain br_default access 30
nv set interface bond3 evpn multihoming segment local-id 3
nv set interface eth0 ip address 192.168.200.6/24
nv set interface eth0 ip vrf mgmt
nv set interface eth0 type eth
nv set interface lo ip address 10.10.10.1/32
nv set interface lo router pim address-family ipv4-unicast use-source 10.10.10.1
nv set interface lo type loopback
nv set interface lo,swp51-54,vlan10,20,30 router pim enable on
nv set interface swp51-54 evpn multihoming uplink on
nv set interface swp51-54 link state up
nv set interface swp51-54 type swp
nv set interface vlan10 ip address 10.1.10.2/24
nv set interface vlan10 ip vrr address 10.1.10.1/24
nv set interface vlan10 ip vrr mac-address 00:00:00:00:00:10
nv set interface vlan10 vlan 10
nv set interface vlan10,20,30 ip igmp enable on
nv set interface vlan10,20,30 ip vrr enable on
nv set interface vlan10,20,30 ip vrr state up
nv set interface vlan10,20,30 type svi
nv set interface vlan10,20 ip vrf RED
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

```bash
cumulus@border01:mgmt:~$ nv config show -o commands
...
nv set vrf default router pim msdp-mesh-group rpmesh member-address 10.10.10.64
nv set vrf default router pim msdp-mesh-group rpmesh source-address 10.10.10.63
...
nv set interface lo ip address 10.10.100.100/32
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
[mdb]                                     Set of mdb entries in the bridge domain
[router-port]                             Set of multicast router ports
```

#### Ethernet Segments 

Verify bonds operational state:
```bash
cumulus@leaf01:mgmt:~$ nv show interface | grep bond
+ bond1       9000   1G     up     bond
+ bond2       9000   1G     up     bond
+ bond3       9000   1G     up     bond
```

Verify ESI (Ethernet Segment ID) assignment on the bonds:

```bash
cumulus@leaf01:mgmt:~$ net show interface bond1 | grep EVPN-MH
  EVPN-MH: ES id 1 ES sysmac 44:38:39:be:ef:aa
cumulus@leaf01:mgmt:~$ net show interface bond2 | grep EVPN-MH
  EVPN-MH: ES id 2 ES sysmac 44:38:39:be:ef:aa
cumulus@leaf01:mgmt:~$ net show interface bond3 | grep EVPN-MH
  EVPN-MH: ES id 3 ES sysmac 44:38:39:be:ef:aa
```
```bash
cumulus@leaf01:mgmt:~$ net show evpn es
Type: B bypass, L local, R remote, N non-DF
ESI                            Type ES-IF                 VTEPs
03:44:38:39:be:ef:aa:00:00:01  LR   bond1                 10.10.10.2
03:44:38:39:be:ef:aa:00:00:02  LR   bond2                 10.10.10.2
03:44:38:39:be:ef:aa:00:00:03  LR   bond3                 10.10.10.2
03:44:38:39:be:ef:bb:00:00:01  R    -                     10.10.10.3,10.10.10.4
03:44:38:39:be:ef:bb:00:00:02  R    -                     10.10.10.3,10.10.10.4
03:44:38:39:be:ef:bb:00:00:03  R    -                     10.10.10.3,10.10.10.4
```
Verfify local VNI to ESI mapping:
```bash
cumulus@leaf01:mgmt:~$ net show evpn es-evi
Type: L local, R remote
VNI      ESI                            Type
10       03:44:38:39:be:ef:aa:00:00:01  L
30       03:44:38:39:be:ef:aa:00:00:03  L
20       03:44:38:39:be:ef:aa:00:00:02  L
```
Verfify ES per VNI information learned via EVPN type-1 and type-4 routes:
```bash
cumulus@leaf01:mgmt:~$ net show bgp l2vpn evpn es-evi
Flags: L local, R remote, I inconsistent
VTEP-Flags: E EAD-per-ES, V EAD-per-EVI
VNI      ESI                            Flags VTEPs
20       03:44:38:39:be:ef:aa:00:00:02  LR    10.10.10.2(EV)
20       03:44:38:39:be:ef:bb:00:00:02  R     10.10.10.3(EV),10.10.10.4(EV)
30       03:44:38:39:be:ef:aa:00:00:03  LR    10.10.10.2(EV)
30       03:44:38:39:be:ef:bb:00:00:03  R     10.10.10.3(EV),10.10.10.4(EV)
10       03:44:38:39:be:ef:aa:00:00:01  LR    10.10.10.2(EV)
10       03:44:38:39:be:ef:bb:00:00:01  R     10.10.10.3(EV),10.10.10.4(EV)
```
Verfify ESI to VRF information:
```bash
cumulus@leaf01:mgmt:~$ net show bgp l2vpn evpn es-vrf
ES-VRF Flags: A Active
ESI                            VRF             Flags IPv4-NHG IPv6-NHG Ref
03:44:38:39:be:ef:aa:00:00:01  RED             A     72580649 72580650 1
03:44:38:39:be:ef:aa:00:00:02  RED             A     72580645 72580646 1
03:44:38:39:be:ef:aa:00:00:03  BLUE            A     72580647 72580648 1
03:44:38:39:be:ef:bb:00:00:01  RED             A     72580651 72580652 1
03:44:38:39:be:ef:bb:00:00:02  RED             A     72580655 72580656 1
03:44:38:39:be:ef:bb:00:00:03  BLUE            A     72580653 72580654 1
```
Verify EVPN type-1 and type-4 routes learned:
```bash
cumulus@leaf01:mgmt:~$ net show bgp evpn route type ead
BGP table version is 15, local router ID is 10.10.10.1
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
*> [1]:[0]:[03:44:38:39:be:ef:aa:00:00:02]:[128]:[0.0.0.0]:[0] RD 10.10.10.1:4
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20
Route Distinguisher: 10.10.10.1:5
*> [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:01]:[128]:[0.0.0.0]:[0] RD 10.10.10.1:5
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 ESI-label-Rt:AA RT:65101:10
Route Distinguisher: 10.10.10.1:6
*> [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:02]:[128]:[0.0.0.0]:[0] RD 10.10.10.1:6
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 ESI-label-Rt:AA RT:65101:20
Route Distinguisher: 10.10.10.1:7
*> [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:03]:[128]:[0.0.0.0]:[0] RD 10.10.10.1:7
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 ESI-label-Rt:AA RT:65101:30
Route Distinguisher: 10.10.10.1:8
*> [1]:[0]:[03:44:38:39:be:ef:aa:00:00:03]:[128]:[0.0.0.0]:[0] RD 10.10.10.1:8
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30
Route Distinguisher: 10.10.10.1:9
*> [1]:[0]:[03:44:38:39:be:ef:aa:00:00:01]:[128]:[0.0.0.0]:[0] RD 10.10.10.1:9
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10
Route Distinguisher: 10.10.10.2:4
*  [1]:[0]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:4
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:20 ET:8
*> [1]:[0]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:4
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:20 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:4
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:20 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:4
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:20 ET:8
Route Distinguisher: 10.10.10.2:5
*  [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:5
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:10 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:5
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:10 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:5
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:10 ET:8 ESI-label-Rt:AA
*> [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:5
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:10 ET:8 ESI-label-Rt:AA
Route Distinguisher: 10.10.10.2:6
*  [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:6
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:20 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:6
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:20 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:6
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:20 ET:8 ESI-label-Rt:AA
*> [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:6
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:20 ET:8 ESI-label-Rt:AA
Route Distinguisher: 10.10.10.2:7
*  [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:7
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:30 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:7
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:30 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:7
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:30 ET:8 ESI-label-Rt:AA
*> [1]:[4294967295]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:7
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:30 ET:8 ESI-label-Rt:AA
Route Distinguisher: 10.10.10.2:8
*  [1]:[0]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:8
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:30 ET:8
*> [1]:[0]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:8
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:30 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:8
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:30 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:8
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:30 ET:8
Route Distinguisher: 10.10.10.2:9
*  [1]:[0]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:9
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:10 ET:8
*> [1]:[0]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:9
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:10 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:9
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:10 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.2:9
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:10 ET:8
Route Distinguisher: 10.10.10.3:4
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:4
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*> [1]:[0]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:4
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:4
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:4
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
Route Distinguisher: 10.10.10.3:5
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:5
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:5
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:5
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8 ESI-label-Rt:AA
*> [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:5
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8 ESI-label-Rt:AA
Route Distinguisher: 10.10.10.3:6
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:6
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:6
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:6
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8 ESI-label-Rt:AA
*> [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:6
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8 ESI-label-Rt:AA
Route Distinguisher: 10.10.10.3:7
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:7
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:7
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:7
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8 ESI-label-Rt:AA
*> [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:7
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8 ESI-label-Rt:AA
Route Distinguisher: 10.10.10.3:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:8
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*> [1]:[0]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:8
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:8
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:8
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
Route Distinguisher: 10.10.10.3:9
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:9
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*> [1]:[0]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:9
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:9
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.3:9
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
Route Distinguisher: 10.10.10.4:4
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:4
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*> [1]:[0]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:4
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:4
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:4
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
Route Distinguisher: 10.10.10.4:5
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:5
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:5
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:5
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8 ESI-label-Rt:AA
*> [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:5
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8 ESI-label-Rt:AA
Route Distinguisher: 10.10.10.4:6
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:6
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:6
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:6
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8 ESI-label-Rt:AA
*> [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:6
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8 ESI-label-Rt:AA
Route Distinguisher: 10.10.10.4:7
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:7
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:7
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8 ESI-label-Rt:AA
*  [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:7
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8 ESI-label-Rt:AA
*> [1]:[4294967295]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:7
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8 ESI-label-Rt:AA
Route Distinguisher: 10.10.10.4:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:8
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*> [1]:[0]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:8
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:8
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:8
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
Route Distinguisher: 10.10.10.4:9
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:9
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*> [1]:[0]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:9
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:9
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [1]:[0]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[0.0.0.0]:[0] RD 10.10.10.4:9
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8

Displayed 24 prefixes (78 paths) (of requested type)
```
```bash
cumulus@leaf01:mgmt:~$ net show bgp evpn route type es
BGP table version is 2, local router ID is 10.10.10.1
Status codes: s suppressed, d damped, h history, * valid, > best, i - internal
Origin codes: i - IGP, e - EGP, ? - incomplete
EVPN type-1 prefix: [1]:[ESI]:[EthTag]:[IPlen]:[VTEP-IP]:[Frag-id]
EVPN type-2 prefix: [2]:[EthTag]:[MAClen]:[MAC]:[IPlen]:[IP]
EVPN type-3 prefix: [3]:[EthTag]:[IPlen]:[OrigIP]
EVPN type-4 prefix: [4]:[ESI]:[IPlen]:[OrigIP]
EVPN type-5 prefix: [5]:[EthTag]:[IPlen]:[IP]

   Network          Next Hop            Metric LocPrf Weight Path
                    Extended Community
Route Distinguisher: 10.10.10.1:5
*> [4]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[10.10.10.1] RD 10.10.10.1:5
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 50000)
Route Distinguisher: 10.10.10.1:6
*> [4]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[10.10.10.1] RD 10.10.10.1:6
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 50000)
Route Distinguisher: 10.10.10.1:7
*> [4]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[10.10.10.1] RD 10.10.10.1:7
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 50000)
Route Distinguisher: 10.10.10.2:5
*  [4]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[10.10.10.2] RD 10.10.10.2:5
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 32767)
*  [4]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[10.10.10.2] RD 10.10.10.2:5
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 32767)
*  [4]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[10.10.10.2] RD 10.10.10.2:5
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 32767)
*> [4]:[03:44:38:39:be:ef:aa:00:00:01]:[32]:[10.10.10.2] RD 10.10.10.2:5
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 32767)
Route Distinguisher: 10.10.10.2:6
*  [4]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[10.10.10.2] RD 10.10.10.2:6
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 32767)
*  [4]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[10.10.10.2] RD 10.10.10.2:6
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 32767)
*  [4]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[10.10.10.2] RD 10.10.10.2:6
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 32767)
*> [4]:[03:44:38:39:be:ef:aa:00:00:02]:[32]:[10.10.10.2] RD 10.10.10.2:6
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 32767)
Route Distinguisher: 10.10.10.2:7
*  [4]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[10.10.10.2] RD 10.10.10.2:7
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 32767)
*  [4]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[10.10.10.2] RD 10.10.10.2:7
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 32767)
*  [4]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[10.10.10.2] RD 10.10.10.2:7
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 32767)
*> [4]:[03:44:38:39:be:ef:aa:00:00:03]:[32]:[10.10.10.2] RD 10.10.10.2:7
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:aa DF: (alg: 2, pref: 32767)
Route Distinguisher: 10.10.10.3:5
*  [4]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[10.10.10.3] RD 10.10.10.3:5
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 50000)
*  [4]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[10.10.10.3] RD 10.10.10.3:5
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 50000)
*  [4]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[10.10.10.3] RD 10.10.10.3:5
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 50000)
*> [4]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[10.10.10.3] RD 10.10.10.3:5
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 50000)
Route Distinguisher: 10.10.10.3:6
*  [4]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[10.10.10.3] RD 10.10.10.3:6
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 50000)
*  [4]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[10.10.10.3] RD 10.10.10.3:6
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 50000)
*  [4]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[10.10.10.3] RD 10.10.10.3:6
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 50000)
*> [4]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[10.10.10.3] RD 10.10.10.3:6
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 50000)
Route Distinguisher: 10.10.10.3:7
*  [4]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[10.10.10.3] RD 10.10.10.3:7
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 50000)
*  [4]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[10.10.10.3] RD 10.10.10.3:7
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 50000)
*  [4]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[10.10.10.3] RD 10.10.10.3:7
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 50000)
*> [4]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[10.10.10.3] RD 10.10.10.3:7
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 50000)
Route Distinguisher: 10.10.10.4:5
*  [4]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[10.10.10.4] RD 10.10.10.4:5
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 32767)
*  [4]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[10.10.10.4] RD 10.10.10.4:5
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 32767)
*  [4]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[10.10.10.4] RD 10.10.10.4:5
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 32767)
*> [4]:[03:44:38:39:be:ef:bb:00:00:01]:[32]:[10.10.10.4] RD 10.10.10.4:5
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 32767)
Route Distinguisher: 10.10.10.4:6
*  [4]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[10.10.10.4] RD 10.10.10.4:6
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 32767)
*  [4]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[10.10.10.4] RD 10.10.10.4:6
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 32767)
*  [4]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[10.10.10.4] RD 10.10.10.4:6
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 32767)
*> [4]:[03:44:38:39:be:ef:bb:00:00:02]:[32]:[10.10.10.4] RD 10.10.10.4:6
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 32767)
Route Distinguisher: 10.10.10.4:7
*  [4]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[10.10.10.4] RD 10.10.10.4:7
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 32767)
*  [4]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[10.10.10.4] RD 10.10.10.4:7
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 32767)
*  [4]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[10.10.10.4] RD 10.10.10.4:7
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 32767)
*> [4]:[03:44:38:39:be:ef:bb:00:00:03]:[32]:[10.10.10.4] RD 10.10.10.4:7
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ET:8 ES-Import-Rt:44:38:39:be:ef:bb DF: (alg: 2, pref: 32767)

Displayed 12 prefixes (39 paths) (of requested type)
```
<!-- AIR:page -->

#### PIM

Verify PIm state:
```bash
cumulus@leaf01:mgmt:~$ net show pim state
Codes: J -> Pim Join, I -> IGMP Report, S -> Source, * -> Inherited from (*,G), V -> VxLAN, M -> Muted
Active Source           Group            RPT  IIF               OIL
1      *                224.1.1.10       y    swp52             pimreg(I    ), ipmr-lo(     )
1      10.10.10.1       224.1.1.10       n    lo                ipmr-lo(   *M), swp52( J   )
1      10.10.10.2       224.1.1.10       n    swp51             ipmr-lo(   * )
1      10.10.10.3       224.1.1.10       n    swp52             ipmr-lo(   * )
1      10.10.10.4       224.1.1.10       n    swp52             ipmr-lo(   * )
1      *                224.1.1.20       y    swp51             pimreg(I    ), ipmr-lo(     )
1      10.10.10.1       224.1.1.20       n    lo                ipmr-lo(   *M), swp52( J   )
1      10.10.10.2       224.1.1.20       n    swp51             ipmr-lo(   * )
1      10.10.10.3       224.1.1.20       n    swp54             ipmr-lo(   * )
1      10.10.10.4       224.1.1.20       n    swp54             ipmr-lo(   * )
1      *                224.1.1.30       y    swp54             pimreg(I    ), ipmr-lo(     )
1      10.10.10.1       224.1.1.30       n    lo                ipmr-lo(   *M), swp51( J   )
1      10.10.10.2       224.1.1.30       n    swp51             ipmr-lo(   * )
1      10.10.10.3       224.1.1.30       n    swp53             ipmr-lo(   * )
1      10.10.10.4       224.1.1.30       n    swp54             ipmr-lo(   * )
```
Verify PIM multicast routing table:
```bash
cumulus@leaf01:mgmt:~$ net show mroute
IP Multicast Routing Table
Flags: S - Sparse, C - Connected, P - Pruned
       R - RP-bit set, F - Register flag, T - SPT-bit set

Source          Group           Flags    Proto  Input            Output           TTL  Uptime
*               224.1.1.10      S        IGMP   swp52            pimreg           1    00:15:24
                                                                 ipmr-lo          1
10.10.10.1      224.1.1.10      SFT      PIM    lo               swp52            1    00:15:24
10.10.10.2      224.1.1.10      ST       STAR   swp51            ipmr-lo          1    00:14:09
10.10.10.3      224.1.1.10      ST       STAR   swp52            ipmr-lo          1    00:15:23
10.10.10.4      224.1.1.10      ST       STAR   swp52            ipmr-lo          1    00:14:09
*               224.1.1.20      S        IGMP   swp51            pimreg           1    00:15:24
                                                                 ipmr-lo          1
10.10.10.1      224.1.1.20      SFT      PIM    lo               swp52            1    00:15:24
10.10.10.2      224.1.1.20      ST       STAR   swp51            ipmr-lo          1    00:15:23
10.10.10.3      224.1.1.20      ST       STAR   swp54            ipmr-lo          1    00:15:23
10.10.10.4      224.1.1.20      ST       STAR   swp54            ipmr-lo          1    00:14:09
*               224.1.1.30      S        IGMP   swp54            pimreg           1    00:15:24
                                                                 ipmr-lo          1
10.10.10.1      224.1.1.30      SFT      PIM    lo               swp51            1    00:15:24
10.10.10.2      224.1.1.30      ST       STAR   swp51            ipmr-lo          1    00:14:09
10.10.10.3      224.1.1.30      ST       STAR   swp53            ipmr-lo          1    00:15:23
10.10.10.4      224.1.1.30      ST       STAR   swp54            ipmr-lo          1    00:14:09
```
Verify all PIM interfaces:
```bash
cumulus@leaf01:mgmt:~$ net show pim interface
Interface         State          Address  PIM Nbrs           PIM DR  FHR IfChannels
ipmr-lo              up       10.10.10.1         0            local    0          3
lo                   up       10.10.10.1         0            local    0          0
pimreg               up          0.0.0.0         0            local    0          0
swp51                up       10.10.10.1         1     10.10.10.101    0          1
swp52                up       10.10.10.1         1     10.10.10.102    0          2
swp53                up       10.10.10.1         1     10.10.10.103    0          0
swp54                up       10.10.10.1         1     10.10.10.104    0          0
```
Check the active multicast source interface on the switch:
```bash
cumulus@leaf01:mgmt:~$ net show pim upstream
Iif             Source          Group           State       Uptime   JoinTimer RSTimer   KATimer   RefCnt
swp52           *               224.1.1.10      J           00:16:54 00:00:14  --:--:--  --:--:--       2
lo              10.10.10.1      224.1.1.10      J,RegP      00:16:54 --:--:--  00:00:23  00:59:57       3
swp51           10.10.10.2      224.1.1.10      J           00:15:39 00:00:14  --:--:--  00:59:32       2
swp52           10.10.10.3      224.1.1.10      J           00:16:53 00:00:14  --:--:--  00:59:58       2
swp52           10.10.10.4      224.1.1.10      J           00:15:39 00:00:14  --:--:--  00:59:33       2
swp51           *               224.1.1.20      J           00:16:54 00:00:14  --:--:--  --:--:--       2
lo              10.10.10.1      224.1.1.20      J,RegP      00:16:54 --:--:--  00:00:00  00:59:39       3
swp51           10.10.10.2      224.1.1.20      J           00:16:53 00:00:14  --:--:--  00:59:32       2
swp54           10.10.10.3      224.1.1.20      J           00:16:53 00:00:14  --:--:--  00:59:59       2
swp54           10.10.10.4      224.1.1.20      J           00:15:39 00:00:14  --:--:--  00:59:46       2
swp54           *               224.1.1.30      J           00:16:54 00:00:14  --:--:--  --:--:--       2
lo              10.10.10.1      224.1.1.30      J,RegP      00:16:54 --:--:--  00:00:10  00:59:39       3
swp51           10.10.10.2      224.1.1.30      J           00:15:39 00:00:14  --:--:--  00:59:44       2
swp53           10.10.10.3      224.1.1.30      J           00:16:53 00:00:14  --:--:--  00:59:51       2
swp54           10.10.10.4      224.1.1.30      J           00:15:39 00:00:14  --:--:--  00:59:30       2
``` 
Verfiy the MSDP session state on the RP:
```bash
cumulus@border01:mgmt:~$ net show msdp mesh-group
Mesh group : rpmesh
  Source : 10.10.10.63
  Member                 State
  10.10.10.64      established
```
Verify border leaves set as PIM RP:
```bash
cumulus@leaf01:mgmt:~$ net show pim rp-info
RP address       group/prefix-list   OIF               I am RP    Source
10.10.100.100    224.1.1.0/24        swp52             no        Static
```
```bash
cumulus@border01:mgmt:~$ net show pim rp-info
RP address       group/prefix-list   OIF               I am RP    Source
10.10.100.100    224.1.1.0/24        lo                yes        Static
```

For more information about PIM, show commands and troubleshooting, check out PIM [documentation](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/Layer-3/Protocol-Independent-Multicast-PIM/#troubleshooting). 

<!-- AIR:page -->

#### VXLAN and BGP-EVPN

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
  shared-address          none         none        shared anycast address for MLAG peers
source
  address                 10.10.10.1   10.10.10.1  IP addresses of this node's VTEP or 'auto'.  If 'auto', use the pri...
```

Verify BGP peerings (IPv4 and EVPN AF):
```bash
cumulus@leaf01:mgmt:~$ net show bgp summary
show bgp ipv4 unicast summary
=============================
BGP router identifier 10.10.10.1, local AS number 65101 vrf-id 0
BGP table version 11
RIB entries 21, using 4200 bytes of memory
Peers 4, using 91 KiB of memory
Peer groups 1, using 64 bytes of memory

Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt
spine01(swp51)  4      65100       805       830        0    0    0 00:31:06            8       11
spine02(swp52)  4      65100       805       830        0    0    0 00:31:06            8       11
spine03(swp53)  4      65100       805       830        0    0    0 00:31:06            8       11
spine04(swp54)  4      65100       805       830        0    0    0 00:31:06            8       11

Total number of neighbors 4


show bgp ipv6 unicast summary
=============================
% No BGP neighbors found


show bgp l2vpn evpn summary
===========================
BGP router identifier 10.10.10.1, local AS number 65101 vrf-id 0
BGP table version 0
RIB entries 47, using 9400 bytes of memory
Peers 4, using 91 KiB of memory
Peer groups 1, using 64 bytes of memory

Neighbor        V         AS   MsgRcvd   MsgSent   TblVer  InQ OutQ  Up/Down State/PfxRcd   PfxSnt
spine01(swp51)  4      65100       926       944        0    0    0 00:35:06          108      144
spine02(swp52)  4      65100       912       944        0    0    0 00:35:06          108      144
spine03(swp53)  4      65100       926       944        0    0    0 00:35:06          108      144
spine04(swp54)  4      65100       931       944        0    0    0 00:35:06          108      144

Total number of neighbors 4
```
Verify EVPN VNI entries:
```bash
cumulus@leaf01:mgmt:~$ net show evpn vni
VNI        Type VxLAN IF              # MACs   # ARPs   # Remote VTEPs  Tenant VRF
10         L2   vxlan48               12       12       3               RED
30         L2   vxlan48               12       12       3               BLUE
20         L2   vxlan48               12       12       3               RED
4001       L3   vxlan99               3        3        n/a             RED
4002       L3   vxlan99               3        3        n/a             BLUE
```
```bash
cumulus@leaf01:mgmt:~$ net show bgp evpn vni
Advertise Gateway Macip: Disabled
Advertise SVI Macip: Enabled
Advertise All VNI flag: Enabled
BUM flooding: Head-end replication
Number of L2 VNIs: 3
Number of L3 VNIs: 2
Flags: * - Kernel
  VNI        Type RD                    Import RT                 Export RT                 Tenant VRF
* 20         L2   10.10.10.1:4          65101:20                  65101:20                 RED
* 30         L2   10.10.10.1:8          65101:30                  65101:30                 BLUE
* 10         L2   10.10.10.1:9          65101:10                  65101:10                 RED
* 4001       L3   10.10.10.1:2          65101:4001                65101:4001               RED
* 4002       L3   10.10.10.1:3          65101:4002                65101:4002               BLUE
```

Verify MAC entries are being learned on bridge `br_default`:
```bash
cumulus@leaf01:mgmt:~$ nv show bridge domain br_default mac-table
      age   bridge-domain  entry-type  interface   last-update  mac                src-vni  vlan  vni   Summary
----  ----  -------------  ----------  ----------  -----------  -----------------  -------  ----  ----  ----------------------
+ 0   1351  br_default     static      bond3       2403         44:38:39:00:00:31           30
+ 1   2695  br_default     static      bond3       2695         46:38:39:00:00:33           30
+ 10  560   br_default                 vxlan48     560          44:38:39:00:00:80           20    None  remote-dst: 10.10.10.4
+ 11  560   br_default                 vxlan48     560          44:38:39:00:00:39           20    None
+ 12  560   br_default                 vxlan48     560          46:38:39:00:00:39           20    None
+ 13  560   br_default                 vxlan48     560          44:38:39:00:00:3b           20    None
+ 14  560   br_default                 vxlan48     560          46:38:39:00:00:3b           20    None
+ 15  560   br_default                 vxlan48     560          44:38:39:00:00:7e           20    None  remote-dst: 10.10.10.3
+ 16  560   br_default                 vxlan48     560          44:38:39:00:00:35           10    None
+ 17  560   br_default                 vxlan48     560          46:38:39:00:00:35           10    None
+ 18  560   br_default                 vxlan48     560          44:38:39:00:00:37           10    None
+ 19  560   br_default                 vxlan48     560          46:38:39:00:00:37           10    None
+ 2   21    br_default     static      bond3       2720         46:38:39:00:00:31           30
+ 20  560   br_default                 vxlan48     560          44:38:39:00:00:3d           30    None
+ 21  560   br_default                 vxlan48     560          46:38:39:00:00:3d           30    None
+ 22  560   br_default                 vxlan48     560          44:38:39:00:00:3f           30    None
+ 23  560   br_default                 vxlan48     560          46:38:39:00:00:3f           30    None
+ 24  560   br_default                 vxlan48     87           44:38:39:00:00:7c           20    None  remote-dst: 10.10.10.2
+ 25  2917  br_default     permanent   vxlan48     2917         3e:c0:f7:da:79:19                 None
+ 26  2917                 permanent   vxlan48     896          00:00:00:00:00:00  20             None  remote-dst: 224.1.1.10
  26                                                                                                    remote-dst: 224.1.1.20
  26                                                                                                    remote-dst: 224.1.1.30
+ 27  1351  br_default     static      bond2       2403         44:38:39:00:00:29           20
+ 28  2695  br_default     static      bond2       2695         46:38:39:00:00:2b           20
+ 29  73    br_default     static      bond2       2712         44:38:39:00:00:2b           20
+ 3   56    br_default     static      bond3       862          44:38:39:00:00:33           30
+ 30  21    br_default     static      bond2       2720         46:38:39:00:00:29           20
+ 31  2917  br_default     permanent   bond2       2917         44:38:39:00:00:2a
+ 32                       permanent   br_default               00:00:00:00:00:10
+ 33                       permanent   br_default               00:00:00:00:00:20
+ 34                       permanent   br_default               00:00:00:00:00:30
+ 35  2916  br_default     permanent   br_default  2916         44:38:39:00:00:7a           30
+ 4   2917  br_default     permanent   bond3       2917         44:38:39:00:00:32
+ 5   1351  br_default     static      bond1       2403         44:38:39:00:00:2f           10
+ 6   2695  br_default     static      bond1       2695         46:38:39:00:00:2d           10
+ 7   21    br_default     static      bond1       2694         46:38:39:00:00:2f           10
+ 8   90    br_default     static      bond1       899          44:38:39:00:00:2d           10
+ 9   2917  br_default     permanent   bond1       2917         44:38:39:00:00:30
```
Verify that `zero MAC` address is present for each L2-VNI and pointing to its BUM flooding multicast group:
```bash
cumulus@leaf01:mgmt:~$ bridge fdb show | grep 00:00:00:00:00:00
00:00:00:00:00:00 dev vxlan48 dst 224.1.1.20 vni 20 src_vni 20 via lo self permanent
00:00:00:00:00:00 dev vxlan48 dst 224.1.1.10 vni 10 src_vni 10 via lo self permanent
00:00:00:00:00:00 dev vxlan48 dst 224.1.1.30 vni 30 src_vni 30 via lo self permanent
```
Verify neighbor (ARP) entries are being learned (you can also use `arp -n` command as well):
```bash
cumulus@leaf01:mgmt:~$ ip neigh show
10.10.10.4 dev vlan220_l3 lladdr 44:38:39:00:00:80 extern_learn  NOARP proto zebra
169.254.0.1 dev swp51 lladdr 44:38:39:00:00:0a PERMANENT proto zebra
10.1.20.5 dev vlan20 lladdr 44:38:39:00:00:80 extern_learn  NOARP proto zebra
10.1.10.5 dev vlan10 lladdr 44:38:39:00:00:80 extern_learn  NOARP proto zebra
10.10.10.3 dev vlan297_l3 lladdr 44:38:39:00:00:7e extern_learn  NOARP proto zebra
10.1.30.103 dev vlan30 lladdr 44:38:39:00:00:33 REACHABLE proto zebra
10.10.10.4 dev vlan297_l3 lladdr 44:38:39:00:00:80 extern_learn  NOARP proto zebra
10.1.30.4 dev vlan30 lladdr 44:38:39:00:00:7e extern_learn  NOARP proto zebra
169.254.0.1 dev swp54 lladdr 44:38:39:00:00:10 PERMANENT proto zebra
10.1.30.3 dev vlan30 lladdr 44:38:39:00:00:7c extern_learn  NOARP proto zebra
10.10.10.2 dev vxlan99 lladdr 44:38:39:00:00:7c extern_learn  NOARP proto zebra
10.1.20.4 dev vlan20 lladdr 44:38:39:00:00:7e extern_learn  NOARP proto zebra
10.1.20.3 dev vlan20 lladdr 44:38:39:00:00:7c extern_learn  NOARP proto zebra
10.1.10.104 dev vlan10 lladdr 44:38:39:00:00:37 extern_learn  NOARP proto zebra
169.254.0.1 dev swp53 lladdr 44:38:39:00:00:0e PERMANENT proto zebra
192.168.200.1 dev eth0 lladdr 44:38:39:00:00:66 REACHABLE
10.10.10.3 dev vxlan99 lladdr 44:38:39:00:00:7e extern_learn  NOARP proto zebra
10.10.10.2 dev vlan220_l3 lladdr 44:38:39:00:00:7c extern_learn  NOARP proto zebra
10.10.10.4 dev vxlan99 lladdr 44:38:39:00:00:80 extern_learn  NOARP proto zebra
10.1.20.102 dev vlan20 lladdr 44:38:39:00:00:2b REACHABLE proto zebra
192.168.200.250 dev eth0 lladdr 44:38:39:00:00:90 REACHABLE
10.1.10.3 dev vlan10 lladdr 44:38:39:00:00:7c extern_learn  NOARP proto zebra
10.1.10.4 dev vlan10 lladdr 44:38:39:00:00:7e extern_learn  NOARP proto zebra
169.254.0.1 dev swp52 lladdr 44:38:39:00:00:0c PERMANENT proto zebra
10.1.20.105 dev vlan20 lladdr 44:38:39:00:00:3b extern_learn  NOARP proto zebra
10.1.30.106 dev vlan30 lladdr 44:38:39:00:00:3f extern_learn  NOARP proto zebra
10.10.10.2 dev vlan297_l3 lladdr 44:38:39:00:00:7c extern_learn  NOARP proto zebra
10.1.30.5 dev vlan30 lladdr 44:38:39:00:00:80 extern_learn  NOARP proto zebra
10.1.10.101 dev vlan10 lladdr 44:38:39:00:00:2d REACHABLE proto zebra
10.10.10.3 dev vlan220_l3 lladdr 44:38:39:00:00:7e extern_learn  NOARP proto zebra
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
K>* 0.0.0.0/0 [255/8192] unreachable (ICMP unreachable), 00:33:47
C * 10.1.10.0/24 [0/1024] is directly connected, vlan10-v0, 00:33:47
C>* 10.1.10.0/24 is directly connected, vlan10, 00:33:47
B>* 10.1.10.3/32 [20/0] via 10.10.10.2, vlan220_l3 onlink, weight 1, 00:33:43
B>* 10.1.10.4/32 [20/0] via 10.10.10.3, vlan220_l3 onlink, weight 1, 00:33:42
B>* 10.1.10.5/32 [20/0] via 10.10.10.4, vlan220_l3 onlink, weight 1, 00:33:42
B>* 10.1.10.104/32 [20/0] via 10.10.10.3, vlan220_l3 onlink, weight 1, 00:11:48
  *                       via 10.10.10.4, vlan220_l3 onlink, weight 1, 00:11:48
C * 10.1.20.0/24 [0/1024] is directly connected, vlan20-v0, 00:33:47
C>* 10.1.20.0/24 is directly connected, vlan20, 00:33:47
B>* 10.1.20.3/32 [20/0] via 10.10.10.2, vlan220_l3 onlink, weight 1, 00:33:43
B>* 10.1.20.4/32 [20/0] via 10.10.10.3, vlan220_l3 onlink, weight 1, 00:33:42
B>* 10.1.20.5/32 [20/0] via 10.10.10.4, vlan220_l3 onlink, weight 1, 00:33:42
B>* 10.1.20.105/32 [20/0] via 10.10.10.3, vlan220_l3 onlink, weight 1, 00:11:37
  *                       via 10.10.10.4, vlan220_l3 onlink, weight 1, 00:11:37
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
K>* 0.0.0.0/0 [255/8192] unreachable (ICMP unreachable), 00:34:13
C * 10.1.30.0/24 [0/1024] is directly connected, vlan30-v0, 00:34:13
C>* 10.1.30.0/24 is directly connected, vlan30, 00:34:13
B>* 10.1.30.3/32 [20/0] via 10.10.10.2, vlan297_l3 onlink, weight 1, 00:34:10
B>* 10.1.30.4/32 [20/0] via 10.10.10.3, vlan297_l3 onlink, weight 1, 00:34:09
B>* 10.1.30.5/32 [20/0] via 10.10.10.4, vlan297_l3 onlink, weight 1, 00:34:09
B>* 10.1.30.106/32 [20/0] via 10.10.10.3, vlan297_l3 onlink, weight 1, 00:11:27
  *                       via 10.10.10.4, vlan297_l3 onlink, weight 1, 00:11:27
...
```

Verify that MAC address of gateway is being populated into EVPN:
```bash
cumulus@leaf01:mgmt:~$ net show bgp l2vpn evpn route type 2
BGP table version is 15, local router ID is 10.10.10.1
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
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:2b] RD 10.10.10.1:4
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:2b]:[32]:[10.1.20.102] RD 10.10.10.1:4
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:2b]:[128]:[fe80::4638:39ff:fe00:2b] RD 10.10.10.1:4
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    ET:8 RT:65101:20
*> [2]:[0]:[48]:[44:38:39:00:00:7a] RD 10.10.10.1:4
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:7a]:[32]:[10.1.20.2] RD 10.10.10.1:4
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:7a]:[128]:[fe80::4638:39ff:fe00:7a] RD 10.10.10.1:4
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:20
*> [2]:[0]:[48]:[46:38:39:00:00:29] RD 10.10.10.1:4
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[46:38:39:00:00:2b] RD 10.10.10.1:4
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    ET:8 RT:65101:20 RT:65101:4001 Rmac:44:38:39:00:00:7a ND:Proxy
Route Distinguisher: 10.10.10.1:8
*> [2]:[0]:[48]:[44:38:39:00:00:31] RD 10.10.10.1:8
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:33] RD 10.10.10.1:8
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:33]:[32]:[10.1.30.103] RD 10.10.10.1:8
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:33]:[128]:[fe80::4638:39ff:fe00:33] RD 10.10.10.1:8
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    ET:8 RT:65101:30
*> [2]:[0]:[48]:[44:38:39:00:00:7a] RD 10.10.10.1:8
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:7a]:[32]:[10.1.30.2] RD 10.10.10.1:8
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:7a]:[128]:[fe80::4638:39ff:fe00:7a] RD 10.10.10.1:8
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:30
*> [2]:[0]:[48]:[46:38:39:00:00:31] RD 10.10.10.1:8
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[46:38:39:00:00:33] RD 10.10.10.1:8
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    ET:8 RT:65101:30 RT:65101:4002 Rmac:44:38:39:00:00:7a ND:Proxy
Route Distinguisher: 10.10.10.1:9
*> [2]:[0]:[48]:[44:38:39:00:00:2d] RD 10.10.10.1:9
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:2d]:[32]:[10.1.10.101] RD 10.10.10.1:9
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:2d]:[128]:[fe80::4638:39ff:fe00:2d] RD 10.10.10.1:9
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    ET:8 RT:65101:10
*> [2]:[0]:[48]:[44:38:39:00:00:2f] RD 10.10.10.1:9
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:7a] RD 10.10.10.1:9
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:7a]:[32]:[10.1.10.2] RD 10.10.10.1:9
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:00:00:7a
*> [2]:[0]:[48]:[44:38:39:00:00:7a]:[128]:[fe80::4638:39ff:fe00:7a] RD 10.10.10.1:9
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ET:8 RT:65101:10
*> [2]:[0]:[48]:[46:38:39:00:00:2d] RD 10.10.10.1:9
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:00:00:7a ND:Proxy
*> [2]:[0]:[48]:[46:38:39:00:00:2f] RD 10.10.10.1:9
                    10.10.10.1 (leaf01)
                                                       32768 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    ET:8 RT:65101:10 RT:65101:4001 Rmac:44:38:39:00:00:7a
Route Distinguisher: 10.10.10.2:4
*  [2]:[0]:[48]:[44:38:39:00:00:29] RD 10.10.10.2:4
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:29] RD 10.10.10.2:4
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:29] RD 10.10.10.2:4
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:29] RD 10.10.10.2:4
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2b] RD 10.10.10.2:4
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:2b] RD 10.10.10.2:4
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2b] RD 10.10.10.2:4
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2b] RD 10.10.10.2:4
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:2b]:[32]:[10.1.20.102] RD 10.10.10.2:4
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2b]:[32]:[10.1.20.102] RD 10.10.10.2:4
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2b]:[32]:[10.1.20.102] RD 10.10.10.2:4
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2b]:[32]:[10.1.20.102] RD 10.10.10.2:4
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:2b]:[128]:[fe80::4638:39ff:fe00:2b] RD 10.10.10.2:4
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:2b]:[128]:[fe80::4638:39ff:fe00:2b] RD 10.10.10.2:4
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:2b]:[128]:[fe80::4638:39ff:fe00:2b] RD 10.10.10.2:4
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:2b]:[128]:[fe80::4638:39ff:fe00:2b] RD 10.10.10.2:4
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.2:4
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.2:4
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.2:4
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.2:4
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[32]:[10.1.20.3] RD 10.10.10.2:4
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[32]:[10.1.20.3] RD 10.10.10.2:4
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:7c]:[32]:[10.1.20.3] RD 10.10.10.2:4
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[32]:[10.1.20.3] RD 10.10.10.2:4
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[128]:[fe80::4638:39ff:fe00:7c] RD 10.10.10.2:4
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[128]:[fe80::4638:39ff:fe00:7c] RD 10.10.10.2:4
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:20 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:7c]:[128]:[fe80::4638:39ff:fe00:7c] RD 10.10.10.2:4
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[128]:[fe80::4638:39ff:fe00:7c] RD 10.10.10.2:4
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:20 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:29] RD 10.10.10.2:4
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:29] RD 10.10.10.2:4
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:29] RD 10.10.10.2:4
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:29] RD 10.10.10.2:4
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c ND:Proxy
*> [2]:[0]:[48]:[46:38:39:00:00:2b] RD 10.10.10.2:4
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[46:38:39:00:00:2b] RD 10.10.10.2:4
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[46:38:39:00:00:2b] RD 10.10.10.2:4
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[46:38:39:00:00:2b] RD 10.10.10.2:4
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:02
                    RT:65102:20 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
Route Distinguisher: 10.10.10.2:8
*  [2]:[0]:[48]:[44:38:39:00:00:31] RD 10.10.10.2:8
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:31] RD 10.10.10.2:8
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:31] RD 10.10.10.2:8
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:31] RD 10.10.10.2:8
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:33] RD 10.10.10.2:8
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:33] RD 10.10.10.2:8
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:33] RD 10.10.10.2:8
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:33] RD 10.10.10.2:8
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:33]:[32]:[10.1.30.103] RD 10.10.10.2:8
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:33]:[32]:[10.1.30.103] RD 10.10.10.2:8
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:33]:[32]:[10.1.30.103] RD 10.10.10.2:8
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:33]:[32]:[10.1.30.103] RD 10.10.10.2:8
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:33]:[128]:[fe80::4638:39ff:fe00:33] RD 10.10.10.2:8
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:33]:[128]:[fe80::4638:39ff:fe00:33] RD 10.10.10.2:8
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:33]:[128]:[fe80::4638:39ff:fe00:33] RD 10.10.10.2:8
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:33]:[128]:[fe80::4638:39ff:fe00:33] RD 10.10.10.2:8
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.2:8
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.2:8
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.2:8
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.2:8
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[32]:[10.1.30.3] RD 10.10.10.2:8
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[32]:[10.1.30.3] RD 10.10.10.2:8
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:7c]:[32]:[10.1.30.3] RD 10.10.10.2:8
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[32]:[10.1.30.3] RD 10.10.10.2:8
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[128]:[fe80::4638:39ff:fe00:7c] RD 10.10.10.2:8
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[128]:[fe80::4638:39ff:fe00:7c] RD 10.10.10.2:8
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:30 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:7c]:[128]:[fe80::4638:39ff:fe00:7c] RD 10.10.10.2:8
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[128]:[fe80::4638:39ff:fe00:7c] RD 10.10.10.2:8
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:30 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:31] RD 10.10.10.2:8
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:31] RD 10.10.10.2:8
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:31] RD 10.10.10.2:8
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:31] RD 10.10.10.2:8
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c ND:Proxy
*> [2]:[0]:[48]:[46:38:39:00:00:33] RD 10.10.10.2:8
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[46:38:39:00:00:33] RD 10.10.10.2:8
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[46:38:39:00:00:33] RD 10.10.10.2:8
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[46:38:39:00:00:33] RD 10.10.10.2:8
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:03
                    RT:65102:30 RT:65102:4002 ET:8 Rmac:44:38:39:00:00:7c
Route Distinguisher: 10.10.10.2:9
*> [2]:[0]:[48]:[44:38:39:00:00:2d] RD 10.10.10.2:9
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2d] RD 10.10.10.2:9
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2d] RD 10.10.10.2:9
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2d] RD 10.10.10.2:9
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2d]:[32]:[10.1.10.101] RD 10.10.10.2:9
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:2d]:[32]:[10.1.10.101] RD 10.10.10.2:9
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2d]:[32]:[10.1.10.101] RD 10.10.10.2:9
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2d]:[32]:[10.1.10.101] RD 10.10.10.2:9
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:2d]:[128]:[fe80::4638:39ff:fe00:2d] RD 10.10.10.2:9
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:2d]:[128]:[fe80::4638:39ff:fe00:2d] RD 10.10.10.2:9
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:2d]:[128]:[fe80::4638:39ff:fe00:2d] RD 10.10.10.2:9
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:2d]:[128]:[fe80::4638:39ff:fe00:2d] RD 10.10.10.2:9
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:2f] RD 10.10.10.2:9
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:2f] RD 10.10.10.2:9
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2f] RD 10.10.10.2:9
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:2f] RD 10.10.10.2:9
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.2:9
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.2:9
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.2:9
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c] RD 10.10.10.2:9
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[32]:[10.1.10.3] RD 10.10.10.2:9
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[32]:[10.1.10.3] RD 10.10.10.2:9
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[44:38:39:00:00:7c]:[32]:[10.1.10.3] RD 10.10.10.2:9
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[32]:[10.1.10.3] RD 10.10.10.2:9
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[128]:[fe80::4638:39ff:fe00:7c] RD 10.10.10.2:9
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    RT:65102:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[128]:[fe80::4638:39ff:fe00:7c] RD 10.10.10.2:9
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    RT:65102:10 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:7c]:[128]:[fe80::4638:39ff:fe00:7c] RD 10.10.10.2:9
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    RT:65102:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7c]:[128]:[fe80::4638:39ff:fe00:7c] RD 10.10.10.2:9
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    RT:65102:10 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:2d] RD 10.10.10.2:9
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[46:38:39:00:00:2d] RD 10.10.10.2:9
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[46:38:39:00:00:2d] RD 10.10.10.2:9
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*  [2]:[0]:[48]:[46:38:39:00:00:2d] RD 10.10.10.2:9
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c
*> [2]:[0]:[48]:[46:38:39:00:00:2f] RD 10.10.10.2:9
                    10.10.10.2 (spine01)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:2f] RD 10.10.10.2:9
                    10.10.10.2 (spine04)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:2f] RD 10.10.10.2:9
                    10.10.10.2 (spine02)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:2f] RD 10.10.10.2:9
                    10.10.10.2 (spine03)
                                                           0 65100 65102 i
                    ESI:03:44:38:39:be:ef:aa:00:00:01
                    RT:65102:10 RT:65102:4001 ET:8 Rmac:44:38:39:00:00:7c ND:Proxy
Route Distinguisher: 10.10.10.3:4
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.3:4
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.3:4
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.3:4
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.3:4
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:4
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:4
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:4
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.3:4
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.3:4
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.3:4
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.3:4
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.3:4
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.3:4
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.3:4
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.3:4
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.3:4
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.3:4
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.3:4
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.3:4
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.3:4
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[32]:[10.1.20.4] RD 10.10.10.3:4
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[32]:[10.1.20.4] RD 10.10.10.3:4
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[32]:[10.1.20.4] RD 10.10.10.3:4
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:7e]:[32]:[10.1.20.4] RD 10.10.10.3:4
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[128]:[fe80::4638:39ff:fe00:7e] RD 10.10.10.3:4
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[128]:[fe80::4638:39ff:fe00:7e] RD 10.10.10.3:4
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[128]:[fe80::4638:39ff:fe00:7e] RD 10.10.10.3:4
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:7e]:[128]:[fe80::4638:39ff:fe00:7e] RD 10.10.10.3:4
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:20 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:4
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:4
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:4
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.3:4
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.3:4
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.3:4
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.3:4
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e ND:Proxy
*> [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.3:4
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65103:20 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e ND:Proxy
Route Distinguisher: 10.10.10.3:8
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.3:8
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.3:8
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.3:8
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.3:8
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:8
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:8
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:8
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.3:8
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.3:8
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.3:8
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.3:8
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.3:8
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.3:8
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.3:8
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.3:8
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.3:8
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.3:8
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.3:8
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.3:8
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.3:8
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[32]:[10.1.30.4] RD 10.10.10.3:8
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[32]:[10.1.30.4] RD 10.10.10.3:8
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[32]:[10.1.30.4] RD 10.10.10.3:8
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:7e]:[32]:[10.1.30.4] RD 10.10.10.3:8
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[128]:[fe80::4638:39ff:fe00:7e] RD 10.10.10.3:8
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[128]:[fe80::4638:39ff:fe00:7e] RD 10.10.10.3:8
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[128]:[fe80::4638:39ff:fe00:7e] RD 10.10.10.3:8
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:7e]:[128]:[fe80::4638:39ff:fe00:7e] RD 10.10.10.3:8
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:30 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:8
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:8
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:8
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.3:8
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.3:8
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.3:8
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.3:8
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e ND:Proxy
*> [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.3:8
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65103:30 RT:65103:4002 ET:8 Rmac:44:38:39:00:00:7e ND:Proxy
Route Distinguisher: 10.10.10.3:9
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:9
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:9
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:9
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.3:9
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:9
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:9
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:9
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.3:9
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.3:9
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.3:9
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.3:9
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.3:9
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.3:9
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.3:9
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.3:9
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.3:9
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.3:9
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.3:9
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.3:9
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:7e] RD 10.10.10.3:9
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[32]:[10.1.10.4] RD 10.10.10.3:9
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[32]:[10.1.10.4] RD 10.10.10.3:9
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[32]:[10.1.10.4] RD 10.10.10.3:9
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[44:38:39:00:00:7e]:[32]:[10.1.10.4] RD 10.10.10.3:9
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[128]:[fe80::4638:39ff:fe00:7e] RD 10.10.10.3:9
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[128]:[fe80::4638:39ff:fe00:7e] RD 10.10.10.3:9
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:7e]:[128]:[fe80::4638:39ff:fe00:7e] RD 10.10.10.3:9
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:7e]:[128]:[fe80::4638:39ff:fe00:7e] RD 10.10.10.3:9
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    RT:65103:10 ET:8
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:9
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:9
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:9
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*> [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.3:9
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.3:9
                    10.10.10.3 (spine04)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.3:9
                    10.10.10.3 (spine01)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.3:9
                    10.10.10.3 (spine03)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e ND:Proxy
*> [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.3:9
                    10.10.10.3 (spine02)
                                                           0 65100 65103 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65103:10 RT:65103:4001 ET:8 Rmac:44:38:39:00:00:7e ND:Proxy
Route Distinguisher: 10.10.10.4:4
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.4:4
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.4:4
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.4:4
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:39] RD 10.10.10.4:4
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.4:4
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.4:4
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.4:4
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3b] RD 10.10.10.4:4
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.4:4
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.4:4
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.4:4
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[32]:[10.1.20.105] RD 10.10.10.4:4
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.4:4
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.4:4
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.4:4
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3b]:[128]:[fe80::4638:39ff:fe00:3b] RD 10.10.10.4:4
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.4:4
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.4:4
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.4:4
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.4:4
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[32]:[10.1.20.5] RD 10.10.10.4:4
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:80]:[32]:[10.1.20.5] RD 10.10.10.4:4
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[32]:[10.1.20.5] RD 10.10.10.4:4
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[32]:[10.1.20.5] RD 10.10.10.4:4
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[128]:[fe80::4638:39ff:fe00:80] RD 10.10.10.4:4
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:80]:[128]:[fe80::4638:39ff:fe00:80] RD 10.10.10.4:4
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[128]:[fe80::4638:39ff:fe00:80] RD 10.10.10.4:4
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[128]:[fe80::4638:39ff:fe00:80] RD 10.10.10.4:4
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:20 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:4
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80 ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:4
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80 ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:4
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80 ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:39] RD 10.10.10.4:4
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80 ND:Proxy
*> [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:4
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:4
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:4
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[46:38:39:00:00:3b] RD 10.10.10.4:4
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:02
                    RT:65104:20 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
Route Distinguisher: 10.10.10.4:8
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.4:8
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.4:8
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.4:8
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3d] RD 10.10.10.4:8
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.4:8
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.4:8
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.4:8
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3f] RD 10.10.10.4:8
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.4:8
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.4:8
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.4:8
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[32]:[10.1.30.106] RD 10.10.10.4:8
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.4:8
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.4:8
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.4:8
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:3f]:[128]:[fe80::4638:39ff:fe00:3f] RD 10.10.10.4:8
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.4:8
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.4:8
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.4:8
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.4:8
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[32]:[10.1.30.5] RD 10.10.10.4:8
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:80]:[32]:[10.1.30.5] RD 10.10.10.4:8
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[32]:[10.1.30.5] RD 10.10.10.4:8
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[32]:[10.1.30.5] RD 10.10.10.4:8
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[128]:[fe80::4638:39ff:fe00:80] RD 10.10.10.4:8
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:80]:[128]:[fe80::4638:39ff:fe00:80] RD 10.10.10.4:8
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[128]:[fe80::4638:39ff:fe00:80] RD 10.10.10.4:8
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[128]:[fe80::4638:39ff:fe00:80] RD 10.10.10.4:8
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:30 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:8
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80 ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:8
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80 ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:8
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80 ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:3d] RD 10.10.10.4:8
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80 ND:Proxy
*> [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:8
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:8
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:8
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[46:38:39:00:00:3f] RD 10.10.10.4:8
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:03
                    RT:65104:30 RT:65104:4002 ET:8 Rmac:44:38:39:00:00:80
Route Distinguisher: 10.10.10.4:9
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:9
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:9
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:9
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:35] RD 10.10.10.4:9
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:9
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:9
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:9
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:37] RD 10.10.10.4:9
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.4:9
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.4:9
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.4:9
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[32]:[10.1.10.104] RD 10.10.10.4:9
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.4:9
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.4:9
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.4:9
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:37]:[128]:[fe80::4638:39ff:fe00:37] RD 10.10.10.4:9
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.4:9
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.4:9
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.4:9
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80] RD 10.10.10.4:9
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[32]:[10.1.10.5] RD 10.10.10.4:9
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*> [2]:[0]:[48]:[44:38:39:00:00:80]:[32]:[10.1.10.5] RD 10.10.10.4:9
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[32]:[10.1.10.5] RD 10.10.10.4:9
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[32]:[10.1.10.5] RD 10.10.10.4:9
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[128]:[fe80::4638:39ff:fe00:80] RD 10.10.10.4:9
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*> [2]:[0]:[48]:[44:38:39:00:00:80]:[128]:[fe80::4638:39ff:fe00:80] RD 10.10.10.4:9
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[128]:[fe80::4638:39ff:fe00:80] RD 10.10.10.4:9
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*  [2]:[0]:[48]:[44:38:39:00:00:80]:[128]:[fe80::4638:39ff:fe00:80] RD 10.10.10.4:9
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    RT:65104:10 ET:8
*> [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:9
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80 ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:9
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80 ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:9
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80 ND:Proxy
*  [2]:[0]:[48]:[46:38:39:00:00:35] RD 10.10.10.4:9
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80 ND:Proxy
*> [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:9
                    10.10.10.4 (spine01)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:9
                    10.10.10.4 (spine04)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:9
                    10.10.10.4 (spine02)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80
*  [2]:[0]:[48]:[46:38:39:00:00:37] RD 10.10.10.4:9
                    10.10.10.4 (spine03)
                                                           0 65100 65104 i
                    ESI:03:44:38:39:be:ef:bb:00:00:01
                    RT:65104:10 RT:65104:4001 ET:8 Rmac:44:38:39:00:00:80

Displayed 108 prefixes (351 paths) (of requested type)
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
Total Sessions      : 48
Failed Sessions     : 0

Session Establishment Test   : passed
Address Families Test        : passed
Router ID Test               : passed
```
```bash
ubuntu@oob-mgmt-server:~$ netq check evpn
evpn check result summary:

Total nodes         : 6
Checked nodes       : 6
Failed nodes        : 0
Rotten nodes        : 0
Warning nodes       : 0
Skipped Nodes       : 0

Additional summary:
Total VNIs          : 5
Failed EVPN Sessions: 0
Total EVPN Sessions : 24


EVPN BGP Session Test            : passed
EVPN VNI Type Consistency Test   : passed
EVPN Type 2 Test                 : skipped
EVPN Type 3 Test                 : passed
EVPN Session Test                : passed
Vlan Consistency Test            : passed
Vrf Consistency Test             : passed
L3 VNI RMAC Test                 : skipped
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
Network connectivity check using `netq trace` and other validations (e.g. `netq check vxlan`) could be limited or not functioanl in EVPN-MH scenarios. NetQ doesn't support EVPN-MH nor PIM BUM traffic replication yet. 

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
ubuntu@oob-mgmt-server:~/cumulus_ansible_modules$ ansible pod1 -i inventories/evpn_mh/hosts -m ping
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
ubuntu@oob-mgmt-server:~/cumulus_ansible_modules$ ansible-playbook playbooks/nvue.yml -i inventories/evpn_mh/hosts
```

### Playbook Structure

The playbooks have the following important structure:
* Variables and inventories are stored in the same directory `inventories/`
* Backup configurations are stored in `config/` folder of the invetory 
```bash
ubuntu@oob-mgmt-server:~/cumulus_ansible_modules$ cd inventories/evpn_mh/config
```

<!-- AIR:tour -->
?cache=8