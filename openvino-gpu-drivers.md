# OpenVINO Graphics Drivers Installation
### Source: https://docs.openvino.ai/2026/get-started/install-openvino/configurations/configurations-intel-gpu.html

OpenVINO drivers are designed for Intel GPUs. Their performance may outpace Vulkan. Worth leveraging if the gains are truly there.
Hurdle: OpenVINO has a niche demographic, therefore, may prove bugged or lacking support.

> Below are the instructions on how to install the OpenCL packages on supported Linux distributions. These instructions install the Intel(R) Graphics Compute Runtime for oneAPI Level Zero and OpenCL(TM) Driver and its dependencies:
- Intel Graphics Memory Management Library
- Intel® Graphics Compiler for OpenCL™
- OpenCL ICD loader package

## Solution
Seems to be an issue with Intel documentation: 





## Work
```shell
sudo apt-get install -y ocl-icd-libopencl1 intel-opencl-icd intel-level-zero-gpu level-zero
sudo usermod -a -G render $LOGNAME
```

### ERROR
```shell
The following packages have unmet dependencies:
 intel-level-zero-gpu : Depends: libigdfcl1 (>= 1.0.9389) but it is not installable
 libigc2 : Conflicts: libigc1 but 1.0.15468.25-2ubuntu0.1 is to be installed
```








# ERRORED WORK
## used the Ubuntu 20.04 LTS instructions rather than the Ubuntu 24.04

```shell
sudo apt-get update && sudo apt-get install -y --no-install-recommends curl gpg gpg-agent

curl https://repositories.intel.com/graphics/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg && \
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu focal-legacy main' | tee  /etc/apt/sources.list.d/intel.gpu.focal.list && \
sudo apt-get update

sudo apt-get update && apt-get install -y --no-install-recommends intel-opencl-icd intel-level-zero-gpu level-zero

sudo usermod -a -G render $LOGNAME
```

## Step-by-step
Let's break down these commands (and their errors) one at a time.

#### sudo apt-get update && sudo apt-get install -y --no-install-recommends curl gpg gpg-agent
Update package definitions & install the following if they are missing: `curl` `gpg` `gpg-agent`
Simple. No Errors. Requires sudo privileges.

#### curl https://repositories.intel.com/graphics/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg
```shell
    ### ERROR ###

    File '/usr/share/keyrings/intel-graphics.gpg' exists. Overwrite? (y/N)   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1820  100  1820    0     0   5741      0 --:--:-- --:--:-- --:--:--  5759
y
gpg: can't create '/usr/share/keyrings/intel-graphics.gpg': Permission denied
gpg: no valid OpenPGP data found.
gpg: dearmoring failed: Permission denied
```

Even with `sudo` there's an issue with creating a gpg key when there's an existing file. Better to change the name & move on:
```shell
curl https://repositories.intel.com/graphics/intel-graphics.key | sudo gpg --dearmor --output 
/usr/share/keyrings/intel-graphics-aug-2026.gpg
```
--- Notice file is custom named to `intel-graphics-aug-2026.gpg` ---

Ensure following commands follow this naming convention

#### echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics-aug-2026.gpg] https://repositories.intel.com/graphics/ubuntu focal-legacy main' | tee  /etc/apt/sources.list.d/intel.gpu.focal.list && sudo apt-get update

```shell
$ echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics-aug-2026.gpg] https://repos
itories.intel.com/graphics/ubuntu focal-legacy main' | tee  /etc/apt/sources.list.d/intel.gpu.focal.list

tee: /etc/apt/sources.list.d/intel.gpu.focal.list: Permission denied
deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics-aug-2026.gpg] https://repositories.intel.com/graphics/ubuntu focal-legacy main
```

Solution: Had to run `tee` as `sudo`:
```shell
$ echo 'deb...' | sudo tee /etc/...
```


#### sudo apt-get update && sudo apt-get install -y --no-install-recommends intel-opencl-icd intel-level-zero-gpu level-zero

```shell
...
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 intel-level-zero-gpu : Depends: libigc1 (>= 1.0.9389) but it is not installable
                        Depends: libigdfcl1 (>= 1.0.9389) but it is not installable
E: Unable to correct problems, you have held broken packages.
```


