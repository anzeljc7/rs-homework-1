#!/bin/bash
#SBATCH --job-name=gem5_task2b
#SBATCH --output=task2b_%j.log
#SBATCH --reservation=fri
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=1
#SBATCH --time=00:30:00
#SBATCH --mem=4G

cd $SLURM_SUBMIT_DIR

GEM5_WORKSPACE=/d/hpc/projects/FRI/GEM5/gem5_workspace
GEM5_OPT=$GEM5_WORKSPACE/gem5/build/RISCV/gem5.opt
SIF=$GEM5_WORKSPACE/gem5_rv.sif

# workload prevedeš enkrat
srun apptainer exec $SIF make -C workload

for BP in TAGE LocalBP TournamentBP BiModeBP; do
    echo "Running $BP ..."
    srun apptainer exec --env BP_KIND=$BP $SIF \
        $GEM5_OPT --outdir=m5out_$BP default/cpu_benchmark.py
done