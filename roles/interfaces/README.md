
# Cumulus Interfaces Role

Ansible module for `/etc/network/interfaces` on Cumulus Linux using ifupdown2.

Variable | Choices | Type
--- | --- | ---
bridge|bridge interface variables like vids/pvid/access.|dictionary
bonds|list of all bonds (non-mlag/multi-homing)|list of dictionaries
eth0|eth0 interface doptions.|dictionary
interfaces|list of all interfaces (non-bonds/bridges/svis/vnis/etc).|list of dictionaries
loopback|loopback interface options.|dictionary
mlag|all mlag related variables.|dictionary
vlans|list of all SVIs.|list of dictionaries
vnis|list of all vnis.|list of dictionaries
vrfs|list of all vrf loopback interfaces.|list of dictionaries


### Tasks
* Set MTU to 9216 by default on all ports excluding eth0 which is set to 1500 MTU.
* Template `/etc/network/interfaces` (ifupdown2 config file)
* Reload networking (`ifreload -a`) after verifying with `ifup -a -s -i /etc/network/interfaces`

## Examples
<details><summary markdown="span">evpn_centralized</summary>
border01
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - peerlink
  - bond1
  vids:
  - 10
  - 20
  - 101
  - 102
bonds:
  -   bridge:
          vids:
          - 101
          - 102
      clag_id: 1
      name: bond1
      options:
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.63/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.255
  ips:
  - 10.10.10.63/32
  vxlan_local_tunnel_ip: 10.10.10.63
mlag:
  backup: 10.10.10.64
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: primary
  sysmac: 44:38:39:BE:EF:FF
vlans:
  -   address:
      - 10.1.10.3/24
      address_virtual:
      - 00:00:00:00:00:10 10.1.10.1/24
      id: 10
      name: vlan10
  -   address:
      - 10.1.20.3/24
      address_virtual:
      - 00:00:00:00:00:20 10.1.20.1/24
      id: 20
      name: vlan20
  -   address:
      - 10.1.101.2/24
      address_virtual:
      - 00:00:00:00:00:01 10.1.101.1/24
      id: 101
      name: vlan101
  -   address:
      - 10.1.102.2/24
      address_virtual:
      - 00:00:00:00:00:02 10.1.102.1/24
      id: 102
      name: vlan102
vnis:
  -   bridge:
          access: 10
      name: vni10
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      vxlan_id: 20
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
border02
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - peerlink
  - bond1
  vids:
  - 10
  - 20
  - 101
  - 102
bonds:
  -   bridge:
          vids:
          - 101
          - 102
      clag_id: 1
      name: bond1
      options:
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.64/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.255
  ips:
  - 10.10.10.64/32
  vxlan_local_tunnel_ip: 10.10.10.64
mlag:
  backup: 10.10.10.63
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: secondary
  sysmac: 44:38:39:BE:EF:FF
vlans:
  -   address:
      - 10.1.10.2/24
      address_virtual:
      - 00:00:00:00:00:10 10.1.10.1/24
      id: 10
      name: vlan10
  -   address:
      - 10.1.20.2/24
      address_virtual:
      - 00:00:00:00:00:20 10.1.20.1/24
      id: 20
      name: vlan20
  -   address:
      - 10.1.101.1/24
      address_virtual:
      - 00:00:00:00:00:01 10.1.101.1/24
      id: 101
      name: vlan101
  -   address:
      - 10.1.102.1/24
      address_virtual:
      - 00:00:00:00:00:02 10.1.102.1/24
      id: 102
      name: vlan102
vnis:
  -   bridge:
          access: 10
      name: vni10
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      vxlan_id: 20
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
fw1
<pre><code>
bridge:
  ports:
  - borderBond
  vids:
  - 101
  - 102
bonds:
  -   bridge:
          vids:
          - 101
          - 102
      name: borderBond
      options:
          mtu: 9000
      ports:
      - swp1
      - swp2
eth0:
  ips:
  - 192.168.200.61/24
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  -   address:
      - 10.1.101.4/24
      id: 101
      name: vlanRED
  -   address:
      - 10.1.102.4/24
      id: 102
      name: vlanBLUE
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: default
      routes:
      - 10.1.10.0/24 10.1.101.1
      - 10.1.20.0/24 10.1.102.1
</code></pre>
leaf01
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - peerlink
  - bond1
  - bond2
  vids:
  - 10
  - 20
bonds:
  -   bridge:
          access: 10
      clag_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      clag_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
eth0:
  ips:
  - 192.168.200.11/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.12
  ips:
  - 10.10.10.1/32
  vxlan_local_tunnel_ip: 10.10.10.1
mlag:
  backup: 10.10.10.2
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: primary
  sysmac: 44:38:39:BE:EF:AA
vlans:
  -   id: 10
      name: vlan10
  -   id: 20
      name: vlan20
vnis:
  -   bridge:
          access: 10
      name: vni10
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      vxlan_id: 20
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
leaf02
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - peerlink
  - bond1
  - bond2
  vids:
  - 10
  - 20
bonds:
  -   bridge:
          access: 10
      clag_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      clag_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
eth0:
  ips:
  - 192.168.200.12/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.12
  ips:
  - 10.10.10.2/32
  vxlan_local_tunnel_ip: 10.10.10.2
mlag:
  backup: 10.10.10.1
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: primary
  sysmac: 44:38:39:BE:EF:AA
vlans:
  -   id: 10
      name: vlan10
  -   id: 20
      name: vlan20
vnis:
  -   bridge:
          access: 10
      name: vni10
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      vxlan_id: 20
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
leaf03
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - peerlink
  - bond1
  - bond2
  vids:
  - 10
  - 20
bonds:
  -   bridge:
          access: 10
      clag_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      clag_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
eth0:
  ips:
  - 192.168.200.13/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.34
  ips:
  - 10.10.10.3/32
  vxlan_local_tunnel_ip: 10.10.10.3
mlag:
  backup: 10.10.10.4
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: primary
  sysmac: 44:38:39:BE:EF:BB
vlans:
  -   id: 10
      name: vlan10
  -   id: 20
      name: vlan20
vnis:
  -   bridge:
          access: 10
      name: vni10
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      vxlan_id: 20
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
leaf04
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - peerlink
  - bond1
  - bond2
  vids:
  - 10
  - 20
bonds:
  -   bridge:
          access: 10
      clag_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      clag_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
eth0:
  ips:
  - 192.168.200.14/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.34
  ips:
  - 10.10.10.4/32
  vxlan_local_tunnel_ip: 10.10.10.4
mlag:
  backup: 10.10.10.3
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: primary
  sysmac: 44:38:39:BE:EF:BB
vlans:
  -   id: 10
      name: vlan10
  -   id: 20
      name: vlan20
vnis:
  -   bridge:
          access: 10
      name: vni10
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      vxlan_id: 20
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
server01
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server02
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server04
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server05
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
spine01
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.21/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
  -   name: swp2
      options:
          extras:
          - alias to leaf
  -   name: swp3
      options:
          extras:
          - alias to leaf
  -   name: swp4
      options:
          extras:
          - alias to leaf
  -   name: swp5
      options:
          extras:
          - alias to leaf
  -   name: swp6
      options:
          extras:
          - alias to leaf
loopback:
  ips:
  - 10.10.10.101/32
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
spine02
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.22/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
  -   name: swp2
      options:
          extras:
          - alias to leaf
  -   name: swp3
      options:
          extras:
          - alias to leaf
  -   name: swp4
      options:
          extras:
          - alias to leaf
  -   name: swp5
      options:
          extras:
          - alias to leaf
  -   name: swp6
      options:
          extras:
          - alias to leaf
loopback:
  ips:
  - 10.10.10.102/32
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
spine03
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.23/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
  -   name: swp2
      options:
          extras:
          - alias to leaf
  -   name: swp3
      options:
          extras:
          - alias to leaf
  -   name: swp4
      options:
          extras:
          - alias to leaf
  -   name: swp5
      options:
          extras:
          - alias to leaf
  -   name: swp6
      options:
          extras:
          - alias to leaf
loopback:
  ips:
  - 10.10.10.103/32
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
spine04
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.24/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
  -   name: swp2
      options:
          extras:
          - alias to leaf
  -   name: swp3
      options:
          extras:
          - alias to leaf
  -   name: swp4
      options:
          extras:
          - alias to leaf
  -   name: swp5
      options:
          extras:
          - alias to leaf
  -   name: swp6
      options:
          extras:
          - alias to leaf
loopback:
  ips:
  - 10.10.10.104/32
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
</details>
<details><summary markdown="span">evpn_l2only</summary>
border01
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - peerlink
  - bond1
  vids:
  - 10
  - 20
bonds:
  -   bridge:
          vids:
          - 10
          - 20
      clag_id: 1
      name: bond1
      options:
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.63/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.255
  ips:
  - 10.10.10.63/32
  vxlan_local_tunnel_ip: 10.10.10.63
mlag:
  backup: 10.10.10.64
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: primary
  sysmac: 44:38:39:BE:EF:FF
vlans:
  -   extras:
      - ip-forward off
      - ip6-forward off
      id: 10
      name: vlan10
  -   extras:
      - ip-forward off
      - ip6-forward off
      id: 20
      name: vlan20
vnis:
  -   bridge:
          access: 10
      name: vni10
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      vxlan_id: 20
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
border02
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - peerlink
  - bond1
  vids:
  - 10
  - 20
bonds:
  -   bridge:
          vids:
          - 10
          - 20
      clag_id: 1
      name: bond1
      options:
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.64/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.255
  ips:
  - 10.10.10.64/32
  vxlan_local_tunnel_ip: 10.10.10.64
mlag:
  backup: 10.10.10.63
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: secondary
  sysmac: 44:38:39:BE:EF:FF
vlans:
  -   extras:
      - ip-forward off
      - ip6-forward off
      id: 10
      name: vlan10
  -   extras:
      - ip-forward off
      - ip6-forward off
      id: 20
      name: vlan20
vnis:
  -   bridge:
          access: 10
      name: vni10
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      vxlan_id: 20
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
fw1
<pre><code>
bridge:
  ports:
  - borderBond
  vids:
  - 10
  - 20
bonds:
  -   bridge:
          vids:
          - 10
          - 20
      name: borderBond
      options:
          mtu: 9000
      ports:
      - swp1
      - swp2
eth0:
  ips:
  - 192.168.200.61/24
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  -   address:
      - 10.1.10.1/24
      id: 10
      name: vlan10
  -   address:
      - 10.1.20.1/24
      id: 20
      name: vlan20
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
leaf01
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - peerlink
  - bond1
  - bond2
  vids:
  - 10
  - 20
bonds:
  -   bridge:
          access: 10
      clag_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      clag_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
eth0:
  ips:
  - 192.168.200.11/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.12
  ips:
  - 10.10.10.1/32
  vxlan_local_tunnel_ip: 10.10.10.1
mlag:
  backup: 10.10.10.2
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: primary
  sysmac: 44:38:39:BE:EF:AA
vlans:
  -   extras:
      - ip-forward off
      - ip6-forward off
      id: 10
      name: vlan10
  -   extras:
      - ip-forward off
      - ip6-forward off
      id: 20
      name: vlan20
vnis:
  -   bridge:
          access: 10
      name: vni10
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      vxlan_id: 20
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
leaf02
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - peerlink
  - bond1
  - bond2
  vids:
  - 10
  - 20
bonds:
  -   bridge:
          access: 10
      clag_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      clag_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
eth0:
  ips:
  - 192.168.200.12/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.12
  ips:
  - 10.10.10.2/32
  vxlan_local_tunnel_ip: 10.10.10.2
mlag:
  backup: 10.10.10.1
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: secondary
  sysmac: 44:38:39:BE:EF:AA
vlans:
  -   extras:
      - ip-forward off
      - ip6-forward off
      id: 10
      name: vlan10
  -   extras:
      - ip-forward off
      - ip6-forward off
      id: 20
      name: vlan20
vnis:
  -   bridge:
          access: 10
      name: vni10
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      vxlan_id: 20
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
leaf03
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - peerlink
  - bond1
  - bond2
  vids:
  - 10
  - 20
bonds:
  -   bridge:
          access: 10
      clag_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      clag_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
eth0:
  ips:
  - 192.168.200.13/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.34
  ips:
  - 10.10.10.3/32
  vxlan_local_tunnel_ip: 10.10.10.3
mlag:
  backup: 10.10.10.4
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: primary
  sysmac: 44:38:39:BE:EF:BB
vlans:
  -   extras:
      - ip-forward off
      - ip6-forward off
      id: 10
      name: vlan10
  -   extras:
      - ip-forward off
      - ip6-forward off
      id: 20
      name: vlan20
vnis:
  -   bridge:
          access: 10
      name: vni10
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      vxlan_id: 20
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
leaf04
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - peerlink
  - bond1
  - bond2
  vids:
  - 10
  - 20
bonds:
  -   bridge:
          access: 10
      clag_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      clag_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
eth0:
  ips:
  - 192.168.200.14/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.34
  ips:
  - 10.10.10.4/32
  vxlan_local_tunnel_ip: 10.10.10.4
mlag:
  backup: 10.10.10.3
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: secondary
  sysmac: 44:38:39:BE:EF:BB
vlans:
  -   extras:
      - ip-forward off
      - ip6-forward off
      id: 10
      name: vlan10
  -   extras:
      - ip-forward off
      - ip6-forward off
      id: 20
      name: vlan20
vnis:
  -   bridge:
          access: 10
      name: vni10
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      vxlan_id: 20
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
server01
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server02
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server04
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server05
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
spine01
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.21/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
  -   name: swp2
      options:
          extras:
          - alias to leaf
  -   name: swp3
      options:
          extras:
          - alias to leaf
  -   name: swp4
      options:
          extras:
          - alias to leaf
  -   name: swp5
      options:
          extras:
          - alias to leaf
  -   name: swp6
      options:
          extras:
          - alias to leaf
loopback:
  ips:
  - 10.10.10.101/32
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
spine02
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.22/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
  -   name: swp2
      options:
          extras:
          - alias to leaf
  -   name: swp3
      options:
          extras:
          - alias to leaf
  -   name: swp4
      options:
          extras:
          - alias to leaf
  -   name: swp5
      options:
          extras:
          - alias to leaf
  -   name: swp6
      options:
          extras:
          - alias to leaf
loopback:
  ips:
  - 10.10.10.102/32
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
spine03
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.23/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
  -   name: swp2
      options:
          extras:
          - alias to leaf
  -   name: swp3
      options:
          extras:
          - alias to leaf
  -   name: swp4
      options:
          extras:
          - alias to leaf
  -   name: swp5
      options:
          extras:
          - alias to leaf
  -   name: swp6
      options:
          extras:
          - alias to leaf
loopback:
  ips:
  - 10.10.10.103/32
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
spine04
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.24/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
  -   name: swp2
      options:
          extras:
          - alias to leaf
  -   name: swp3
      options:
          extras:
          - alias to leaf
  -   name: swp4
      options:
          extras:
          - alias to leaf
  -   name: swp5
      options:
          extras:
          - alias to leaf
  -   name: swp6
      options:
          extras:
          - alias to leaf
loopback:
  ips:
  - 10.10.10.104/32
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
</details>
<details><summary markdown="span">evpn_mh</summary>
border01
<pre><code>
bridge:
  ports:
  - vni101
  - vni102
  - vniRED
  - vniBLUE
  - bond1
  vids:
  - 101
  - 102
bonds:
  -   bridge:
          vids:
          - 101
          - 102
      es_df_pref: '50000'
      es_id: 1
      name: bond1
      options:
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.63/24
interfaces:
  -   name: swp51
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp52
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp53
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp54
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
loopback:
  igmp: true
  ips:
  - 10.10.10.63/32
  - 10.10.100.100/32
  pim:
      source: 10.10.10.63
  vxlan_local_tunnel_ip: 10.10.10.63
mlag:
  N/A
  ...
vlans:
  -   address:
      - 10.1.101.64/24
      address_virtual:
      - 00:00:00:00:00:01 10.1.101.1/24
      id: 101
      name: vlan101
      vrf: RED
  -   address:
      - 10.1.102.64/24
      address_virtual:
      - 00:00:00:00:00:02 10.1.102.1/24
      id: 102
      name: vlan102
      vrf: BLUE
  -   address_virtual:
      - 44:38:39:BE:EF:FF
      id: 4001
      name: vlan4001
      vrf: RED
  -   address_virtual:
      - 44:38:39:BE:EF:FF
      id: 4002
      name: vlan4002
      vrf: BLUE
vnis:
  -   bridge:
          access: 101
      extras:
      - vxlan-mcastgrp 239.1.1.101
      name: vni101
      type: l2
      vxlan_id: 101
  -   bridge:
          access: 102
      extras:
      - vxlan-mcastgrp 239.1.1.102
      name: vni102
      type: l2
      vxlan_id: 102
  -   bridge:
          access: 4001
      name: vniRED
      type: l3
      vxlan_id: 4001
  -   bridge:
          access: 4002
      name: vniBLUE
      type: l3
      vxlan_id: 4002
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: RED
      routes:
      - 10.1.30.0/24 10.1.101.4
      vxlan_id: 4001
  -   name: BLUE
      routes:
      - 10.1.10.0/24 10.1.102.4
      - 10.1.20.0/24 10.1.102.4
      vxlan_id: 4002
</code></pre>
border02
<pre><code>
bridge:
  ports:
  - vni101
  - vni102
  - vniRED
  - vniBLUE
  - bond1
  vids:
  - 101
  - 102
bonds:
  -   bridge:
          vids:
          - 101
          - 102
      es_df_pref: '1'
      es_id: 1
      name: bond1
      options:
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.64/24
interfaces:
  -   name: swp51
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp52
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp53
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp54
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
loopback:
  igmp: true
  ips:
  - 10.10.10.64/32
  - 10.10.100.100/32
  pim:
      source: 10.10.10.64
  vxlan_local_tunnel_ip: 10.10.10.64
mlag:
  N/A
  ...
vlans:
  -   address:
      - 10.1.101.65/24
      address_virtual:
      - 00:00:00:00:00:01 10.1.101.1/24
      id: 101
      name: vlan101
      vrf: RED
  -   address:
      - 10.1.102.65/24
      address_virtual:
      - 00:00:00:00:00:02 10.1.102.1/24
      id: 102
      name: vlan102
      vrf: BLUE
  -   address_virtual:
      - 44:38:39:BE:EF:FF
      id: 4001
      name: vlan4001
      vrf: RED
  -   address_virtual:
      - 44:38:39:BE:EF:FF
      id: 4002
      name: vlan4002
      vrf: BLUE
vnis:
  -   bridge:
          access: 101
      extras:
      - vxlan-mcastgrp 239.1.1.101
      name: vni101
      type: l2
      vxlan_id: 101
  -   bridge:
          access: 102
      extras:
      - vxlan-mcastgrp 239.1.1.102
      name: vni102
      type: l2
      vxlan_id: 102
  -   bridge:
          access: 4001
      name: vniRED
      type: l3
      vxlan_id: 4001
  -   bridge:
          access: 4002
      name: vniBLUE
      type: l3
      vxlan_id: 4002
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: RED
      routes:
      - 10.1.30.0/24 10.1.101.4
      vxlan_id: 4001
  -   name: BLUE
      routes:
      - 10.1.10.0/24 10.1.102.4
      - 10.1.20.0/24 10.1.102.4
      vxlan_id: 4002
</code></pre>
fw1
<pre><code>
bridge:
  ports:
  - borderBond
  vids:
  - 101
  - 102
bonds:
  -   bridge:
          vids:
          - 101
          - 102
      name: borderBond
      options:
          mtu: 9000
          pim: true
      ports:
      - swp1
      - swp2
eth0:
  ips:
  - 192.168.200.61/24
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  -   address:
      - 10.1.101.4/24
      id: 101
      name: vlanRED
  -   address:
      - 10.1.102.4/24
      id: 102
      name: vlanBLUE
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: default
      routes:
      - 10.1.10.0/24 10.1.101.1
      - 10.1.20.0/24 10.1.101.1
      - 10.1.30.0/24 10.1.102.1
</code></pre>
leaf01
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - vni30
  - vniRED
  - vniBLUE
  - bond1
  - bond2
  - bond3
  vids:
  - 10
  - 20
  - 30
bonds:
  -   bridge:
          access: 10
      es_df_pref: '50000'
      es_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      es_df_pref: '50000'
      es_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
  -   bridge:
          access: 30
      es_df_pref: '50000'
      es_id: 3
      name: bond3
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.11/24
interfaces:
  -   name: swp51
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp52
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp53
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp54
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
loopback:
  igmp: true
  ips:
  - 10.10.10.1/32
  pim:
      source: 10.10.10.1
  vxlan_local_tunnel_ip: 10.10.10.1
mlag:
  N/A
  ...
vlans:
  -   address:
      - 10.1.10.2/24
      address_virtual:
      - 00:00:00:00:00:10 10.1.10.1/24
      id: 10
      name: vlan10
      vrf: RED
  -   address:
      - 10.1.20.2/24
      address_virtual:
      - 00:00:00:00:00:20 10.1.20.1/24
      id: 20
      name: vlan20
      vrf: RED
  -   address:
      - 10.1.30.2/24
      address_virtual:
      - 00:00:00:00:00:30 10.1.30.1/24
      id: 30
      name: vlan30
      vrf: BLUE
  -   address_virtual:
      - 44:38:39:BE:EF:AA
      id: 4001
      name: vlan4001
      vrf: RED
  -   address_virtual:
      - 44:38:39:BE:EF:AA
      id: 4002
      name: vlan4002
      vrf: BLUE
vnis:
  -   bridge:
          access: 10
      extras:
      - vxlan-mcastgrp 239.1.1.10
      name: vni10
      type: l2
      vxlan_id: 10
  -   bridge:
          access: 20
      extras:
      - vxlan-mcastgrp 239.1.1.20
      name: vni20
      type: l2
      vxlan_id: 20
  -   bridge:
          access: 30
      extras:
      - vxlan-mcastgrp 239.1.1.30
      name: vni30
      type: l2
      vxlan_id: 30
  -   bridge:
          access: 4001
      name: vniRED
      type: l3
      vxlan_id: 4001
  -   bridge:
          access: 4002
      name: vniBLUE
      type: l3
      vxlan_id: 4002
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: RED
      vxlan_id: 4001
  -   name: BLUE
      vxlan_id: 4002
</code></pre>
leaf02
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - vni30
  - vniRED
  - vniBLUE
  - bond1
  - bond2
  - bond3
  vids:
  - 10
  - 20
  - 30
bonds:
  -   bridge:
          access: 10
      es_df_pref: '1'
      es_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      es_df_pref: '1'
      es_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
  -   bridge:
          access: 30
      es_df_pref: '1'
      es_id: 3
      name: bond3
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.12/24
interfaces:
  -   name: swp51
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp52
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp53
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp54
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
loopback:
  igmp: true
  ips:
  - 10.10.10.2/32
  pim:
      source: 10.10.10.2
  vxlan_local_tunnel_ip: 10.10.10.2
mlag:
  N/A
  ...
vlans:
  -   address:
      - 10.1.10.3/24
      address_virtual:
      - 00:00:00:00:00:10 10.1.10.1/24
      id: 10
      name: vlan10
      vrf: RED
  -   address:
      - 10.1.20.3/24
      address_virtual:
      - 00:00:00:00:00:20 10.1.20.1/24
      id: 20
      name: vlan20
      vrf: RED
  -   address:
      - 10.1.30.3/24
      address_virtual:
      - 00:00:00:00:00:30 10.1.30.1/24
      id: 30
      name: vlan30
      vrf: BLUE
  -   address_virtual:
      - 44:38:39:BE:EF:AA
      id: 4001
      name: vlan4001
      vrf: RED
  -   address_virtual:
      - 44:38:39:BE:EF:AA
      id: 4002
      name: vlan4002
      vrf: BLUE
vnis:
  -   bridge:
          access: 10
      extras:
      - vxlan-mcastgrp 239.1.1.10
      name: vni10
      type: l2
      vxlan_id: 10
  -   bridge:
          access: 20
      extras:
      - vxlan-mcastgrp 239.1.1.20
      name: vni20
      type: l2
      vxlan_id: 20
  -   bridge:
          access: 30
      extras:
      - vxlan-mcastgrp 239.1.1.30
      name: vni30
      type: l2
      vxlan_id: 30
  -   bridge:
          access: 4001
      name: vniRED
      type: l3
      vxlan_id: 4001
  -   bridge:
          access: 4002
      name: vniBLUE
      type: l3
      vxlan_id: 4002
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: RED
      vxlan_id: 4001
  -   name: BLUE
      vxlan_id: 4002
</code></pre>
leaf03
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - vni30
  - vniRED
  - vniBLUE
  - bond1
  - bond2
  - bond3
  vids:
  - 10
  - 20
  - 30
bonds:
  -   bridge:
          access: 10
      es_df_pref: '50000'
      es_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      es_df_pref: '50000'
      es_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
  -   bridge:
          access: 30
      es_df_pref: '50000'
      es_id: 3
      name: bond3
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.13/24
interfaces:
  -   name: swp51
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp52
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp53
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp54
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
loopback:
  igmp: true
  ips:
  - 10.10.10.3/32
  pim:
      source: 10.10.10.3
  vxlan_local_tunnel_ip: 10.10.10.3
mlag:
  N/A
  ...
vlans:
  -   address:
      - 10.1.10.4/24
      address_virtual:
      - 00:00:00:00:00:10 10.1.10.1/24
      id: 10
      name: vlan10
      vrf: RED
  -   address:
      - 10.1.20.4/24
      address_virtual:
      - 00:00:00:00:00:20 10.1.20.1/24
      id: 20
      name: vlan20
      vrf: RED
  -   address:
      - 10.1.30.4/24
      address_virtual:
      - 00:00:00:00:00:30 10.1.30.1/24
      id: 30
      name: vlan30
      vrf: BLUE
  -   address_virtual:
      - 44:38:39:BE:EF:BB
      id: 4001
      name: vlan4001
      vrf: RED
  -   address_virtual:
      - 44:38:39:BE:EF:BB
      id: 4002
      name: vlan4002
      vrf: BLUE
vnis:
  -   bridge:
          access: 10
      extras:
      - vxlan-mcastgrp 239.1.1.10
      name: vni10
      type: l2
      vxlan_id: 10
  -   bridge:
          access: 20
      extras:
      - vxlan-mcastgrp 239.1.1.20
      name: vni20
      type: l2
      vxlan_id: 20
  -   bridge:
          access: 30
      extras:
      - vxlan-mcastgrp 239.1.1.30
      name: vni30
      type: l2
      vxlan_id: 30
  -   bridge:
          access: 4001
      name: vniRED
      type: l3
      vxlan_id: 4001
  -   bridge:
          access: 4002
      name: vniBLUE
      type: l3
      vxlan_id: 4002
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: RED
      vxlan_id: 4001
  -   name: BLUE
      vxlan_id: 4002
</code></pre>
leaf04
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - vni30
  - vniRED
  - vniBLUE
  - bond1
  - bond2
  - bond3
  vids:
  - 10
  - 20
  - 30
bonds:
  -   bridge:
          access: 10
      es_df_pref: '1'
      es_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      es_df_pref: '1'
      es_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
  -   bridge:
          access: 30
      es_df_pref: '1'
      es_id: 3
      name: bond3
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.14/24
interfaces:
  -   name: swp51
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp52
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp53
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
  -   name: swp54
      options:
          evpn_mh_uplink: true
          extras:
          - alias to spine
          pim: true
loopback:
  igmp: true
  ips:
  - 10.10.10.4/32
  pim:
      source: 10.10.10.4
  vxlan_local_tunnel_ip: 10.10.10.4
mlag:
  N/A
  ...
vlans:
  -   address:
      - 10.1.10.5/24
      address_virtual:
      - 00:00:00:00:00:10 10.1.10.1/24
      id: 10
      name: vlan10
      vrf: RED
  -   address:
      - 10.1.20.5/24
      address_virtual:
      - 00:00:00:00:00:20 10.1.20.1/24
      id: 20
      name: vlan20
      vrf: RED
  -   address:
      - 10.1.30.5/24
      address_virtual:
      - 00:00:00:00:00:30 10.1.30.1/24
      id: 30
      name: vlan30
      vrf: BLUE
  -   address_virtual:
      - 44:38:39:BE:EF:BB
      id: 4001
      name: vlan4001
      vrf: RED
  -   address_virtual:
      - 44:38:39:BE:EF:BB
      id: 4002
      name: vlan4002
      vrf: BLUE
vnis:
  -   bridge:
          access: 10
      extras:
      - vxlan-mcastgrp 239.1.1.10
      name: vni10
      type: l2
      vxlan_id: 10
  -   bridge:
          access: 20
      extras:
      - vxlan-mcastgrp 239.1.1.20
      name: vni20
      type: l2
      vxlan_id: 20
  -   bridge:
          access: 30
      extras:
      - vxlan-mcastgrp 239.1.1.30
      name: vni30
      type: l2
      vxlan_id: 30
  -   bridge:
          access: 4001
      name: vniRED
      type: l3
      vxlan_id: 4001
  -   bridge:
          access: 4002
      name: vniBLUE
      type: l3
      vxlan_id: 4002
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: RED
      vxlan_id: 4001
  -   name: BLUE
      vxlan_id: 4002
</code></pre>
server01
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server02
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server04
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server05
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
spine01
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.21/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp2
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp3
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp4
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp5
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp6
      options:
          extras:
          - alias to leaf
          pim: true
loopback:
  igmp: true
  ips:
  - 10.10.10.101/32
  pim:
      source: 10.10.10.101
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
spine02
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.22/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp2
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp3
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp4
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp5
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp6
      options:
          extras:
          - alias to leaf
          pim: true
loopback:
  igmp: true
  ips:
  - 10.10.10.102/32
  pim:
      source: 10.10.10.102
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
spine03
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.23/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp2
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp3
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp4
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp5
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp6
      options:
          extras:
          - alias to leaf
          pim: true
loopback:
  igmp: true
  ips:
  - 10.10.10.103/32
  pim:
      source: 10.10.10.103
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
spine04
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.24/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp2
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp3
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp4
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp5
      options:
          extras:
          - alias to leaf
          pim: true
  -   name: swp6
      options:
          extras:
          - alias to leaf
          pim: true
loopback:
  igmp: true
  ips:
  - 10.10.10.104/32
  pim:
      source: 10.10.10.104
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
</details>
<details><summary markdown="span">evpn_symmetric</summary>
border01
<pre><code>
bridge:
  ports:
  - peerlink
  - bond1
  - vniRED
  - vniBLUE
  vids:
  - 101
  - 102
bonds:
  -   bridge:
          vids:
          - 101
          - 102
      clag_id: 1
      name: bond1
      options:
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.63/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.255
  ips:
  - 10.10.10.63/32
  vxlan_local_tunnel_ip: 10.10.10.63
mlag:
  backup: 10.10.10.64
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: primary
  sysmac: 44:38:39:BE:EF:FF
vlans:
  -   address:
      - 10.1.101.64/24
      address_virtual:
      - 00:00:00:00:00:01 10.1.101.1/24
      id: 101
      name: vlan101
      vrf: RED
  -   address:
      - 10.1.102.64/24
      address_virtual:
      - 00:00:00:00:00:02 10.1.102.1/24
      id: 102
      name: vlan102
      vrf: BLUE
  -   address_virtual:
      - 44:38:39:BE:EF:FF
      id: 4001
      name: vlan4001
      vrf: RED
  -   address_virtual:
      - 44:38:39:BE:EF:FF
      id: 4002
      name: vlan4002
      vrf: BLUE
vnis:
  -   bridge:
          access: 4001
      name: vniRED
      type: l3
      vxlan_id: 4001
  -   bridge:
          access: 4002
      name: vniBLUE
      type: l3
      vxlan_id: 4002
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: RED
      routes:
      - 10.1.30.0/24 10.1.101.4
      vxlan_id: 4001
  -   name: BLUE
      routes:
      - 10.1.10.0/24 10.1.102.4
      - 10.1.20.0/24 10.1.102.4
      vxlan_id: 4002
</code></pre>
border02
<pre><code>
bridge:
  ports:
  - peerlink
  - bond1
  - vniRED
  - vniBLUE
  vids:
  - 101
  - 102
bonds:
  -   bridge:
          vids:
          - 101
          - 102
      clag_id: 1
      name: bond1
      options:
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.64/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.255
  ips:
  - 10.10.10.64/32
  vxlan_local_tunnel_ip: 10.10.10.64
mlag:
  backup: 10.10.10.63
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: secondary
  sysmac: 44:38:39:BE:EF:FF
vlans:
  -   address:
      - 10.1.101.65/24
      address_virtual:
      - 00:00:00:00:00:01 10.1.101.1/24
      id: 101
      name: vlan101
      vrf: RED
  -   address:
      - 10.1.102.65/24
      address_virtual:
      - 00:00:00:00:00:02 10.1.102.1/24
      id: 102
      name: vlan102
      vrf: BLUE
  -   address_virtual:
      - 44:38:39:BE:EF:FF
      id: 4001
      name: vlan4001
      vrf: RED
  -   address_virtual:
      - 44:38:39:BE:EF:FF
      id: 4002
      name: vlan4002
      vrf: BLUE
vnis:
  -   bridge:
          access: 4001
      name: vniRED
      type: l3
      vxlan_id: 4001
  -   bridge:
          access: 4002
      name: vniBLUE
      type: l3
      vxlan_id: 4002
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: RED
      routes:
      - 10.1.30.0/24 10.1.101.4
      vxlan_id: 4001
  -   name: BLUE
      routes:
      - 10.1.10.0/24 10.1.102.4
      - 10.1.20.0/24 10.1.102.4
      vxlan_id: 4002
</code></pre>
fw1
<pre><code>
bridge:
  ports:
  - borderBond
  vids:
  - 101
  - 102
bonds:
  -   bridge:
          vids:
          - 101
          - 102
      name: borderBond
      options:
          mtu: 9000
      ports:
      - swp1
      - swp2
eth0:
  ips:
  - 192.168.200.61/24
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  -   address:
      - 10.1.101.4/24
      id: 101
      name: vlanRED
  -   address:
      - 10.1.102.4/24
      id: 102
      name: vlanBLUE
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: default
      routes:
      - 10.1.10.0/24 10.1.101.1
      - 10.1.20.0/24 10.1.101.1
      - 10.1.30.0/24 10.1.102.1
</code></pre>
leaf01
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - vni30
  - vniRED
  - vniBLUE
  - peerlink
  - bond1
  - bond2
  - bond3
  vids:
  - 10
  - 20
  - 30
bonds:
  -   bridge:
          access: 10
      clag_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      clag_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
  -   bridge:
          access: 30
      clag_id: 3
      name: bond3
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.11/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.12
  ips:
  - 10.10.10.1/32
  vxlan_local_tunnel_ip: 10.10.10.1
mlag:
  backup: 10.10.10.2
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: primary
  sysmac: 44:38:39:BE:EF:AA
vlans:
  -   address:
      - 10.1.10.2/24
      address_virtual:
      - 00:00:00:00:00:10 10.1.10.1/24
      id: 10
      name: vlan10
      vrf: RED
  -   address:
      - 10.1.20.2/24
      address_virtual:
      - 00:00:00:00:00:20 10.1.20.1/24
      id: 20
      name: vlan20
      vrf: RED
  -   address:
      - 10.1.30.2/24
      address_virtual:
      - 00:00:00:00:00:30 10.1.30.1/24
      id: 30
      name: vlan30
      vrf: BLUE
  -   address_virtual:
      - 44:38:39:BE:EF:AA
      id: 4001
      name: vlan4001
      vrf: RED
  -   address_virtual:
      - 44:38:39:BE:EF:AA
      id: 4002
      name: vlan4002
      vrf: BLUE
vnis:
  -   bridge:
          access: 10
      name: vni10
      type: l2
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      type: l2
      vxlan_id: 20
  -   bridge:
          access: 30
      name: vni30
      type: l2
      vxlan_id: 30
  -   bridge:
          access: 4001
      name: vniRED
      type: l3
      vxlan_id: 4001
  -   bridge:
          access: 4002
      name: vniBLUE
      type: l3
      vxlan_id: 4002
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: RED
      vxlan_id: 4001
  -   name: BLUE
      vxlan_id: 4002
</code></pre>
leaf02
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - vni30
  - vniRED
  - vniBLUE
  - peerlink
  - bond1
  - bond2
  - bond3
  vids:
  - 10
  - 20
  - 30
bonds:
  -   bridge:
          access: 10
      clag_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      clag_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
  -   bridge:
          access: 30
      clag_id: 3
      name: bond3
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.12/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.12
  ips:
  - 10.10.10.2/32
  vxlan_local_tunnel_ip: 10.10.10.2
mlag:
  backup: 10.10.10.1
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: secondary
  sysmac: 44:38:39:BE:EF:AA
vlans:
  -   address:
      - 10.1.10.3/24
      address_virtual:
      - 00:00:00:00:00:10 10.1.10.1/24
      id: 10
      name: vlan10
      vrf: RED
  -   address:
      - 10.1.20.3/24
      address_virtual:
      - 00:00:00:00:00:20 10.1.20.1/24
      id: 20
      name: vlan20
      vrf: RED
  -   address:
      - 10.1.30.3/24
      address_virtual:
      - 00:00:00:00:00:30 10.1.30.1/24
      id: 30
      name: vlan30
      vrf: BLUE
  -   address_virtual:
      - 44:38:39:BE:EF:AA
      id: 4001
      name: vlan4001
      vrf: RED
  -   address_virtual:
      - 44:38:39:BE:EF:AA
      id: 4002
      name: vlan4002
      vrf: BLUE
vnis:
  -   bridge:
          access: 10
      name: vni10
      type: l2
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      type: l2
      vxlan_id: 20
  -   bridge:
          access: 30
      name: vni30
      type: l2
      vxlan_id: 30
  -   bridge:
          access: 4001
      name: vniRED
      type: l3
      vxlan_id: 4001
  -   bridge:
          access: 4002
      name: vniBLUE
      type: l3
      vxlan_id: 4002
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: RED
      vxlan_id: 4001
  -   name: BLUE
      vxlan_id: 4002
</code></pre>
leaf03
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - vni30
  - vniRED
  - vniBLUE
  - peerlink
  - bond1
  - bond2
  - bond3
  vids:
  - 10
  - 20
  - 30
bonds:
  -   bridge:
          access: 10
      clag_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      clag_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
  -   bridge:
          access: 30
      clag_id: 3
      name: bond3
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.13/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.34
  ips:
  - 10.10.10.3/32
  vxlan_local_tunnel_ip: 10.10.10.3
mlag:
  backup: 10.10.10.4
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: primary
  sysmac: 44:38:39:BE:EF:BB
vlans:
  -   address:
      - 10.1.10.4/24
      address_virtual:
      - 00:00:00:00:00:10 10.1.10.1/24
      id: 10
      name: vlan10
      vrf: RED
  -   address:
      - 10.1.20.4/24
      address_virtual:
      - 00:00:00:00:00:20 10.1.20.1/24
      id: 20
      name: vlan20
      vrf: RED
  -   address:
      - 10.1.30.4/24
      address_virtual:
      - 00:00:00:00:00:30 10.1.30.1/24
      id: 30
      name: vlan30
      vrf: BLUE
  -   address_virtual:
      - 44:38:39:BE:EF:BB
      id: 4001
      name: vlan4001
      vrf: RED
  -   address_virtual:
      - 44:38:39:BE:EF:BB
      id: 4002
      name: vlan4002
      vrf: BLUE
vnis:
  -   bridge:
          access: 10
      name: vni10
      type: l2
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      type: l2
      vxlan_id: 20
  -   bridge:
          access: 30
      name: vni30
      type: l2
      vxlan_id: 30
  -   bridge:
          access: 4001
      name: vniRED
      type: l3
      vxlan_id: 4001
  -   bridge:
          access: 4002
      name: vniBLUE
      type: l3
      vxlan_id: 4002
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: RED
      vxlan_id: 4001
  -   name: BLUE
      vxlan_id: 4002
</code></pre>
leaf04
<pre><code>
bridge:
  ports:
  - vni10
  - vni20
  - vni30
  - vniRED
  - vniBLUE
  - peerlink
  - bond1
  - bond2
  - bond3
  vids:
  - 10
  - 20
  - 30
bonds:
  -   bridge:
          access: 10
      clag_id: 1
      name: bond1
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp1
  -   bridge:
          access: 20
      clag_id: 2
      name: bond2
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp2
  -   bridge:
          access: 30
      clag_id: 3
      name: bond3
      options:
          extras:
          - bond-lacp-bypass-allow yes
          - mstpctl-bpduguard yes
          - mstpctl-portadminedge yes
          mtu: 9000
      ports:
      - swp3
eth0:
  ips:
  - 192.168.200.14/24
interfaces:
  -   name: swp51
      options:
          extras:
          - alias to spine
  -   name: swp52
      options:
          extras:
          - alias to spine
  -   name: swp53
      options:
          extras:
          - alias to spine
  -   name: swp54
      options:
          extras:
          - alias to spine
loopback:
  clag_vxlan_anycast_ip: 10.0.1.34
  ips:
  - 10.10.10.4/32
  vxlan_local_tunnel_ip: 10.10.10.4
mlag:
  backup: 10.10.10.3
  init_delay: 10
  peerlinks:
  - swp49
  - swp50
  priority: secondary
  sysmac: 44:38:39:BE:EF:BB
vlans:
  -   address:
      - 10.1.10.5/24
      address_virtual:
      - 00:00:00:00:00:10 10.1.10.1/24
      id: 10
      name: vlan10
      vrf: RED
  -   address:
      - 10.1.20.5/24
      address_virtual:
      - 00:00:00:00:00:20 10.1.20.1/24
      id: 20
      name: vlan20
      vrf: RED
  -   address:
      - 10.1.30.5/24
      address_virtual:
      - 00:00:00:00:00:30 10.1.30.1/24
      id: 30
      name: vlan30
      vrf: BLUE
  -   address_virtual:
      - 44:38:39:BE:EF:BB
      id: 4001
      name: vlan4001
      vrf: RED
  -   address_virtual:
      - 44:38:39:BE:EF:BB
      id: 4002
      name: vlan4002
      vrf: BLUE
vnis:
  -   bridge:
          access: 10
      name: vni10
      type: l2
      vxlan_id: 10
  -   bridge:
          access: 20
      name: vni20
      type: l2
      vxlan_id: 20
  -   bridge:
          access: 30
      name: vni30
      type: l2
      vxlan_id: 30
  -   bridge:
          access: 4001
      name: vniRED
      type: l3
      vxlan_id: 4001
  -   bridge:
          access: 4002
      name: vniBLUE
      type: l3
      vxlan_id: 4002
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
  -   name: RED
      vxlan_id: 4001
  -   name: BLUE
      vxlan_id: 4002
</code></pre>
server01
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server02
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server04
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server05
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  N/A
  ...
interfaces:
  N/A
  ...
loopback:
  N/A
  ...
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
spine01
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.21/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
  -   name: swp2
      options:
          extras:
          - alias to leaf
  -   name: swp3
      options:
          extras:
          - alias to leaf
  -   name: swp4
      options:
          extras:
          - alias to leaf
  -   name: swp5
      options:
          extras:
          - alias to leaf
  -   name: swp6
      options:
          extras:
          - alias to leaf
loopback:
  ips:
  - 10.10.10.101/32
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
spine02
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.22/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
  -   name: swp2
      options:
          extras:
          - alias to leaf
  -   name: swp3
      options:
          extras:
          - alias to leaf
  -   name: swp4
      options:
          extras:
          - alias to leaf
  -   name: swp5
      options:
          extras:
          - alias to leaf
  -   name: swp6
      options:
          extras:
          - alias to leaf
loopback:
  ips:
  - 10.10.10.102/32
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
spine03
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.23/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
  -   name: swp2
      options:
          extras:
          - alias to leaf
  -   name: swp3
      options:
          extras:
          - alias to leaf
  -   name: swp4
      options:
          extras:
          - alias to leaf
  -   name: swp5
      options:
          extras:
          - alias to leaf
  -   name: swp6
      options:
          extras:
          - alias to leaf
loopback:
  ips:
  - 10.10.10.103/32
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
spine04
<pre><code>
bridge:
  N/A
  ...
bonds:
  N/A
  ...
eth0:
  ips:
  - 192.168.200.24/24
interfaces:
  -   name: swp1
      options:
          extras:
          - alias to leaf
  -   name: swp2
      options:
          extras:
          - alias to leaf
  -   name: swp3
      options:
          extras:
          - alias to leaf
  -   name: swp4
      options:
          extras:
          - alias to leaf
  -   name: swp5
      options:
          extras:
          - alias to leaf
  -   name: swp6
      options:
          extras:
          - alias to leaf
loopback:
  ips:
  - 10.10.10.104/32
mlag:
  N/A
  ...
vlans:
  N/A
  ...
vnis:
  N/A
  ...
vrfs:
  -   extras:
      - address 127.0.0.1/8
      - address ::1/128
      name: mgmt
      routes:
      - 0.0.0.0/0 192.168.200.1
</code></pre>
</details>
