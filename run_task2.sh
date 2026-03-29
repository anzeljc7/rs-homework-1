#!/bin/bash
#SBATCH --job-name=gem5_task2a
#SBATCH --output=task2a_%j.log
#SBATCH --reservation=fri
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=1
#SBATCH --time=00:15:00
#SBATCH --mem=4G

cd $SLURM_SUBMIT_DIR

GEM5_WORKSPACE=/d/hpc/projects/FRI/GEM5/gem5_workspace
GEM5_OPT=$GEM5_WORKSPACE/gem5/build/RISCV/gem5.opt
SIF=$GEM5_WORKSPACE/gem5_rv.sif

echo "Compiling workload..."
srun apptainer exec $SIF make -C workload

echo "Running Task 2a..."
srun apptainer exec $SIF \
    $GEM5_OPT --outdir=m5out_task2a default/cpu_benchmark.py

echo "Done. Stats are in m5out_task2a/stats.txt"