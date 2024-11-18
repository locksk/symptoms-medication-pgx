#!/bin/bash
  
#SBATCH --account=scw2063
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --time=24:00:00
#SBATCH --array=8-9
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
cut -f 1,5,6,9,10 ../cogs_prs/sumstats/SavageJansen_2018_intelligence_metaanalysis.txt > ../cogs_prs/sumstats/SavageJansen_2018_intelligence_metaanalysis.c.txt

#rename columns
sed -i '1s/stdBeta/Beta/' ../cogs_prs/sumstats/SavageJansen_2018_intelligence_metaanalysis.c.txt

#convert to upper case
awk '{$2 = toupper($2)}1' ../cogs_prs/sumstats/SavageJansen_2018_intelligence_metaanalysis.c.txt > ../cogs_prs/sumstats/SavageJansen_2018_intelligence_metaanalysis.f1.txt

awk '{$3 = toupper($3)}1' ../cogs_prs/sumstats/SavageJansen_2018_intelligence_metaanalysis.f1.txt > ../cogs_prs/sumstats/SavageJansen_2018_intelligence_metaanalysis.f.txt




# run prscs

python3 ../cogs_prs/PRScs/PRScs.py \
  --ref_dir=../cogs_prs/PRScs/test_data/ldblk_1kg_eur \
  --bim_prefix=../cogs_prs/COGS/COGS.chr${SLURM_ARRAY_TASK_ID}.dose.qc4 \
  --sst_file=../cogs_prs/sumstats/SavageJansen_2018_intelligence_metaanalysis.f.txt \
  --n_gwas=269867 \
  --chrom=${SLURM_ARRAY_TASK_ID} \
  --n_iter=25000 --n_burnin=10000 \
  --out_dir=../cogs_prs/results/int/int
  


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
 --score ../cogs_prs/results/int/int_pst_eff_a1_b0.5_phiauto_chr${SLURM_ARRAY_TASK_ID}.txt 2 4 6 sum\
 --out ../cogs_prs/results/int/cs_prs/chr${SLURM_ARRAY_TASK_ID}

# clean up
rm -r $WDPATH

echo
echo "Complete"
echo
