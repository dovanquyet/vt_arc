# VT ARC Quickstart Guide

## 🔗 Useful Links

- [ARC Documentation: Getting Started](https://docs.arc.vt.edu/)
- [Coldfront Allocations: Find your allocations](https://coldfront.arc.vt.edu/)
- [ARC Example `sbatch` Jobs](https://github.com/AdvancedResearchComputing/examples)

## 📝 Notes

- ARC clusters use `slurm` as the job scheduler.
- ARC clusters have **shared storage across all clusters**, thus in many cases you can setup environment/codebase once and use on any cluster.\
`project/<allocation_id>` is persistent and large storage, suitable for large models and datasets. `/home` is also persistent but smaller, while `/scratch` is short-term (last for 90 days). You can install software in your home directory. More about storage [here](https://www.docs.arc.vt.edu/resources/storage.html).

---

## 🔐 I. Login to ARC

⚠️ NOTE: You shouldn't run any job on login nodes. Login nodes are for code editing, job submission, and file transfer only.
To run your code, you need to [request an interactive job or submit a batch job](https://github.com/dovanquyet/vt_arc?tab=readme-ov-file#ii-request-a-gpu-interactive-job).

Set your environment variables (edit as needed):

```bash
export VT_PID=quyetdo
export LOGIN_HOSTNAME=tinkercliffs1 # or falcon1, owl1, etc. (see https://www.docs.arc.vt.edu/resources/compute.html)
```

### (First-time) Login to the cluster (Duo Push required):

> Ref: https://www.docs.arc.vt.edu/pi_info/accountlifecycle.html#accounts

```bash
ssh $VT_PID@$LOGIN_HOSTNAME.arc.vt.edu
```

### SSH with Private Key (optional, but recommended):

After successful login, you can setup `authorized_keys` for ssh so that you don't need to enter PID's password and verify with Duo Push.
Note that the storage are shared acrossed clusters, so you can set it up once and use it on any ARC clusters.
You can search that on Google, or follow below guidances:

1. On your machine:
```bash
cd
ssh-keygen -f ~/.ssh/arc_key
cat ~/.ssh/arc_key.pub
```

2. Copy the output of `cat ~/.ssh/arc_key.pub`, then paste on the file `~/.ssh/authorized_keys` on a ARC cluster.

> NOTE: In case you need heavy editing, you can do it in your IDE, then delete the `~/.ssh/authorized_keys` file on ARC cluster and re-create the edited file. [Remember to change the permission of the file](https://chatgpt.com/share/696df56a-1bc8-8002-b137-bd3d5bc4c7f0) after re-creating the file: `chmod 600 ~/.ssh/authorized_keys`.


3. Login to ARC cluster using private key:
```bash
ssh -i ~/.ssh/arc_key $VT_PID@$LOGIN_HOSTNAME.arc.vt.edu
```

### 🔁 Setup SFTP

You can use `scp` or `rsync` to transfer files to/from ARC, or setup SFTP in your favorite IDE (e.g., VSCode, PyCharm, etc.) using the same ssh private key.

Meanwhile, you can also use an extension on VSCode, namely [SFTP](https://marketplace.visualstudio.com/items?itemName=Natizyskunk.sftp), to sync files between your local machine and ARC. The extension support automatic upload on file save, as well as download and sync, and connect using private key authentication.
A sample `sftp.json` file for this extension is:
```json
{
    "name": "VT_ARC",
    "protocol": "sftp",
    "port": 22,

    "username": "quyetdo",
    "host": "falcon1.arc.vt.edu",
    "remotePath": "/home/quyetdo/vt_arc",
    "privateKeyPath": "~/.ssh/arc_key",

    "uploadOnSave": true,
    "useTempFile": false,
    "openSsh": true,
    "ignore": [".vscode", ".git", ".DS_Store"]
}
```

---

## 🖥️ II. Request a GPU Interactive Job

While it's recommended to use `sbatch` for batch jobs, you can/should request an interactive job for testing and debugging.

### Pre-request setup

It's recommended to use `tmux` for persistent sessions. `tmux` creates a terminal session on the cluster that run independently from your ssh session, so that you can disconnect and reconnect later without losing your work.

You can refer to [this tutorial](https://www.geeksforgeeks.org/linux-unix/tmux-in-linux/), or quickly use the following commands:

```bash
# create new tmux session named 'node'
tmux new -s node

# to disconnect from the tmux session, press: Ctrl + b, then d

# attach to existing tmux session named 'node'
tmux a -t node
```

### Resource Request

Set allocation and resource variables:

```bash
export ALLOCATION_ID=personal # (see https://coldfront.arc.vt.edu/, `slurm_account_name`)
export NUM_GPUS=2
export NUM_HOURS=5
export NUM_CPUS_PER_TASK=16

if [[ "$LOGIN_HOSTNAME" == "tinkercliffs1" ]]; then
  export PARTITION=a100_normal_q
  export QOS=tc_a100_normal_short
elif [[ "$LOGIN_HOSTNAME" == "falcon1" ]]; then
  export PARTITION=l40s_normal_q
  export QOS=fal_l40s_normal_short
fi
```

Check cluster status (to find idle nodes):

```bash
sinfo
```

Request an interactive session:

```bash
interact -A $ALLOCATION_ID \
  --partition $PARTITION \
  --qos $QOS \
  --cpus-per-task $NUM_CPUS_PER_TASK \
  --time=${NUM_HOURS}:00:00 \
  --gres=gpu:$NUM_GPUS \
  --verbose
```

Check your job info:

```bash
squeue
echo $SLURM_JOBID
echo $(hostname)
echo "Remaining time: $(squeue -h -j $SLURM_JOBID -o %L)"
```

To connect to (and disconnect from) the job from another terminal:

```bash
ssh <above_hostname>
logout # to disconnect. FYI, it will NOT terminate the job.
```

---

## ⚙️ III. Environment Setup (Anaconda/Miniforge)

Load Miniforge3:

```bash
module load Miniforge3
# module load Miniconda3 # (alternative)

# also load PyTorch and CUDA, in case some installation require $CUDA_HOME and torch by default
# module load PyTorch/2.1.2-foss-2023a-CUDA-12.1.1
```

Create and activate a conda environment (recommended to do this on the target node):

```bash
export ENV_NAME=unsloth
if [[ ! -d "$HOME/.conda/envs/$ENV_NAME" ]]; then
  conda create --name $ENV_NAME -y
  echo "Conda environment ${ENV_NAME} created."
else
  echo "Conda environment ${ENV_NAME} already exists."
fi

# source activate $HOME/.conda/envs/$ENV_NAME
source activate $ENV_NAME
echo "Conda environment ${ENV_NAME} activated."
```

Install packages as needed (example):

```bash
pip install transformers
# pip install unsloth
```

**Tip:** Use ARC project storage for large models and datasets.

---

## ▶️ IV. Run Scripts & Monitor GPU Usage

Run your Python script (example):

```bash
python scripts/sample_training_script.py
# or your own script
```

Monitor GPU usage:

```bash
watch nvidia-smi --query-gpu=timestamp,name,memory.total,memory.free,memory.used --format=csv
```

---

## 🔁 V. File Transfer

Transfer files to/from ARC using `scp` or `rsync`:

```bash
# Example: Copy file to ARC
scp myfile.txt $VT_PID@$LOGIN_HOSTNAME.arc.vt.edu:/path/on/arc/

# Example: Copy file from ARC
scp $VT_PID@$LOGIN_HOSTNAME.arc.vt.edu:/path/on/arc/myfile.txt ./
```

In a more convenient way, you can use SFTP in your favorite IDE (e.g., VSCode, PyCharm, etc.) as described in the SSH with Private Key section above.

---

## 📦 VI. Non-Interactive (Batch) Jobs

See [ARC documentation](https://docs.arc.vt.edu/) for batch job submission examples.

When your code runs well in an interactive session, it's recommended to submit a non-interactive job using `sbatch` to optimize resource usage. 

```bash
# Check available nodes and partitions
sinfo

# To submit a job
sbatch /path/to/your_job_script.sh # sbatch scripts/sft.sh

# To check our job status.
# If you don't see it, it means your job is canceled due to error or it's done.
# You will see the job_id of your job in the first column.
squeue

# Use sacct to see completed jobs and resource usage
sacct

# To cancel a job
scancel <job_id>
```

---

## 🛠️ Troubleshooting

- If login fails, ensure Duo Push is ready and try again.
- For persistent sessions, use `tmux` or `screen`.
- For more help, see the [ARC documentation](https://docs.arc.vt.edu/).
