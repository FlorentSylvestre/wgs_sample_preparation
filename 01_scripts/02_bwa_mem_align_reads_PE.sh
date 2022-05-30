#!/bin/bash
# 4 CPUs
# 10 Go

# Global variables
GENOMEFOLDER="03_genome"
GENOME="genome.fasta"
RAWDATAFOLDER="05_trimmed"
ALIGNEDFOLDER="06_aligned"
IND=$1
SEX=$2
NCPU=$3

# Test if user specified a number of CPUs
if [[ -z "$NCPU" ]]
then
    NCPU=4
fi

# Load needed modules
module load bwa
module load samtools/1.8

# Index genome if not alread done
#bwa index -p "$GENOMEFOLDER"/"$GENOME" "$GENOMEFOLDER"/"$GENOME"

# Iterate over sequence file pairs and map with bwa
    

    # Name of uncompressed file
    name1=${IND}_1.trimmed.fastq.gz
    name2=${IND}_2.trimmed.fastq.gz
    echo "Aligning file $name1 $name2 , SEX=$SEX" 

    
    
    ID="@RG\tID:${IND}\tSM:${IND}\tPL:Illumina"

    # Align reads
    
    bwa mem -t "$NCPU" -R "$ID" "$GENOMEFOLDER"/"$SEX"/"$GENOME" "$RAWDATAFOLDER"/"$name1" "$RAWDATAFOLDER"/"$name2" |
    samtools view -Sb -q 10 - > "$ALIGNEDFOLDER"/"${name1%.fastq.gz}".bam

    # Sort
    samtools sort --threads "$NCPU" "$ALIGNEDFOLDER"/"${name1%.fastq.gz}".bam \
        > "$ALIGNEDFOLDER"/"${name1%.fastq.gz}".sorted.bam

    # Index
    samtools index "$ALIGNEDFOLDER"/"${name1%.fastq.gz}".sorted.bam

    # Remove unsorted bam file
    rm "$ALIGNEDFOLDER"/"${name1%.fastq.gz}".bam

