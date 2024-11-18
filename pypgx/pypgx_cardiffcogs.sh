#!/bin/bash

#SBATCH --account=scw2063
#SBATCH -n 1
#SBATCH -c 1
#SBATCH --time=02:00:00

echo "Setting up"
# set up
module load python/3.9.2
echo "..."
source ve_pypgx/bin/activate
echo "..."
pip install -r ve_pypgx/requirements.txt
echo "complete!"
echo
echo
echo "Running PyPGx..."
echo
echo "CYP1A2 starting..."
echo
# run cyp1a2
pypgx run-chip-pipeline CYP1A2 CYP1A2-pipeline data/newqc/COGS.chr15.dose.qc.vcf.gz

mv CYP1A2-pipeline output/
cd output/CYP1A2-pipeline 
bash ../../unzip_script.sh
cp results/*/data.tsv ../results/cyp1a2.tsv
cd ..
cd ..
echo "complete!"
echo
echo
echo "CYP2D6 starting..."
echo
# run cyp2d6
pypgx run-chip-pipeline CYP2D6 CYP2D6-pipeline data/newqc/COGS.chr22.dose.qc.vcf.gz

mv CYP2D6-pipeline output/
cd output/CYP2D6-pipeline
bash ../../unzip_script.sh
cp results/*/data.tsv ../results/cyp2d6.tsv
cd ..
cd ..
echo "complete!"
echo
echo
echo "CYP3A4 starting..."
echo

# run cyp3a4
pypgx run-chip-pipeline CYP3A4 CYP3A4-pipeline data/newqc/COGS.chr7.dose.qc.vcf.gz

mv CYP3A4-pipeline output/
cd output/CYP3A4-pipeline
bash ../../unzip_script.sh
cp results/*/data.tsv ../results/cyp3a4.tsv
cd ..
cd ..
echo "complete!"
echo
echo
echo "CYP3A5 starting..."
echo

# run cyp3a5
pypgx run-chip-pipeline CYP3A5 CYP3A5-pipeline data/newqc/COGS.chr7.dose.qc.vcf.gz

mv CYP3A5-pipeline output/
cd output/CYP3A5-pipeline
bash ../../unzip_script.sh
cp results/*/data.tsv ../results/cyp3a5.tsv
cd ..
cd ..
echo "complete!"
echo
echo
echo "CYP2C9 starting..."
echo

# run cyp2c9
pypgx run-chip-pipeline CYP2C9 CYP2C9-pipeline data/newqc/COGS.chr10.dose.qc.vcf.gz

mv CYP2C9-pipeline output/
cd output/CYP2C9-pipeline
bash ../../unzip_script.sh
cp results/*/data.tsv ../results/cyp2c9.tsv
cd ..
cd ..
echo "complete!"
echo
echo
echo "CYP2C19 starting..."
echo

# run cyp2c19
pypgx run-chip-pipeline CYP2C19 CYP2C19-pipeline data/newqc/COGS.chr10.dose.qc.vcf.gz

mv CYP2C19-pipeline output/
cd output/CYP2C19-pipeline
bash ../../unzip_script.sh
cp results/*/data.tsv ../results/cyp2c19.tsv
cd ..
cd ..
echo "complete!"
echo
echo
echo "ABCG2 starting..."
echo

# run abcg2
pypgx run-chip-pipeline ABCG2 ABCG2-pipeline data/newqc/COGS.chr4.dose.qc.vcf.gz

mv ABCG2-pipeline output/
cd output/ABCG2-pipeline
bash ../../unzip_script.sh
cp results/*/data.tsv ../results/abcg2.tsv
cd ..
cd ..
echo "complete!"
echo
echo
echo "UGT1A1 starting..."
echo

# run ugt1a1
pypgx run-chip-pipeline UGT1A1 UGT1A1-pipeline data/newqc/COGS.chr2.dose.qc.vcf.gz

mv UGT1A1-pipeline output/
cd output/UGT1A1-pipeline
bash ../../unzip_script.sh
cp results/*/data.tsv ../results/ugt1a1.tsv
cd ..
cd ..
echo "complete!"
echo



echo "       _ _       _                               __  "
echo "  __ _| | |   __| | ___  _ __   ___   _          \ \ "
echo " / _` | | |  / _` |/ _ \| '_ \ / _ \ (_)  _____   | |"
echo "| (_| | | | | (_| | (_) | | | |  __/  _  |_____|  | |"
echo " \__,_|_|_|  \__,_|\___/|_| |_|\___| (_)          | |"
echo "                                                 /_/ "

