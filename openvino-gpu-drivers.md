# OpenVINO Graphics Drivers Installation

### Sources citing OpenVINO's superiority over Vulkan
- [L1Techs Blog:](https://forum.level1techs.com/t/llama-cpp-for-openvino-how-does-a-half-baked-build-stack-up-against-vulkan/248447)]
- [YouTube video](https://youtu.be/kFP8nB8QZAs?si=rkq0yRJjUprEXli4)
- [Rittnauer Blog Post](https://rittnauer.at/posts/local-llm-homelab-llama-cpp-sycl-hermes/)

#### Genearal Sources: https://docs.openvino.ai/2026/get-started/install-openvino/configurations/configurations-intel-gpu.html

OpenVINO drivers are designed for Intel GPUs. Their performance may outpace Vulkan. Worth leveraging if the gains are truly there.
Hurdle: OpenVINO has a niche demographic, therefore, may prove bugged or lacking support.

#### Rittnauer
Be wary of bugged versions of oneAPI Toolchain
__DO NOT__ install `intel-level-zero-gpu`: Level Zero is split across libze-intel-gpu1, libze1, and libze-dev — there is no single level-zero package


#### L1Techs - ERROR WIP
##### this is for llama, not ollama
Be sure to install `libtbb-dev`
Replace `include("${OpenVINO_DIR}/../3rdpart/tbb/lib/cmake/TBB/TBBConfig.cmake")` with `find_packge(TBB REQUIRED)` inside ggml/src/ggml-openvino/CMakeLists.txt within the pulled llama.cpp


#### Official Intel:
> Below are the instructions on how to install the OpenCL packages on supported Linux distributions. These instructions install the Intel(R) Graphics Compute Runtime for oneAPI Level Zero and OpenCL(TM) Driver and its dependencies:
- Intel Graphics Memory Management Library
- Intel® Graphics Compiler for OpenCL™
- OpenCL ICD loader package



## Solution
Seems to be an issue with Intel documentation.

Claude Recommendation:
> Good news — this is a well-known conflict as of mid-2026, and it's caused by mixing two different package sources rather than anything wrong with your system.
> Ubuntu's own repos now ship newer compute-runtime packages (libigc2, libigdfcl2, libze1, intel-opencl-icd), and these conflict with the older intel-level-zero-gpu package that comes from Intel's separate GPU apt repo.
> __The fix__: stop trying to install Intel's own `intel-level-zero-gpu` alongside Ubuntu's universe packages — they're two competing generations of the same thing. Use `libze-intel-gpu1` instead, the modern package from Ubuntu's own repos, which depends only on libigc2 and doesn't carry the old hard dependency on libigc1.
Source: [raimund](https://rittnauer.at/posts/local-llm-homelab-llama-cpp-sycl-hermes/)













# --- Seperation ---



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




### Additional Reading
- [Rittnauer Blog Post](https://rittnauer.at/posts/local-llm-homelab-llama-cpp-sycl-hermes/)
oneAPI Version Selection

This is the most critical decision. The Intel oneAPI toolchain has version-specific issues:
```
2025.1 	Stable, but llama.cpp commits after mid-2025 reference intel_gpu_bmg_g31 and intel_gpu_wcl GPU arch symbols that were added to compiler headers in 2025.2
2025.2 	Recommended — stable on Iris Xe, compatible with current llama.cpp
2025.3 	Broken — GPF crash in Level Zero GPU context teardown after inference
```


#### L1Techs Blog post for OpenVINO on Ubuntu
[source:](https://forum.level1techs.com/t/llama-cpp-for-openvino-how-does-a-half-baked-build-stack-up-against-vulkan/248447)
5 April 2026

Bottom Line: OpenVINO is the way to go. The larger the model, the faster OpenVINO can generate tokens compared with Vulkan.
Quote:
> openVINO wasn’t compatible with Ubuntu-based distros out the box. It’d point that out and refuse to proceed with OpenVINO installation - just install through APT. Just be sure to install `libtbb-dev`, and replace `include(“${OpenVINO_DIR}/../3rdparty/tbb/lib/cmake/TBB/TBBConfig.cmake”)` with `find_package(TBB REQUIRED)` inside ggml/src/ggml-openvino/CMakeLists.txt within the llama.cpp source that you pulled.
> You may find OpenVINO is in the wrong place for you to find your setupvars.sh, so you’ll have to find them yourself. Instead of `source /opt/intel/openvino/setupvars.sh` where the docs think it should be, it may specifies its version in the path: `source /opt/intel/openvino_2026.0/setupvars.sh`, and you’ll have to account for that.