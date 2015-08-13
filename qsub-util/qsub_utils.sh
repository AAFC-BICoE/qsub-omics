#get_qsub_script() {
#    [ -e qsub_script.sh ] || svn export http://svn.biodiversity.agr.gc.ca/repo/source/AssemblyPipeline/qsub_script.sh
#    sed -i 's/#$ -pe .*//' qsub_script.sh
#}

get_qsub_script() {
    write_qsub_script "qsub_script.sh"
}

# harder to export a single file in git. use here doc instead.
write_qsub_script() {
    script_name=$1
    job_name=${script_name%.*}
    cat >$script_name <<EOF
#!/bin/bash

#$ -S /bin/bash
#$ -N $job_name
#$ -V
#$ -M \$EMAIL
#$ -cwd

export PATH=/usr/java/latest/bin/:\$PATH
CMD=\$1

/bin/echo Running on host: \`hostname\`.
/bin/echo In directory: \`pwd\`
/bin/echo Starting on: \`date\`

/bin/echo "Running command: \${CMD}"
\$CMD

/bin/echo Finished on: \`date\`
EOF
}

# paste an input command right into a standard qsub script. optional 2nd arg is name of output script.
write_qsub_script_cmd() {
    cmd=$1
    script_name="qsub_cmd.sh"
    [ ! -z $2 ] && script_name=$2
    cat >$script_name <<EOF
#!/bin/bash

#$ -S /bin/bash
#$ -N qsub_script
#$ -V
#$ -M \$EMAIL
#$ -cwd

export PATH=/usr/java/latest/bin/:\$PATH

/bin/echo Running on host: \`hostname\`.
/bin/echo In directory: \`pwd\`
/bin/echo Starting on: \`date\`

/bin/echo "Running command: $cmd"
$cmd

/bin/echo Finished on: \`date\`

EOF
}

run_qsub() {
    nprocs=$1
    qsub_holdid=$2
    cmd=$3
    jobname="run_qsub"
    [ ! -z $4 ] && jobname=$4
    get_qsub_script
    qsub_cmd="qsub -N $jobname -pe smp $nprocs -hold_jid $qsub_holdid -q all.q qsub_script.sh \"$cmd\""
    >&2 echo ${qsub_cmd}
    qsub_out=`eval ${qsub_cmd}`
    >&2 echo ${qsub_out}
    qsub_jobid=`echo $qsub_out | perl -ne 'if (/Your job ([0-9]+)/) { print $1 }'`
    echo ${qsub_jobid}
} 

# Given arbitrary number of input jobids, submit a single dummy job (run ls) that holds on them all.
qsub_dummy_hold() {
    hold_str=""
    for jobid in "$@"; do
        hold_str="${hold_str} -hold_jid $jobid"
    done
    get_qsub_script
    qsub_cmd="qsub -N qsub_dummy -pe smp 1 $hold_str qsub_script.sh \"ls\""
    >&2 echo ${qsub_cmd}
    qsub_out=`eval ${qsub_cmd}`
    >&2 echo ${qsub_out}
    qsub_jobid=`echo $qsub_out | perl -ne 'if (/Your job ([0-9]+)/) { print $1 }'`
    echo ${qsub_jobid}     
} 
