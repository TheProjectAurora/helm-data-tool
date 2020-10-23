# Purpose

This tool is for manipulating the YAML files. The operations are merging,
replacing the key values and adding new values. This can't delete the keys.
This uses Helm (https://helm.sh/) to do the manipulation.

This example expects, that `helm-yaml-tool.sh` is in `PATH`. 

# Usage

```
  helm-yaml-tool.sh [-f <yaml 1> [-f <yaml 2> [-f <yaml 3> ... ]]] \
    [--set key1=val1[,key2=val2...] [--set key3=val3,key4=val4,...]...]    
```

Parameters:
* **-f** -  This merges all files which are 
  mentioned with the `-f` flag together.  If there is same keys, the 
  later file is overriding all previous ones. (See example.)
* **--set** - This sets the values for the key(s).

The last _--set_ or _-f_ sets the final value for the key.

## Examples

This examples can be executed directly from the current directory.

### Merging the files

This merges _set1.yaml_ and _set2.yaml_ together. 

```
  helm-yaml-tool.sh -f ./eg_files/set1.yaml -f ./eg_files/set2.yaml 
```

The output:
```yaml
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
Apps:
  Set1: Application1
  Set2: Application2
Last_set: Set2
```

The key _Last\_set_ is defined at both YAML files. So the value
is same as at the last file which is defined with _-f_. If you
run:

```
  helm-yaml-tool.sh -f ./eg_files/set2.yaml -f ./eg_files/set1.yaml
```

The output:
```yaml
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
Apps:
  Set1: Application1
  Set2: Application2
Last_set: Set1
```

### Setting the key values

There's several differnet ways to set the values for the single keys.
You combine multiple setting under single _--set_ statement, or define
_--set_ multiple times. 

### Single value

Adding new value:

```
  helm-yaml-tool.sh -f ./eg_files/set1.yaml --set Apps.Set3="Hello world"
```

The output:
```yaml
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
Apps:
  Set1: Application1
  Set3: Hello world
Last_set: Set1
```

Replacing the value:
```
  helm-yaml-tool.sh -f ./eg_files/set1.yaml --set Apps.Set1="Hello world"
```

The output:
```yaml
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
Apps:
  Set1: Hello world
Last_set: Set1
```


### Array manipulation

Arrays manipulations are a bit more complex. First we change
the title of Teemu Vesala at file _array.yaml_:

```
  helm-yaml-tool.sh -f ./eg_files/array.yaml --set Users[0].Role="Public Clown"
```

Output:
```yaml
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
Last_set: Array Yaml
Users:
- Name: Teemu Vesala
  Role: Public Clown
  Username: tvesala
- Name: Sakari Hoisko
  Role: Senior DevOps Consultant
  Username: shoisko
```

Adding item:
```
  helm-yaml-tool.sh -f ./eg_files/array.yaml \
    --set Users[2].Name="Charlie Brown",Users[2].Username=cbrown,Users[2].Role="Comic Character"
```

Output:
```yaml
---
Last_set: Array Yaml
Users:
- Name: Teemu Vesala
  Role: Senior DevOps Consultant
  Username: tvesala
- Name: Sakari Hoisko
  Role: Senior DevOps Consultant
  Username: shoisko
- Name: Charlie Brown
  Role: Comic Character
  Username: cbrown
```

The new list can be added:
```
  helm-yaml-tool.sh -f ./eg_files/array.yaml \
    --set Passwords='{abc,def}'
```

Output:
```yaml
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
Last_set: Array Yaml
Passwords:
- abc
- def
Users:
- Name: Teemu Vesala
  Role: Senior DevOps Consultant
  Username: tvesala
- Name: Sakari Hoisko
  Role: Senior DevOps Consultant
  Username: shoisko

```

Creating the list of structure. Here we are using multiple _--set_ commands
to help the readability of the command.
```
  helm-yaml-tool.sh -f ./eg_files/array.yaml \
    --set Passwords={},Passwords[0].User=tvesala,Passwords[0].Password=abc  \
    --set Passwords[1].User=shoisko,Passwords[1].Password=123dsa
```

Output:
```yaml
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
Last_set: Array Yaml
Passwords:
- Password: abc
  User: tvesala
- Password: 123dsa
  User: shoisko
Users:
- Name: Teemu Vesala
  Role: Senior DevOps Consultant
  Username: tvesala
- Name: Sakari Hoisko
  Role: Senior DevOps Consultant
  Username: shoisko
```


### Generating the YAML without templates

 This tool can construct the new YAML file dynamically with _--set_-parameters.

```
  helm-yaml-tool.sh \
    --set Passwords={},Passwords[0].User=tvesala,Passwords[0].Password=abc  \
    --set Passwords[1].User=shoisko,Passwords[1].Password=123dsa
```

Output:
```yaml
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
Passwords:
- Password: abc
  User: tvesala
- Password: 123dsa
  User: shoisko

```

### Complex case

This example merges two files and adds new data to it, but also replaces the keys.


```
  helm-yaml-tool.sh -f ./eg_files/set1.yaml -f ./eg_files/set2.yaml \
    --set Passwords={},Passwords[0].User=tvesala,Passwords[0].Password=abc  \
    --set Passwords[1].User=shoisko,Passwords[1].Password=123dsa  \
    --set Last_set="Dynamically created"
```

Output:
```yaml
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
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

### Writing to file

The temlate is written to the standard output. Writing it to the file can be
done two different ways:

```
    helm-yaml-tool.sh -f ./eg_files/set1.yaml -f ./eg_files/set2.yaml >output.yaml
```

This writes the output to _output.yaml_ file and does not print anything to the screen.
To write to the file and screen:

```
    helm-yaml-tool.sh -f ./eg_files/set1.yaml -f ./eg_files/set2.yaml | tee output.yaml
```

### Extra things

This can also merge multiple JSON files and convert them to YAML file.

```
  helm-yaml-tool.sh -f eg_files/test.json
```

Output:
```yaml
---
# Source: helm-yaml-tool/templates/values_to_yaml.yaml
Users:
- Name: Teemu Vesala
  Username: tvesala
- Name: Sakari Hoisko
  Username: shoisko
```

The JSON can be manipulaed same way as YAML. You can merge multiple
JSON files, change their keys etc.
