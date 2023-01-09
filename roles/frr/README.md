
# Cumulus FRR Role

Ansible template module for `/etc/frr/frr.conf` and `/etc/frr/daemons` on Cumulus Linux using FRR.

Variable | Choices | Type
--- | --- | ---
bgp|bgp variables.|dictionary
bonds|list of all bonds (non-mlag/multi-homing)|list of dictionaries
evpn_mh||dictionary
interfaces|list of all interfaces (non-bonds/bridges/svis/vnis/etc).|list of dictionaries
loopback|loopback interface options.|dictionary
mlag|all mlag related variables.|dictionary
vlans|list of all SVIs.|list of dictionaries
vnis|list of all vnis.|list of dictionaries
vrfs|list of all vrf loopback interfaces.|list of dictionaries

### Tasks
* Copy module to set `/etc/frr/daemons` then restart frr daemon `systemctl restart frr` if  `/etc/frr/daemons` has changed.
* Template `/etc/frr/frr.conf` (FRR config file)
* Reload FRR using `systemctl reload frr` after verifying the newly pushed FRR config with `vtysh -f /etc/frr/frr.conf --dryrun`

## Examples
<details><summary markdown="span">evpn_centralized</summary>
border01
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      advertise_default_gw: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65163'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.63
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
border02
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      advertise_default_gw: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65164'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.64
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
fw1
<pre><code>
bgp:
  N/A
  ...
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
evpn_mh:
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65101'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.1
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
leaf02
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65102'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.2
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
leaf03
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65103'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.3
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
leaf04
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65104'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.4
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
server01
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server02
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server04
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server05
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
spine01
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.101
bonds:
  N/A
  ...
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.102
bonds:
  N/A
  ...
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.103
bonds:
  N/A
  ...
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.104
bonds:
  N/A
  ...
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65163'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.63
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
border02
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65164'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.64
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
fw1
<pre><code>
bgp:
  N/A
  ...
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
evpn_mh:
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65101'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.1
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
leaf02
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65102'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.2
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
leaf03
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65103'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.3
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
leaf04
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65104'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.4
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
server01
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server02
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server04
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server05
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
spine01
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.101
bonds:
  N/A
  ...
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.102
bonds:
  N/A
  ...
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.103
bonds:
  N/A
  ...
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.104
bonds:
  N/A
  ...
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65163'
  neighbors:
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.63
  vrfs:
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: static
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: RED
      router_id: 10.10.10.63
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: static
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: BLUE
      router_id: 10.10.10.63
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
evpn_mh:
  rp: true
  sysmac: 44:38:39:BE:EF:FF
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
msdp:
  mesh:
  - border01
  - border02
  source: 10.10.10.63
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: 10.10.10.63
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65164'
  neighbors:
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.64
  vrfs:
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: static
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: RED
      router_id: 10.10.10.64
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: static
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: BLUE
      router_id: 10.10.10.64
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
evpn_mh:
  rp: true
  sysmac: 44:38:39:BE:EF:FF
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
msdp:
  mesh:
  - border01
  - border02
  source: 10.10.10.64
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: 10.10.10.64
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
bgp:
  N/A
  ...
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
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: ''
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65101'
  neighbors:
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.1
  vrfs:
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: RED
      router_id: 10.10.10.1
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: BLUE
      router_id: 10.10.10.1
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
evpn_mh:
  startup_delay: 10
  sysmac: 44:38:39:BE:EF:AA
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: 10.10.10.1
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65102'
  neighbors:
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.2
  vrfs:
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: RED
      router_id: 10.10.10.2
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: BLUE
      router_id: 10.10.10.2
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
evpn_mh:
  startup_delay: 10
  sysmac: 44:38:39:BE:EF:AA
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: 10.10.10.2
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65103'
  neighbors:
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.3
  vrfs:
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: RED
      router_id: 10.10.10.3
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: BLUE
      router_id: 10.10.10.3
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
evpn_mh:
  startup_delay: 10
  sysmac: 44:38:39:BE:EF:BB
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: 10.10.10.3
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65104'
  neighbors:
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.4
  vrfs:
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: RED
      router_id: 10.10.10.4
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: BLUE
      router_id: 10.10.10.4
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
evpn_mh:
  startup_delay: 10
  sysmac: 44:38:39:BE:EF:BB
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: 10.10.10.4
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
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: ''
vrfs:
  N/A
  ...
</code></pre>
server02
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: ''
vrfs:
  N/A
  ...
</code></pre>
server04
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: ''
vrfs:
  N/A
  ...
</code></pre>
server05
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: ''
vrfs:
  N/A
  ...
</code></pre>
spine01
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.101
bonds:
  N/A
  ...
evpn_mh:
  true
  ...
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: 10.10.10.101
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.102
bonds:
  N/A
  ...
evpn_mh:
  true
  ...
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: 10.10.10.102
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.103
bonds:
  N/A
  ...
evpn_mh:
  true
  ...
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: 10.10.10.103
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.104
bonds:
  N/A
  ...
evpn_mh:
  true
  ...
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
msdp:
  N/A
  ...
pim:
  ecmp: true
  keep_alive: 3600
  rp_mcast_range: 239.1.1.0/24
  rpaddr: 10.10.100.100/32
  source: 10.10.10.104
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65163'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.63
  vrfs:
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: static
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: RED
      router_id: 10.10.10.63
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: static
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: BLUE
      router_id: 10.10.10.63
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65164'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.64
  vrfs:
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: static
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: RED
      router_id: 10.10.10.64
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: static
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: BLUE
      router_id: 10.10.10.64
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
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
bgp:
  N/A
  ...
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
evpn_mh:
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65101'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.1
  vrfs:
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: RED
      router_id: 10.10.10.1
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: BLUE
      router_id: 10.10.10.1
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65102'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.2
  vrfs:
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: RED
      router_id: 10.10.10.2
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: BLUE
      router_id: 10.10.10.2
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65103'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.3
  vrfs:
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: RED
      router_id: 10.10.10.3
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: BLUE
      router_id: 10.10.10.3
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   advertise_all_vni: true
      name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65104'
  neighbors:
  -   interface: peerlink.4094
      peergroup: underlay
      unnumbered: true
  -   interface: swp51
      peergroup: underlay
      unnumbered: true
  -   interface: swp52
      peergroup: underlay
      unnumbered: true
  -   interface: swp53
      peergroup: underlay
      unnumbered: true
  -   interface: swp54
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.4
  vrfs:
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: RED
      router_id: 10.10.10.4
  -   address_family:
      -   name: ipv4_unicast
          redistribute:
          -   type: connected
      -   extras:
          - advertise ipv4 unicast
          name: l2vpn_evpn
      name: BLUE
      router_id: 10.10.10.4
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
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
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
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server02
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server04
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
server05
<pre><code>
bgp:
  N/A
  ...
bonds:
  N/A
  ...
evpn_mh:
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
msdp:
  N/A
  ...
pim:
  N/A
  ...
vrfs:
  N/A
  ...
</code></pre>
spine01
<pre><code>
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.101
bonds:
  N/A
  ...
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.102
bonds:
  N/A
  ...
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.103
bonds:
  N/A
  ...
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
bgp:
  address_family:
  -   name: ipv4_unicast
      redistribute:
      -   type: connected
  -   name: l2vpn_evpn
      neighbors:
      -   activate: true
          interface: underlay
  asn: '65100'
  neighbors:
  -   interface: swp1
      peergroup: underlay
      unnumbered: true
  -   interface: swp2
      peergroup: underlay
      unnumbered: true
  -   interface: swp3
      peergroup: underlay
      unnumbered: true
  -   interface: swp4
      peergroup: underlay
      unnumbered: true
  -   interface: swp5
      peergroup: underlay
      unnumbered: true
  -   interface: swp6
      peergroup: underlay
      unnumbered: true
  peergroups:
  -   name: underlay
      remote_as: external
  router_id: 10.10.10.104
bonds:
  N/A
  ...
evpn_mh:
  N/A
  ...
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
msdp:
  N/A
  ...
pim:
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
