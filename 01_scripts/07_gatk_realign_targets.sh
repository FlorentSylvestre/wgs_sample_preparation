#!/bin/bash
# 1 CPU
# 30 Go

# Global variables
GATK="/home/clrou103/00-soft/GATK/GenomeAnalysisTK.jar"
DEDUPFOLDER="07_deduplicated"
REALIGNFOLDER="08_realigned"
GENOMEFOLDER="03_genome"
GENOME="genome.fasta"
FILE=$1
SEX=$2
# Load needed modules
module load java/jdk/1.8.0_102

# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
NAME=$(basename $0)
LOG_FOLDER="99_log_files"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$NAME"

# Build Bam Index

java -jar "$GATK" \
    -T RealignerTargetCreator \
    -R "$GENOMEFOLDER"/"$SEX"/"$GENOME" \
    -I "$DEDUPFOLDER"/"$FILE"_1.dedup.bam \
    -o "${FILE%.dedup.bam}".intervals
