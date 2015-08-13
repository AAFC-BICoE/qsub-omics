#!/bin/bash

#$ -S /bin/bash
# #$ -N qsub_script
#$ -V
#$ -M $EMAIL
#$ -q all.q
#$ -cwd
export PATH=/usr/java/latest/bin/:$PATH
#CMD=$1
perlbrew off

pe_R1=$1
pe_R2=$2
pe_se1=$3
pe_se2=$4
mp_R1=$5
mp_R2=$6
mp_se1=$7
mp_se2=$8
prefix=$9

/bin/echo Running on host: `hostname`.
/bin/echo In directory: `pwd`
/bin/echo Starting on: `date`

vh_pe_opts="-shortPaired1 -separate -fastq ${pe_R1} ${pe_R2} -short1 -fastq ${pe_se1} -short2 -fastq ${pe_se2}"
# assume high-quality mate-pairs (MiSeq Nextera) such that mate-pairs are in FR, not RF orientation.
vh_se_opts="-shortPaired2 -separate -fastq ${mp_R1} ${mp_R2} -short3 -fastq ${mp_se1} -short4 -fastq ${mp_se2}"
vg_opts="-ins_length1 301 -ins_length2 1700 -shortMatePaired2 yes"

CMD="VelvetOptimiser.pl -t 13 -m 5 -p $prefix -d ${prefix}_final -c 'n50*Lcon' -x 8 -s 53 -e 93 -f '${vh_pe_opts} ${vh_mp_opts}' -o '${vg_opts}'"
echo $CMD
eval $CMD

/bin/echo Finished on: `date`
