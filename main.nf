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


    errorStrategy 'ignore'

    when:
    params.mtbFull

    input:
    set genomeFileName, file(genomeReads) from ch_in_mtbFull

    output:
    set path("""${genomeFileName}""") into ch_out_multiqc

    script:

    """
    MTBseq --step TBfull --thread 4
    
    mkdir ${genomeFileName}
    cp -a Amend ./${genomeFileName}/
    cp -a Bam ./${genomeFileName}/
    cp -a Called ./${genomeFileName}/
    cp -a Classification ./${genomeFileName}/
    cp -a GATK_Bam ./${genomeFileName}/
    cp -a Groups ./${genomeFileName}/
    cp -a Joint ./${genomeFileName}/
    cp -a Mpileup ./${genomeFileName}/
    cp -a Positoin_Tables ./${genomeFileName}/
    cp -a Statistics ./${genomeFileName}/
    """
}


/*
#==============================================
# extra
#==============================================
*/
