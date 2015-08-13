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
se1=$3
se2=$4
prefix=$5

/bin/echo Running on host: `hostname`.
/bin/echo In directory: `pwd`
/bin/echo Starting on: `date`

vh_opts="-shortPaired -separate -fastq ${pe_R1} ${pe_R2} -short -fastq $se1 -short -fastq $se2"
vg_opts="-ins_length 301"

CMD="VelvetOptimiser.pl -t 13 -m 5 -p $prefix -d ${prefix}_final -c 'n50*Lcon' -x 8 -s 53 -e 93 -f '${vh_opts}' -o '${vg_opts}'"
echo $CMD
eval $CMD

/bin/echo Finished on: `date`
