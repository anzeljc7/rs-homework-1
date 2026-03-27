#!/bin/bash
#SBATCH --job-name=gem5_task2c
#SBATCH --output=task2c_%j.log
#SBATCH --reservation=fri
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=1
#SBATCH --time=00:30:00
#SBATCH --mem=4G

set -euo pipefail

cd $SLURM_SUBMIT_DIR

GEM5_WORKSPACE=/d/hpc/projects/FRI/GEM5/gem5_workspace
GEM5_OPT=$GEM5_WORKSPACE/gem5/build/RISCV/gem5.opt
SIF=$GEM5_WORKSPACE/gem5_rv.sif

srun apptainer exec $SIF make -C workload

for ROB in 32 64 128; do
    echo "Running ROB=$ROB ..."
    srun apptainer exec --env BP_KIND=TAGE --env ROB_SIZE=$ROB $SIF \
        $GEM5_OPT --outdir=m5out_rob${ROB} default/cpu_benchmark.py
done