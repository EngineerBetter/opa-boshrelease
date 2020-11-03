# Open Policy Agent Boshrelease

A bosh release for deploying the [Open Policy Agent](https://www.openpolicyagent.org/docs/latest/).

This release was designed for the purpose of integrating with Concourse but there's no reason why it couldn't be used for other purposes.

## Example Usage

```yaml
releases:
...
- name:    opa
  version: 0.0.1
  url:     https://github.com/EngineerBetter/opa-boshrelease/releases/download/0.0.1/opa-final-release-0.0.1.tgz
  sha1:    d37a19327d5edf162a7caa9fb3c34fdd4bed76cd

jobs:
- name: web
  jobs:
  - name: web
    release: concourse
    properties:
      opa:
        url: http://localhost:8181/v1/data/concourse/decision
      policy_check:
        filter_http_methods: PUT
        filter_actions: SaveConfig
  - name: opa
    release: opa
    properties:
      opa_policy: |
        package concourse

        default decision = {"allowed": true}

        decision = {"allowed": false, "reasons": reasons} {
          count(deny) > 0
          reasons := deny
        }

        deny["cannot use privileged resource types"] {
          input.action == "SaveConfig"
          input.data.resource_types[_].privileged
        }
```
