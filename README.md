# ollama-on-intel-arc
Guide on implementing OLLAMA model service on a machien with Intel Arc GPU

https://github.com/intel/ipex-llm/blob/main/docs/mddocs/Quickstart/bmg_quickstart.md

## Install dependencies
```
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:kobuk-team/intel-graphics
sudo apt-get install -y libze-intel-gpu1 libze1 intel-ocloc intel-opencl-icd clinfo intel-gsc intel-media-va-driver-non-free libmfx1 libmfx-gen1 libvpl2 libvpl-tools libva-glx2 va-driver-all vainfo
sudo apt-get install -y intel-level-zero-gpu-raytracing  # Optional: Hardware ray tracing support
```

```
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:kobuk-team/intel-graphics
sudo apt-get install -y libze-intel-gpu1 libze1 intel-metrics-discovery intel-opencl-icd clinfo intel-gsc
sudo apt-get install -y intel-media-va-driver-non-free libmfx-gen1.2 libvpl2 libvpl-tools libva-glx2 va-driver-all vainfo
sudo apt-get install -y libze-dev intel-ocloc
sudo apt-get install -y libze-intel-gpu-raytracing
clinfo | grep "Device Name"
```


## Having issues with GPU metrics
```
$ sudo apt install intel-gpu-tools
$ intel_gpu_top -L
card1                    8086:e20b                         pci:vendor=8086,device=E20B,card=0
└─renderD128            

$ intel_gpu_top -d pci:vendor=8086,device=E20B,card=0
Failed to detect engines! (No such file or directory)
(Kernel 4.16 or newer is required for i915 PMU support.)
```

intel_gpu_top is not working.

### Debug GPU
https://github.com/ipex-llm/ipex-llm/releases/tag/v2.3.0-nightly


```
https://www.intel.com/content/www/us/en/support/articles/000005520/graphics.html

$ lspci -k | grep -EA3 'VGA|3D|Display'
"03:00.0 VGA compatible controller: Intel Corporation Device e20b"
        Subsystem: Intel Corporation Device 1100
        Kernel driver in use: xe
        Kernel modules: xe
```






## OLLAMA REFERENCE
https://github.com/intel/ipex-llm/blob/de6bce27133ab250f13fd5d549c197519ce16d30/docs/mddocs/Quickstart/ollama_portable_zip_quickstart.md#linux-quickstart


## Install OLLAMA
https://github.com/ipex-llm/ipex-llm/releases/tag/v2.3.0-nightly
https://github.com/intel/ipex-llm/blob/de6bce27133ab250f13fd5d549c197519ce16d30/docs/mddocs/Quickstart/ollama_portable_zip_quickstart.md#linux-quickstart
https://github.com/intel/ipex-llm/blob/de6bce27133ab250f13fd5d549c197519ce16d30/docs/mddocs/Quickstart/bmg_quickstart.md


### Run the ollama in the background
~/Github/ollama-on-intel-arc/ollama-ipex-llm-2.3.0b20250725-ubuntu$ ./start-ollama.sh 


### open new terminal


## Background on Models
#### Source: https://blog.alexewerlof.com/p/base-models-vs-instruct-models

### Foundation vs. Instruct vs. Thinking
Metaphor: lib vs. app vs. operator

#### Foundation Model (lib)
Result of the pretraining phase.
Data centers spent large amount of compute to get these weights tuned & now the model can interpret patterns, frequency, etc. It's a prediction machine -- not truly "intelligent".


### Instruct Model (app)
Result of the posttraining phase.
Similar to chat models:
 - Both are trained to have conversation
 - Both are simpler
 - Chat models have (-chat) in their name.
 - Instruct models have (-it) in their name. They can also execute tasks
Sometimes the names are used interchangeably.

Developing these models have two steps:
1. Supervised Fine-Tuning ["GeeksforGeeks doc"|https://www.geeksforgeeks.org/artificial-intelligence/supervised-fine-tuning-sft-for-llms/]
2. Reinforcement Learning from Human Feedback ["GeeksforGeeks doc"|https://www.geeksforgeeks.org/machine-learning/reinforcement-learning-from-human-feedback/]


### Thinking model (operator)
Chain of Thought Reasoning
Used for multistep logic