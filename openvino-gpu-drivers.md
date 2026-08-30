# OpenVINO Graphics Drivers Installation
### Source: https://docs.openvino.ai/2026/get-started/install-openvino/configurations/configurations-intel-gpu.html

OpenVINO drivers are designed for Intel GPUs. Their performance may outpace Vulkan. Worth leveraging if the gains are truly there.
Hurdle: OpenVINO has a niche demographic, therefore, may prove bugged or lacking support.

```
Below are the instructions on how to install the OpenCL packages on supported Linux distributions. These instructions install the Intel(R) Graphics Compute Runtime for oneAPI Level Zero and OpenCL(TM) Driver and its dependencies:

- Intel Graphics Memory Management Library
- Intel® Graphics Compiler for OpenCL™
- OpenCL ICD loader package
```

```
sudo apt-get update && sudo apt-get install -y --no-install-recommends curl gpg gpg-agent

curl https://repositories.intel.com/graphics/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg && \
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/graphics/ubuntu focal-legacy main' | tee  /etc/apt/sources.list.d/intel.gpu.focal.list && \
sudo apt-get update

sudo apt-get update && apt-get install -y --no-install-recommends intel-opencl-icd intel-level-zero-gpu level-zero

sudo usermod -a -G render $LOGNAME
```

{
    // ERROR
    curl https://repositories.intel.com/graphics/intel-graphics.key | gpg --dearmor --output /usr/share/keyrings/intel-graphics.gpg

    File '/usr/share/keyrings/intel-graphics.gpg' exists. Overwrite? (y/N)   % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1820  100  1820    0     0   5741      0 --:--:-- --:--:-- --:--:--  5759
y
gpg: can't create '/usr/share/keyrings/intel-graphics.gpg': Permission denied
gpg: no valid OpenPGP data found.
gpg: dearmoring failed: Permission denied
}