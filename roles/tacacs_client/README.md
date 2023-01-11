
# TACACS+ Client Role

Configures the switches as TACACS+ client with the following parameters:

Variable | Choices | Type
--- | --- | ---
tacacs.server_ips|List of TACACS+ servers|List of Strings
tacacs.vrf|VRF to source TACACS+ packets from|String
tacacs.secret|TACACS+ secrect key|String

## Example

```
tacacs.server_ips:
  - 192.168.200.1
tacacs.vrf: mgmt
tacacs.secret: tacacskey
```
