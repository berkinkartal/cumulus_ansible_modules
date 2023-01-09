
# Cumulus TACACS+ Server Role

Configure TACACS+ Server

Variable | Choices | Type
--- | --- | ---
tacacs.groups|list of groups to map users into.|String
tacacs.users|list of all users.|List of Strings
tacacs.secret|tacacs secrect key.|List of Strings

## Examples
<details><summary markdown="span">evpn_centralized</summary>
border01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
border02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
fw1
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf03
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf04
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server04
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server05
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine03
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine04
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
</details>
<details><summary markdown="span">evpn_l2only</summary>
border01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
border02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
fw1
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf03
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf04
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server04
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server05
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine03
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine04
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
</details>
<details><summary markdown="span">evpn_mh</summary>
border01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
border02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
fw1
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf03
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf04
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server04
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server05
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine03
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine04
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
</details>
<details><summary markdown="span">evpn_symmetric</summary>
border01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
border02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
fw1
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf03
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
leaf04
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server04
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
server05
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine01
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine02
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine03
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
spine04
<pre><code>tacacs.groups:
  -   name: admins
      priv_level: 15
  -   name: basics
      priv_level: 1
tacacs.users:
  -   group: basics
      name: basicuser
      password: password
  -   group: admins
      name: adminuser
      password: password
tacacs.secret: tacacskey
...
</code></pre>
</details>

