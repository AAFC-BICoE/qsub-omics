#!/bin/bash

#$ -S /bin/bash
# #$ -N qsub_script
#$ -V
#$ -M $EMAIL
#$ -pe orte 1
#$ -cwd
export PATH=/usr/java/latest/bin/:$PATH
CMD=$1

/bin/echo Running on host: `hostname`.
/bin/echo In directory: `pwd`
/bin/echo Starting on: `date`

/bin/echo "Running command: ${CMD}"
$CMD

/bin/echo Finished on: `date`
