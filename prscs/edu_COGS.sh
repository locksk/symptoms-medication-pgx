#!/bin/bash
  
#SBATCH --account=scw2063
#SBATCH -n 1
#SBATCH -c 1
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
#rm filenames.txt

# load module
module load python/3.9.2

# load virtual environment for prscs
source ../cogs_prs/ve_prscs/bin/activate

# get requirements
pip install -r ../cogs_prs/ve_prscs/requirements.txt

# format
# cut -f 1,4,5,7,8 ../cogs_prs/sumstats/EA4_additive_excl.txt > ../cogs_prs/sumstats/EA4_additive_excl.c.txt

#rename columns
# sed -e '1s/rsID/SNP/' -e '1s/Effect_allele/A1/' -e '1s/Other_allele/A2/' ../cogs_prs/sumstats/EA4_additive_excl.c.txt > ../cogs_prs/sumstats/EA4_additive_excl.f.txt

# run prscs

python3 ../cogs_prs/PRScs/PRScs.py \
  --ref_dir=../cogs_prs/PRScs/test_data/ldblk_1kg_eur \
  --bim_prefix=../cogs_prs/COGS/COGS.chr${SLURM_ARRAY_TASK_ID}.dose.qc4 \
  --sst_file=../cogs_prs/sumstats/EA4_additive_excl.f.txt \
  --n_gwas=765283 \
  --chrom=${SLURM_ARRAY_TASK_ID} \
  --n_iter=25000 --n_burnin=10000 \
  --out_dir=../cogs_prs/results/edu/edu
  


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
 --bfile ../cogs_prs/COGS/COGS.chr${SLURM_ARRAY_TASK_ID}.dose.qc4 \
 --maf 0.1 \
 --extract ../cogs_prs/COGS/COGS.chr${SLURM_ARRAY_TASK_ID}.INFO09.snplist \
 --score ../cogs_prs/results/edu/edu_pst_eff_a1_b0.5_phiauto_chr${SLURM_ARRAY_TASK_ID}.txt 2 4 6 sum\
 --out ../cogs_prs/results/edu/cs_prs/chr${SLURM_ARRAY_TASK_ID}

# clean up
rm -r $WDPATH

echo
echo "Complete"
echo
