# Medication and pharmacogenomic effects on cross-sectional phenotype severity and cognitive ability in schizophrenia 

## Files

* COGS_predictors_of_symptoms.rmd contains the code used for analysis of the CardiffCOGS dataset - see [here](https://locksk.github.io/cogs-symptoms/)
    * .html file contains output
    * ./figs contains additional files/figures used in the .rmd
    * style.css helps format the .rmd
* pypgx directory contains code snippets used for calling PGx star alleles (performed using [PyPGX](https://github.com/sbslee/pypgx) (Lee et al., 2022)).
* prscs directory contains code used to generate polygenic scores for schizophrenia, intelligence, and educational attainment (performed using [PRSCS](https://github.com/getian107/PRScs) (Ge et al., 2019)). 

## Data and Packages
* The CardiffCOGS dataset was used for these analyses. 
* Confirmatory Factor Analyses were fit using [lavaan](https://lavaan.ugent.be/) (Roseel et al., 2012)
* Antipsychotic doses were converted to chlorpromazine-equivalents using [chlorpromazineR](https://github.com/ropensci/chlorpromazineR) (Brown et al., 2021)
* Activity scores were corrected for concommitant medication using [phenconverter](https://git.cardiff.ac.uk/c1713552/phenoconvert)