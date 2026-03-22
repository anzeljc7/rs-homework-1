#!/bin/bash
#SBATCH --job-name=gem5_task1
#SBATCH --output=results_%j.log
#SBATCH --reservation=fri
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=1
#SBATCH --time=00:15:00
#SBATCH --mem=4G

# Nujno: Premaknemo se v mapo task1, od koder smo oddali posel!
cd $SLURM_SUBMIT_DIR

# Poti
GEM5_WORKSPACE=/d/hpc/projects/FRI/GEM5/gem5_workspace
GEM5_OPT=$GEM5_WORKSPACE/gem5/build/RISCV/gem5.opt
SIF=$GEM5_WORKSPACE/gem5_rv.sif

# 1. korak: Prevajanje
srun apptainer exec $SIF make -C workload

# 2. korak: Zagon za MinorCPU (Task 1a)
echo "Running MinorCPU..."
#srun apptainer exec $SIF $GEM5_OPT --outdir=m5out_minor task1.py --cpu minor

# 3. korak: Zagon za O3CPU (Task 1a)
echo "Running O3CPU..."
srun apptainer exec $SIF $GEM5_OPT --outdir=m5out_o3 task1.py --cpu o3