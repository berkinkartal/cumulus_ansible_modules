
# Cumulus SNMP Role

Configure Simple Network Management Protocol

Variable | Choices/Defaults | Type
--- | --- | ---
snmp.addresses|list of snmp servers.|List of Strings
snmp.rocommunity|list of read-only community strings.|List of Strings

## Examples
<details><summary markdown="span">evpn_centralized</summary>
border01
<pre><code>snmp:
  addresses:
  - 192.168.200.63@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
border02
<pre><code>snmp:
  addresses:
  - 192.168.200.64@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
fw1
<pre><code>snmp:
  addresses:
  - 192.168.200.61@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf01
<pre><code>snmp:
  addresses:
  - 192.168.200.11@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf02
<pre><code>snmp:
  addresses:
  - 192.168.200.12@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf03
<pre><code>snmp:
  addresses:
  - 192.168.200.13@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf04
<pre><code>snmp:
  addresses:
  - 192.168.200.14@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server01
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server02
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server04
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server05
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine01
<pre><code>snmp:
  addresses:
  - 192.168.200.21@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine02
<pre><code>snmp:
  addresses:
  - 192.168.200.22@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine03
<pre><code>snmp:
  addresses:
  - 192.168.200.23@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine04
<pre><code>snmp:
  addresses:
  - 192.168.200.24@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
</details>
<details><summary markdown="span">evpn_l2only</summary>
border01
<pre><code>snmp:
  addresses:
  - 192.168.200.63@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
border02
<pre><code>snmp:
  addresses:
  - 192.168.200.64@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
fw1
<pre><code>snmp:
  addresses:
  - 192.168.200.61@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf01
<pre><code>snmp:
  addresses:
  - 192.168.200.11@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf02
<pre><code>snmp:
  addresses:
  - 192.168.200.12@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf03
<pre><code>snmp:
  addresses:
  - 192.168.200.13@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf04
<pre><code>snmp:
  addresses:
  - 192.168.200.14@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server01
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server02
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server04
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server05
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine01
<pre><code>snmp:
  addresses:
  - 192.168.200.21@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine02
<pre><code>snmp:
  addresses:
  - 192.168.200.22@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine03
<pre><code>snmp:
  addresses:
  - 192.168.200.23@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine04
<pre><code>snmp:
  addresses:
  - 192.168.200.24@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
</details>
<details><summary markdown="span">evpn_mh</summary>
border01
<pre><code>snmp:
  addresses:
  - 192.168.200.63@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
border02
<pre><code>snmp:
  addresses:
  - 192.168.200.64@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
fw1
<pre><code>snmp:
  addresses:
  - 192.168.200.61@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf01
<pre><code>snmp:
  addresses:
  - 192.168.200.11@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf02
<pre><code>snmp:
  addresses:
  - 192.168.200.12@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf03
<pre><code>snmp:
  addresses:
  - 192.168.200.13@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf04
<pre><code>snmp:
  addresses:
  - 192.168.200.14@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server01
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server02
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server04
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server05
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine01
<pre><code>snmp:
  addresses:
  - 192.168.200.21@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine02
<pre><code>snmp:
  addresses:
  - 192.168.200.22@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine03
<pre><code>snmp:
  addresses:
  - 192.168.200.23@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine04
<pre><code>snmp:
  addresses:
  - 192.168.200.24@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
</details>
<details><summary markdown="span">evpn_symmetric</summary>
border01
<pre><code>snmp:
  addresses:
  - 192.168.200.63@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
border02
<pre><code>snmp:
  addresses:
  - 192.168.200.64@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
fw1
<pre><code>snmp:
  addresses:
  - 192.168.200.61@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf01
<pre><code>snmp:
  addresses:
  - 192.168.200.11@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf02
<pre><code>snmp:
  addresses:
  - 192.168.200.12@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf03
<pre><code>snmp:
  addresses:
  - 192.168.200.13@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
leaf04
<pre><code>snmp:
  addresses:
  - 192.168.200.14@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server01
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server02
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server04
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
server05
<pre><code>snmp:
  addresses:
  - False@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine01
<pre><code>snmp:
  addresses:
  - 192.168.200.21@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine02
<pre><code>snmp:
  addresses:
  - 192.168.200.22@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine03
<pre><code>snmp:
  addresses:
  - 192.168.200.23@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
spine04
<pre><code>snmp:
  addresses:
  - 192.168.200.24@mgmt
  - udp6:[::1]:161@mgmt
  rocommunity:
  - public
  - private
</code></pre>
</details>
