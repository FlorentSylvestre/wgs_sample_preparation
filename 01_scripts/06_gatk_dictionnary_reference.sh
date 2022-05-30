#!/bin/bash
# 1 CPU
# 10 Go

# Global variables
CSD="/prg/picard-tools/1.119/CreateSequenceDictionary.jar"
GENOMEFOLDER="03_genome"
GENOME_F="F/genome.fasta"
GENOME_M="M/genome.fasta"


# Load needed modules
module load java/jdk/1.8.0_102
module load samtools/1.8

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="99_log_files"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# create a dictionnary from reference fasta file
# for female
java -jar "$CSD" \
    R="$GENOMEFOLDER"/"$GENOME_F" \
    O="$GENOMEFOLDER"/"${GENOME_F%.fasta}".dict
# for male
java -jar "$CSD" \
    R=R="$GENOMEFOLDER"/"$GENOME_M" \
     O="$GENOMEFOLDER"/"${GENOME_M%.fasta}".dict


# Also index genome with samtools
# for female
samtools faidx "$GENOMEFOLDER"/"$GENOME_F"

#for male
samtools faidx "$GENOMEFOLDER/$GENOME_M"
