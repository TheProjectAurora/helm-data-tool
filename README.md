# Purpose

This tool is for manipulating the YAML and JSON files. The operations are merging,
replacing the key values and adding new values. This can't delete the keys.
This uses Helm (https://helm.sh/) to do the manipulation.

This example expects, that `helm-yaml-tool.sh` and `helm-json-tool.sh` are in `PATH`. 

# Usage

## Outcome is YAML:
```
  helm-data-yaml.sh [-f <yaml 1> [-f <yaml 2> [-f <json 3> ... ]]] \
    [--set key1=val1[,key2=val2...] [--set key3=val3,key4=val4,...]...]    
```
## Outcome is JSON:
```
  helm-data-json.sh [-f <yaml 1> [-f <yaml 2> [-f <json 3> ... ]]] \
    [--set key1=val1[,key2=val2...] [--set key3=val3,key4=val4,...]...]    
```

Parameters:
* **-f** -  This merges all files which are 
  mentioned with the `-f` flag together.  Values could be ein YAML or JSON format. If there is same keys, the 
  later file is overriding all previous ones. (See example.)
* **--set** - This sets the values for the key(s). Values could be in YAML format.

The last _--set_ or _-f_ sets the final value for the key.

# Examples
* [Outcome is YAML](README_YAML_TOOL.md)
* [Outcome is JSON](README_JSON_TOOL.md)

# RAW usage directly with [helm](https://helm.sh/)
## Outcome is YAML:
This is the usage example without the wrapper. 

```
  helm template -f ./eg_files/set1.yaml -f ./eg_files/set2.yaml \
    --set Passwords={},Passwords[0].User=tvesala,Passwords[0].Password=abc  \
    --set Passwords[1].User=shoisko,Passwords[1].Password=123dsa  \
    --set Last_set="Dynamically created" helmchart_yaml
```

Output:
```yaml
---
# Source: helm-data-yaml/templates/values_to_yaml.yaml
Apps:
  Set1: Application1
  Set2: Application2
Last_set: Dynamically created
Passwords:
- Password: abc
  User: tvesala
- Password: 123dsa
  User: shoisko
```

## Outcome is JSON:
This is the usage example without the wrapper. 

```
  helm template -f ./eg_files/set1.yaml -f ./eg_files/set2.yaml \
    --set Passwords={},Passwords[0].User=tvesala,Passwords[0].Password=abc  \
    --set Passwords[1].User=shoisko,Passwords[1].Password=123dsa  \
    --set Last_set="Dynamically created" helmchart_json
```

Output:
```json
---
# Source: helm-data-json/templates/values_to_json.yaml
{"Apps":{"Set1":"Application1","Set2":"Application2"},"Last_set":"Dynamically created","Passwords":[{"Password":"abc","User":"tvesala"},{"Password":"123dsa","User":"shoisko"}]}
```