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

params.resultsDir = 'results/FIXME'


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


Channel.fromFilePairs(params.filePattern)
        .set { ch_in_mtbFull }

/*
#==============================================
PROCESS
#==============================================
*/

process mtbFull {
    publishDir params.resultsDir, mode: params.saveMode
//    container 'quay.io/biocontainers/mtbseq:1.0.4--1'


    erroStrategy 'ignore'

    when:
    params.mtbFull

    input:
    set genomeFileName, file(genomeReads) from ch_in_mtbFull

//    output:
//    path FIXME into ch_out_PROCESS


    script:

    """
    MTBSeq --step TBfull --thread 4
    """
}


/*
#==============================================
# extra
#==============================================
*/
