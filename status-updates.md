# Status Updates
General log of work

## 30 Aug 2026
### Installing OpenVINO drivers / packages
[Rittnauer Blog Post](https://rittnauer.at/posts/local-llm-homelab-llama-cpp-sycl-hermes/) shows us the intricacies in installing OpenVINO in an Ubuntu environment.
Percipitating factor: we were unable to install libigc1. Kept conflicting with the newer libigc2. Old Intel docs recommend older libigc1; newer Ubuntu stack ships with newer libigc2

Fix: install `libze-intel-gpu1` (the modern package)
##### this is for llama, not ollama

Claude rec was to do what Rittnauer's fix was: install libze-intel-gpu1

```
sudo apt remove intel-level-zero-gpu intel-opencl-icd libigc1 libigdfcl1
sudo apt update
sudo apt install libze1 libze-intel-gpu1 intel-opencl-icd libigc2 libigdfcl2
```

##### Intel docs on OpenVINO install
```
wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
sudo gpg --output /etc/apt/trusted.gpg.d/intel.gpg --dearmor GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
echo "deb https://apt.repos.intel.com/openvino ubuntu24 main" | sudo tee /etc/apt/sources.list.d/intel-openvino.list
sudo apt update

# Install OpenVINO runtime
sudo apt install openvino-2026.3.1
```

##### Also consider this
https://docs.openvino.ai/2026/get-started/install-openvino.html?PACKAGE=OPENVINO_BASE&VERSION=v_2026_3_1&OP_SYSTEM=LINUX&DISTRIBUTION=APT





## 29 Aug 2026
### OLLAMA startup failure
In the past, we've been able to serve ollama & run queries in VSCode. We've even been able to spin up an openUI GUI & run the model through there.

Today, the prompts are all failing. THe response is 
```
time=2026-08-29T11:42:19.655-04:00 level=ERROR source=sched.go:489 msg="error loading llama server" error="llama runner process has terminated: error:CHECK_TRY_ERROR(op(ctx, src0, src1, dst, src0_dd_i, src1_ddf_i, src1_ddq_i, dst_dd_i, dev[i].row_low, dev[i].row_high, src1_ncols, src1_padded_col_size, stream)): Exception caught in this line of code.\n  in function ggml_sycl_op_mul_mat at /home/runner/_work/llm.cpp/llm.cpp/ollama-llama-cpp/ggml/src/ggml-sycl/ggml-sycl.cpp:2876\n/home/runner/_work/llm.cpp/llm.cpp/ollama-llama-cpp/ggml/src/ggml-sycl/../ggml-sycl/common.hpp:115: SYCL error"
```

### Git sync failure
Had troubles with the git push workflow
- ollama-ipex-llm tarball exceeded file size
- ollama-ipex-llm unpacked directory exceeded file size
- Miniforge install script exceeded file size

Solution was more convoluted than expected. Work has been documented in git-commit-struggles.md