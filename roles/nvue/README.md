# NVUE Role

Configures the switches by [rendering](/roles/nvue/templates/features/nvue.j2) a single `startup.yaml` used by [NVUE CLI](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/NVIDIA-User-Experience-NVUE/NVUE-CLI/), pushing it to the switch `/etc/nvue.d/` folder and appling it. The `startup.yaml` file is the switch startup-configuration. </br>

The following features and services are configured using the NVUE role:
  - [Management network (eth0) IP address and default route](/roles/nvue/templates/features/eth0.j2) 
  - [Switchports](/roles/nvue/templates/features/swp.j2)
  - [Loopback IP address](/roles/nvue/templates/features/loopback.j2)
  - [DNS servers](/roles/nvue/templates/features/services.j2)
  - [NTP servers](/roles/nvue/templates/features/ntp_switch.j2)
  - [Timezone](/roles/nvue/templates/features/nvue.j2)
  - [Syslog server](/roles/nvue/templates/features/syslog.j2)
  - [Hostname](/roles/nvue/templates/features/nvue.j2)
  - [MOTD (pre and post login)](/roles/nvue/templates/features/message.j2)
  - [Bridge, VLANs and VNI mappings](/roles/nvue/templates/features/vlans.j2)
  - [Peerlink](/roles/nvue/templates/features/peerlink.j2) and [MLAG](/roles/nvue/templates/features/mlag.j2)
  - [SVI, IGMP and VRR](/roles/nvue/templates/features/svi.j2)
  - [BGP unedrlay, PIM-SM, VRFs and EVPN control-plane](/roles/nvue/templates/features/bgp.j2)
  - [NVE interface and parameters](/roles/nvue/templates/features/nve.j2)
  - [SNMP Configuration](/roles/nvue/templates/snmp.j2)
  - [TACACS+ Client](/roles/nvue/templates/tacplus.j2)

Note: TACACS Client and SNMP configuration are done using [NVUE Snippets](https://docs.nvidia.com/networking-ethernet-software/cumulus-linux-51/System-Configuration/NVIDIA-User-Experience-NVUE/NVUE-Snippets/).

## Example 

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
      swp1,51-54:
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

