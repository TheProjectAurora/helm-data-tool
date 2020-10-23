# Purpose

This tool is for manipulating the YAML files. The operations are merging,
replacing the key values and adding new values. This can't delete the keys.
This uses Helm (https://helm.sh/) to do the manipulation.


# Usage

```
  helm template -f <yaml 1> \
    [-f <yaml 2> [-f <yaml 3> ... ]] \
    [--set key1=val1[,key2=val2...] [--set key3=val3,key4=val4,...]...] \
    <path to helmchart>
```

Parameters:
* **-f** - at least one must exists. This merges all files which are 
  mentioned with the `-f` flag together.  If there is same keys, the 
  later file is overriding all previous ones. (See example.)
* **--set** - This sets the values for the key(s). This always overrides
  the values at the files. 


## Examples

This examples can be executed directly from the current directory.

### Merging the files

This merges _set1.yaml_ and _set2.yaml_ together. 

```
  helm template -f ./eg_files/set1.yaml -f ./eg_files/set2.yaml helmchart
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
  helm template -f ./eg_files/set2.yaml -f ./eg_files/set1.yaml helmchart
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
  helm template -f ./eg_files/set1.yaml --set Apps.Set3="Hello world" helmchart
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
  helm template -f ./eg_files/set1.yaml --set Apps.Set1="Hello world" helmchart
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
  helm template -f ./eg_files/array.yaml --set Users[0].Role="Public Clown"  helmchart
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
  helm template -f ./eg_files/array.yaml \
    --set Users[2].Name="Charlie Brown",Users[2].Username=cbrown,Users[2].Role="Comic Character"  \
    helmchart
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
  helm template -f ./eg_files/array.yaml \
    --set Passwords='{abc,def}'  \
    helmchart
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
  helm template -f ./eg_files/array.yaml \
    --set Passwords={},Passwords[0].User=tvesala,Passwords[0].Password=abc  \
    --set Passwords[1].User=shoisko,Passwords[1].Password=123dsa  \
    helmchart
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

### Writing to file

The temlate is written to the standard output. Writing it to the file can be
done two different ways:

```
    helm template -f ./eg_files/set1.yaml -f ./eg_files/set2.yaml helmchart >output.yaml
```

This writes the output to _output.yaml_ file and does not print anything to the screen.
To write to the file and screen:

```
    helm template -f ./eg_files/set1.yaml -f ./eg_files/set2.yaml helmchart | tee output.yaml
```
