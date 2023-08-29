#!/bin/bash
#SBATCH --job-name=desy3_cng_cov
#SBATCH -p c_compute_physics1
#SBATCH -A scw1361
#SBATCH --nodes=1
#SBATCH --ntasks=28
#SBATCH --array=0-55
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1gb
#SBATCH --time=72:00:00
#SBATCH --output=%A.out
#SBATCH --error=%A.err
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=harrisoni@cardiff.ac.uk

cd $SLURM_SUBMIT_DIR
module load anaconda/2023.03
module load compiler/gnu/8/1.0
module load cfitsio
module load mpi/openmpi
module load gsl
module load fftw
module load git
N=1540
for ((i = 0; i < SLURM_NTASKS; i++)); do
	i_cov=$((SLURM_ARRAY_TASK_ID*SLURM_NTASKS+i+1));
	if [[ ${i_cov} -gt N ]]; then break; fi;
	srun --ntasks 1 --exclusive -c 1 ./cov ${i_cov} ini_files/cov_desy3_fulltomo_cng.ini >&/home/c.c1025819/CosmoCov-itrharrison/covs/log_files/cov_desy3_fulltomo_cng_${i_cov}.log
done;

# N / ntasks = array