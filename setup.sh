### ARC GPU Instance Setup Script
# Sample sbatch https://docs.arc.vt.edu/resources/compute/00tinkercliffs.html#specification-to-run-on-a100-gpu-nodes
export VT_PID=quyetdo
export CLUSTER=tinkercliffs1 # falcon1


### Step 1: Login and Request a partition
# Note: Your login may fail several times until you receive a Duo Push notification.
# Tip (not 100% sure): Open the Duo Push app before entering the ssh command.
# You will be prompted for your VT_PID password. Same password as VT Outlook.
ssh $VT_PID@$CLUSTER.arc.vt.edu
echo "Logged into ARC ${CLUSTER}. Now accessing a computing node."

# Assume that the tmux session has been setup before as `tmux new -s node`
tmux a -t node


### Step 2: Request an interact job for testing and debugging
# Modify PARTITION and NUM_GPUS for your desired configuration.
# The --verbose flag provides more output.
export ALLOCATION_ID=llms-if # or `personal`. Find in https://coldfront.arc.vt.edu/.
export NUM_GPUS=2
export NUM_HOURS=5
export NUM_CPUS_PER_TASK=16

if [[ "$CLUSTER" == "tinkercliffs1" ]]; then
  export PARTITION=a100_normal_q # l40s_normal_q
  export QOS=tc_a100_normal_short # fal_l40s_normal_short
elif [[ "$CLUSTER" == "falcon1" ]]; then
  export PARTITION=l40s_normal_q
  export QOS=fal_l40s_normal_short
fi

interact -A $ALLOCATION_ID \
  --partition $PARTITION \
  --cpus-per-task $NUM_CPUS_PER_TASK \
  --time=${NUM_HOURS}:00:00 \
  --gres=gpu:$NUM_GPUS \
  --verbose

echo $SLURM_JOBID
echo $(hostname)
echo "Interactive session started on $(hostname)."

# Check remaining time
echo "Remaining time of the interactive environment"
echo "$(squeue -h -j $SLURM_JOBID -o %L)"

# Connect to the job in another terminal (e.g. for monitor purpose)
# Open another termimal and run
ssh <above_hostname>

# Can use sattach: `sattach ${SLURM_JOBID}.0``. But not recommended, as they share the same terminal
# Can use nohup to run processes in the background. But it's not ideal for testing and debugging


### Step 3: Environment Setting - Anaconda
module load Miniforge3
# module load Miniconda3

# IMPORTANT: Do not run `conda init` or use `conda activate` as it relies on `conda init`.
# Create a virtual environment specifically for the type of node where it will be used.
# Replace 'my_gpu_env' with your desired environment name.
# It's recommended to create the environment on the target node type (e.g., a100_normal_q for Tinkercliffs A100 nodes).
export ENV_NAME=unsloth
if [[ ! -d "$HOME/.conda/envs/$ENV_NAME" ]]; then
  conda create --name $ENV_NAME -y
  echo "Conda environment ${ENV_NAME} created."
else
  echo "Conda environment ${ENV_NAME} already exists."
fi

# Activate the conda environment
source activate $HOME/.conda/envs/$ENV_NAME
echo "Conda environment ${ENV_NAME} activated."

# Example: Install a package within the environment (e.g., huggingface transformers)
# pip install transformers

# Huggingface specific recommendation:
# We recommend to use any of the large ARC storage systems to accommodate your models and datasets,
# such as the long-term Project storage system.

echo "Environment setup complete. You are now in your GPU-enabled interactive session with your conda environment activated."

### Step 4: Run a script and monitor GPU usages
# Finetuning with `unsloth`
# pip install unsloth
python 

# GPU
watch nvidia-smi \
  --query-gpu=timestamp,name,memory.total,memory.free,memory.used \
  --format=csv # -l 3