
# Cumulus DNS Role

Edit various DNS settings in resolv.conf

Variable | Choices | Type
--- | --- | ---
dns.domain|Single FQDN used for this switch's domain name.|String
dns.search_domain|DNS search domain.|List of Strings
dns.servers.ipv4|DNS server IP addresses.|List of Strings
dns.servers.vrf|VRF used to communicate to DNS server.|List of Strings

## Examples
<details><summary markdown="span">evpn_centralized</summary>
border01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
border02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
fw1
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf03
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf04
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server04
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server05
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine03
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine04
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
</details>
<details><summary markdown="span">evpn_l2only</summary>
border01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
border02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
fw1
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf03
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf04
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server04
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server05
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine03
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine04
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
</details>
<details><summary markdown="span">evpn_mh</summary>
border01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
border02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
fw1
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf03
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf04
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server04
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server05
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine03
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine04
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
</details>
<details><summary markdown="span">evpn_symmetric</summary>
border01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
border02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
fw1
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf03
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
leaf04
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server04
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
server05
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine01
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine02
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine03
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
spine04
<pre><code>dns:
  domain: cumulusnetworks.com
  search_domain:
  - cumulusnetworks.com
  servers:
      ipv4:
      - 1.1.1.1
      - 8.8.8.8
      vrf: mgmt
</code></pre>
</details>
