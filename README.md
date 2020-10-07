# Purpose
Handling all kind of yaml file actions. Could merge, fullfill and add keys/values to yaml.

# USAGE:
Importhatn thing is realize how last file in merge OR last key/value in command ovedefine all previous same key values. 

## Merge [set1.yaml](eg_files/set1.yaml) and [set2.yaml](eg_files/set2.yaml) files:
`helm template -f ./eg_files/set1.yaml -f ./eg_files/set2.yaml helmchart` <BR><BR>
OUTPUT:
```
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
Apps:
  Set1: Application1
  Set2: Application2
Last_set: Set2
```
From output is visible so last yaml define "Last_set" value to "Set2"

## Set values:
` helm template --set key1.name=NAME,key1.value=VALUE,key2=VALUE2,key3=\{1,2,3\},key3[2].name=NAME,key3[2].key=VALUE helmchart` <BR><BR>
OUTPUT:
```
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
key1:
  name: NAME
  value: VALUE
key2: VALUE2
key3:
- 1
- 2
- key: VALUE
  name: NAME
```
From output is visible:
* How sub keys with values could be added/changed under key1.
* How single key/values coud be created as key2.
* How list could be created.
* How to point to list item and add/change those keys/values.

## Mixed merge [set1.yaml](eg_files/set1.yaml)&[set2.yaml](eg_files/set2.yaml) files and set values:
`helm template -f ./eg_files/set1.yaml -f ./eg_files/set2.yaml --set Last_set=OverdefineMergedfilesKey2Value,key3=AddedKeyWithValue helmchart` <BR><BR>
OUTPUT:
```
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
Apps:
  Set1: Application1
  Set2: Application2
Last_set: OverdefineMergedfilesKey2Value
key3: AddedKeyWithValue
```
Ralize:
* How Last_set is overdefined from merged files by using set.
* How key3 is added to merged files output.

## Write output to file:

Lines comes from helm by automaticly becouse this whole *thing is not correct way to use helm but this is handy way to use it.* 

### Writing `helm template ...` command output to file happened by using redirect of linux stdout to files:
* Without print to screen: *helm command* **> file.yaml**"
* With print to screen: *helm command* **| tee file.yaml**"

FYI: These lines in beginning of yaml file are ignored so you don't need to anything to those.
```
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
```