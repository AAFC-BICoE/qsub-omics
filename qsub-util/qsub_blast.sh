
# run blastn on local database using 1 proc
run_blastn_nt() {
    query_file=$1
    blast_file=$2
    qsub_holdid=1
    [ ! -z $3 ] && qsub_holdid=$3
    get_qsub_script
    blastn_cmd="blastn -query $query_file -db /isilon/biodiversity/reference/ncbi/blastdb/reference/nt/nt -out $blast_file -outfmt 6 -max_target_seqs 1"
    qsub_cmd="qsub -N blastn_nt -pe smp 1 -hold_jid ${qsub_holdid} qsub_script.sh \"$blastn_cmd\""
    echo $qsub_cmd
    eval $qsub_cmd
}

write_blastn_nt_par_script() {
    script_name=$1
    if [ ! -e $script_name ]; then
	echo blah
    fi
}

# run blastn job across 6 threads. requires installed GNU parallels.
# parallels command from: https://www.biostars.org/p/76009/
# this script has not been tested.
# better to write a separate qsub_blastn.sh script in another function
# that will just take in the query file and perform qsub based on that.
# if we write a separate qsub script here we have to ensure no other with same name exists.
run_blastn_nt_par() {
    query_file=$1
    blast_file=$2
    qsub_holdid=1
    nprocs=6
    [ !-z $3 ] && qsub_holdid=$3
    blastn_cmd="blastn -query $query_file -db /isilon/biodiversity/reference/ncbi/blastdb/reference/nt/nt -out $blast_file -outfmt 6"
    parallels_cmd="cat $query | parallel --block 100k --recstart '>' --pipe blastn -evalue 0.01 -outfmt 6 -db /isilon/biodiversity/reference/ncbi/blastdb/reference/nt/nt -query - > $blast_file"
    seconds=`date +%s`
    write_qsub_script_cmd "$parallels_cmd" "qsub_blastn_$seconds.sh"
    qsub_cmd="qsub -N blastn_nt -pe smp $nprocs -hold_jid ${qsub_holdid} qsub_script.sh \"$blastn_cmd\""
    echo $qsub_cmd
    eval $qsub_cmd
}