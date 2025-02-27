#!/bin/bash
# 1 CPU
# 10 Go

# Global variables
GATK="/home/clrou103/00-soft/GATK/GenomeAnalysisTK.jar"
DEDUPFOLDER="07_deduplicated"
REALIGNFOLDER="08_realigned"
GENOMEFOLDER="03_genome"
GENOME="genome.fasta"
file=$1
SEX=$2
# Load needed modules
module load java/jdk/1.8.0_102

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="99_log_files"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Realign around target previously identified

java -jar $GATK \
    -T IndelRealigner \
    -R "$GENOMEFOLDER"/"$SEX"/"$GENOME" \
    -I "$DEDUPFOLDER"/"$file" \
    -targetIntervals "$DEDUPFOLDER"/"${file%.dedup.bam}".intervals \
    --consensusDeterminationModel USE_READS  \
    -o "$REALIGNFOLDER"/$(basename "$file" .dedup.bam).realigned.bam
