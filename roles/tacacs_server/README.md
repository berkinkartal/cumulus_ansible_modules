
# TACACS+ Server Role

Configures TACACS+ Server on the ansible-server (`oob-mgmt-server` if using in NVIDIA Air) with the following parameters:

Variable | Choices | Type
--- | --- | ---
tacacs.groups|List of groups to map users into|String
tacacs.users|List of all users|List of Strings
tacacs.secret|TACACS+ secrect key|List of Strings

## Example

```
tacacs.groups:
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
```
