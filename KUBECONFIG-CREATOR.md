# Purpose

The purpose of the tool is to create Kubeconfig file from the
Kubernetes System Account secrets which are mounted to the POD.

## Usage

Usage:
```
    ./kubeconfig-creator.sh -b <base dir> [-h <API server>] [-u <name for service account>] 
```

Paramaters:
* **-b** *Base dir* for the of the mounted Service Account secrets
* **-h** (Optional) URL to the API server. By default this points to
  the internal cluster server: `https://kubernetes.default.svc/`
* **-u** (Optional) Username for the used profile. `default` is default.

## Examples

Inside the pod:
```
./kubeconfig-creator.sh -b /secrets/test-keys >kubeconfig.conf
```

If you want to test this locally at your computer, you have first 
copy files _ca.crt_ and _token_ from the mounted secret directory at the POD. 

```
    ./kubeconfig-creator.sh -b ~/tmp/test-keys -h https://blobs.hcp.northeurope.azmk8s.io:443 >kubeconfig.conf
```

Example of using the configuration file with helm:
```
    helm ls --kubeconfig kubeconfig.conf
``` 

