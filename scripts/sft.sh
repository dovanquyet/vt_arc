#!/bin/bash
## Run on Falcon cluster.

#SBATCH -J SFT
#SBATCH --account=llms-lab
#SBATCH --time=1:00:00
#SBATCH --partition=l40s_normal_q #l40s_normal_q, a30_normal_q, v100_normal_q
#SBATCH --qos=fal_l40s_normal_short #fal_l40s_normal_short, fal_a30_normal_short, fal_v100_normal_short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --gres=gpu:1

## Slurm output and error files. Always include %j in names. %j means jod_id
#SBATCH -o slurm_log/slurm.%j.out
#SBATCH -e slurm_log/slurm.%j.out

## Load modules, if any. But first "reset."
module load Miniforge3
source activate base

## Get arguments (for experiment control)
# echo "
# The first argument is: DONE
# The first argument is: $1
# The second argument is: $2
# All arguments are: $@
# Some env variables: $TEMP
# "
# if use positional arguments for this sbatch script, then run the following command
# export TEMP="something" || sbatch scripts/sft.sh "hello world" argument2

## Run main commands
cd ~/vt_arc
source activate unsloth
python scripts/sample_training_script.py

## Command to run this sbatch script: 
# sbatch scripts/sft.sh
