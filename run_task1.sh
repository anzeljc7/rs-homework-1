#!/bin/bash
#SBATCH --job-name=gem5_task1
#SBATCH --output=results_%j.log
#SBATCH --reservation=fri
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=1
#SBATCH --time=00:15:00
#SBATCH --mem=4G

cd $SLURM_SUBMIT_DIR

GEM5_WORKSPACE=/d/hpc/projects/FRI/GEM5/gem5_workspace
GEM5_OPT=$GEM5_WORKSPACE/gem5/build/RISCV/gem5.opt
SIF=$GEM5_WORKSPACE/gem5_rv.sif

srun apptainer exec $SIF make -C workload

echo "Running MinorCPU..."
srun apptainer exec $SIF $GEM5_OPT --outdir=m5out_minor task1.py --cpu minor

echo "Running O3CPU..."
srun apptainer exec $SIF $GEM5_OPT --outdir=m5out_o3 task1.py --cpu o3