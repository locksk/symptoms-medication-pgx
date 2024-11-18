#!/bin/bash
  
#SBATCH --account=scw2063
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -p c_compute_neuro1
#SBATCH --time=24:00:00
#SBATCH --array=1-22
#SBATCH --mail-type=ALL
#SBATCH --mail-user=locksk@cardiff.ac.uk
#SBATCH --mem=64G

WDPATH=/scratch/$USER/${SLURM_JOBID:-$$}
mkdir -p $WDPATH
cd $WDPATH

#echo "INFO: Working path is $WDPATH"


# run from prs_cogs folder

module purge 

# data qc
module load plink/2.0

plink2 --bfile ../cogs_prs/COGS/COGS.chr${SLURM_ARRAY_TASK_ID}.dose.qc4 --geno 0.95 --mind 0.95 --hwe midp 0.000001 keep-fewhet --make-bed --out ../cogs_prs/COGS/COGS.chr${SLURM_ARRAY_TASK_ID}.dose.qc5 

module purge

# load module
module load python/3.9.2

# load virtual environment for prscs
source ../cogs_prs/ve_prscs/bin/activate

# get requirements
pip install -r ../cogs_prs/ve_prscs/requirements.txt

# unzip gz file
#gzip -cd ../cogs_prs/sumstats/daner_PGC_SCZ_w3_90_0518d__kiren_owen_odonovan_2a.gz > daner_PGC_SCZ_w3_90_0518d__kiren_owen_odonovan_2a.txt

# format
#cut -f 2,4,5,9,10 ../cogs_prs/sumstats/daner_PGC_SCZ_w3_90_0518d__kiren_owen_odonovan_2a.txt > daner_PGC_SCZ_w3_90_0518d__kiren_owen_odonovan_2a.f.txt

# run prscs

#python3 ../cogs_prs/PRScs/PRScs.py \
#  --ref_dir=../cogs_prs/PRScs/test_data/ldblk_1kg_eur \
#  --bim_prefix=../cogs_prs/COGS/COGS.chr${SLURM_ARRAY_TASK_ID}.dose.qc5 \
#  --sst_file=../cogs_prs/sumstats/daner_PGC_SCZ_w3_90_0518d__kiren_owen_odonovan_2a.f.txt \
#  --n_gwas=320404 \
#  --phi=1 \
#  --chrom=${SLURM_ARRAY_TASK_ID} \
#  --n_iter=25000 --n_burnin=10000 \
#  --out_dir=../cogs_prs/results/sz/final/sz
  


# deactivate virtual environment for prscs
deactivate

echo 
echo "PRScs complete"
echo

# load plink
module purge
module load plink/1.9

echo 
echo "Scoring..."
echo


# run plink

# we want sum modifier on --score flag

plink \
 --bfile ../cogs_prs/COGS/COGS.chr${SLURM_ARRAY_TASK_ID}.dose.qc5 \
 --maf 0.1 \
 --extract ../cogs_prs/code/INFO_cat.txt \
 --score ../cogs_prs/results/sz/final/sz_pst_eff_a1_b0.5_phi1e+00_chr${SLURM_ARRAY_TASK_ID}.txt 2 4 6 sum\
 --out ../cogs_prs/results/sz/final/score/chr${SLURM_ARRAY_TASK_ID}

# clean up
rm -r $WDPATH

echo
echo "Complete"
echo
