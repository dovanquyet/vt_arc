# Define Slurm commands
export VT_PID=...
alias submit="sbatch"
alias status="squeue -u $VT_PID --format '%.8i %.35j %.10u %.6t %.10M %.9P'"
alias remove="scancel"
# alias jobstatus="sacct -u VT_PID --format=JobID,JobName,Partition,State,Elapsed,Start,End,AllocCPUS"
alias sjobs="sacct --format JobID,JobName%33,User,Account,Partition,AllocCPUS,Start,End,Elapsed,State,ExitCode"

alias act="conda activate"
alias deact="conda deactivate"