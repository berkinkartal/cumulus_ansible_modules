
# Cumulus NTP Role

Configure Network Time Protocol

Variable | Choices/Defaults | Type
--- | --- | ---
ntp.timezone|timezone the switch ntp resides in.|String
ntp.server_ips|list of all ntp server ips.|List of Strings

## Examples
<details><summary markdown="span">evpn_centralized</summary>
border01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
border02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
fw1
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf03
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf04
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server04
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server05
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine03
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine04
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
</details>
<details><summary markdown="span">evpn_l2only</summary>
border01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
border02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
fw1
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf03
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf04
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server04
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server05
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine03
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine04
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
</details>
<details><summary markdown="span">evpn_mh</summary>
border01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
border02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
fw1
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf03
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf04
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server04
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server05
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine03
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine04
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
</details>
<details><summary markdown="span">evpn_symmetric</summary>
border01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
border02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
fw1
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf03
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
leaf04
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server04
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
server05
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine01
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine02
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine03
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
spine04
<pre><code>ntp:
  server_ips:
  - 0.cumulusnetworks.pool.ntp.org
  - 1.cumulusnetworks.pool.ntp.org
  - 2.cumulusnetworks.pool.ntp.org
  - 3.cumulusnetworks.pool.ntp.org
  timezone: America/Los_Angeles
</code></pre>
</details>
