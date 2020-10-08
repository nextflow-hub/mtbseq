#!/usr/bin/env nextflow
import java.nio.file.Paths

/*
#==============================================
code documentation
#==============================================
*/


/*
#==============================================
PARAMS
#==============================================
*/


/*
#----------------------------------------------
flags
#----------------------------------------------
*/

params.mtbFull = false

/*
#----------------------------------------------
directories
#----------------------------------------------
*/

params.resultsDir = 'results/mtbseq/mtbfull'


/*
#----------------------------------------------
file patterns
#----------------------------------------------
*/

params.readsFilePattern = "./*_{R1,R2}.fastq.gz"

/*
#----------------------------------------------
misc
#----------------------------------------------
*/

params.saveMode = 'copy'

/*
#----------------------------------------------
channels
#----------------------------------------------
*/


Channel.fromFilePairs(params.readsFilePattern)
        .set { ch_in_mtbFull }

/*
#==============================================
PROCESS
#==============================================
*/

process mtbFull {
    publishDir params.resultsDir, mode: params.saveMode
//    container 'quay.io/biocontainers/mtbseq:1.0.4--1'
//    container 'quay.io/biocontainers/mtbseq:1.0.4--pl526_0'
//    container 'quay.io/biocontainers/mtbseq:1.0.3--pl526_1'
//    container 'conmeehan/mtbseq:version1'

    container 'arnoldliao95/mtbseq' 

    validExitStatus 0,1,2
    errorStrategy 'ignore'

    when:
    params.mtbFull

    input:
    set genomeFileName, file(genomeReads) from ch_in_mtbFull

    output:
    path("""${genomeFileName}""") into ch_out_multiqc

    script:

    """

    mkdir ${genomeFileName}
   
    perl /MTBseq_source/MTBseq.pl --step TBfull --thread 8
    
    cp -a Amend ./${genomeFileName}/
    cp -a Bam ./${genomeFileName}/
    cp -a Called ./${genomeFileName}/
    cp -a Classification ./${genomeFileName}/
    cp -a GATK_Bam ./${genomeFileName}/
    cp -a Groups ./${genomeFileName}/
    cp -a Joint ./${genomeFileName}/
    cp -a Mpileup ./${genomeFileName}/
    cp -a Position_Tables ./${genomeFileName}/
    cp -a Statistics ./${genomeFileName}/
    """


}


/*
#==============================================
# extra
#==============================================
*/
