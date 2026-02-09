
## Python Package Installation Issue & Resolution

### Intro

Use conda, uv, and pip to install packages --> Convenient but also easy to mess up the installation, due to possible caching by all these tools. Thus, better to clean up the installation and start from scratch.

E.g.,

When you create a conda env with package in the conda command,
```
conda create --name unsloth_env \
    python=3.11 \
    pytorch-cuda=12.1 \
    pytorch cudatoolkit xformers -c pytorch -c nvidia -c xformers \
    -y
conda activate unsloth_env

pip install unsloth
```

It's very likely that pytorch, cuda, ... are installed in the `~/.local/lib/python3*` instead of the conda env path `~/.conda/envs/unsloth_env/lib/python3*`.

Then, when you create a new conda env and install vLLM, pip may reuse these packages (which is not ideal for the installation) without showing any installation conflicts, yet there are actually import errors, e.g. `import vllm._C`.


### Possible problems:

vLLM serve failed with the following error:
```
import vllm._C  # noqa
    ^^^^^^^^^^^^^^
ImportError: .../deploy/lib/python3.12/site-packages/vllm/_C.abi3.so: undefined symbol: _ZN3c104cuda29c10_cuda_check_implementationEiPKcS2_ib
```

OR

packages in a conda env are messed up between the ~/.conda/envs/env_name and ~/.local/lib/python3*, which causes various import errors.
```
(finetune) quyetdo@tc-gpu001:~/MultiDocQA$ uv pip show peft
Using Python 3.12.12 environment at: /home/quyetdo/.conda/envs/finetune
Name: peft
Version: 0.18.0
Location: /home/quyetdo/.conda/envs/finetune/lib/python3.12/site-packages   <-----
Requires: accelerate, huggingface-hub, numpy, packaging, psutil, pyyaml, safetensors, torch, tqdm, transformers
Required-by: unsloth-zoo

(finetune) quyetdo@tc-gpu001:~/MultiDocQA$ pip show peft
Name: peft
Version: 0.17.1
Summary: Parameter-Efficient Fine-Tuning (PEFT)
Home-page: https://github.com/huggingface/peft
Author: The HuggingFace team
Author-email: benjamin@huggingface.co
License: Apache  
Location: /home/quyetdo/.local/lib/python3.12/site-packages     <-----
Requires: accelerate, huggingface_hub, numpy, packaging, psutil, pyyaml, safetensors, torch, tqdm, transformers
Required-by: dreamsim, unsloth, unsloth_zoo
```


### Solution

Clean up the `~/.local/lib/` and purge pip cache

```bash
mv ~/.local/lib/python3.12 ~/.local/lib/python3.12_bak
mv ~/.local/lib/python3.11 ~/.local/lib/python3.11_bak

pip cache purge
```

Then reinstall the packages in the conda env. It worked for me, at least!

Good luck!