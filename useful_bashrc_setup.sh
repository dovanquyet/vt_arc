# Define Slurm commands
export VT_PID=...

# Connection from your computer to ARC
alias connect-falcon='ssh -i ~/.ssh/arc_key $VT_PID@falcon1.arc.vt.edu'
alias connect-tc='ssh -i ~/.ssh/arc_key $VT_PID@tinkercliffs1.arc.vt.edu'

# Slurm commands
alias submit="sbatch"
alias status="squeue -u $VT_PID --format '%.8i %.35j %.10u %.6t %.10M %.9P'"
alias remove="scancel"
# alias jobstatus="sacct -u VT_PID --format=JobID,JobName,Partition,State,Elapsed,Start,End,AllocCPUS"
alias sjobs="sacct --format JobID,JobName%33,User,Account,Partition,AllocCPUS,Start,End,Elapsed,State,ExitCode"
alias checkother="ps -fU pinjie"

alias gpustatus="watch nvidia-smi --query-gpu=timestamp,name,memory.total,memory.free,memory.used --format=csv"
alias load_conda="module load Miniforge3"
alias disksize="du -h --max-depth=0"
alias request_interact="interact -A $ALLOCATION_ID --partition $PARTITION --qos $QOS --cpus-per-task $NUM_CPUS_PER_TASK --gres=gpu:$NUM_GPUS --verbose" # --time=5:00:00
alias timeleft="echo 'Remaining time: $(squeue -h -j $SLURM_JOBID -o %L)'"
