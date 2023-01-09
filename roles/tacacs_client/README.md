
# Cumulus TACACS+ Client Role

Configure TACACS+ Client

Variable | Choices | Type
--- | --- | ---
tacacs.server_ips|list of tacacs servers.|List of Strings
tacacs.vrf|vrf to source TACACS+ packets from.|String
tacacs.secret|tacacs secrect key.|String

## Examples
<details><summary markdown="span">evpn_centralized</summary>
border01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
border02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
fw1
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf03
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf04
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server04
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server05
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine03
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine04
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
</details>
<details><summary markdown="span">evpn_l2only</summary>
border01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
border02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
fw1
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf03
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf04
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server04
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server05
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine03
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine04
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
</details>
<details><summary markdown="span">evpn_mh</summary>
border01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
border02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
fw1
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf03
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf04
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server04
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server05
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine03
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine04
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
</details>
<details><summary markdown="span">evpn_symmetric</summary>
border01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
border02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
fw1
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf03
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
leaf04
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server04
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
server05
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine01
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine02
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine03
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
spine04
<pre><code>tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
...
tacacs.secret: tacacskey
...
</code></pre>
</details>

