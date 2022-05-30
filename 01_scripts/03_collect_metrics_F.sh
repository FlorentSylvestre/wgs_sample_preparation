#!/bin/bash
# 1 CPU
# 10 Go

# Global variables
GENOMEFOLDER="03_genome/F/"
GENOME="genome.fasta"
ALIGNEDFOLDER="06_aligned"
METRICSFOLDER="98_metrics"
ALIGN="/prg/picard-tools/1.119/CollectAlignmentSummaryMetrics.jar"
INSERT="/prg/picard-tools/1.119/CollectInsertSizeMetrics.jar"
MAP="../popmap/F_map"


# Copy script to log folder
TIMESTAMP=$(date +%Y-%m-%d_%Hh%Mm%Ss)
SCRIPT=$0
SCRIPTNAME=$(basename $0)
LOG_FOLDER="99_logfile"
cp "$SCRIPT" "$LOG_FOLDER"/"$TIMESTAMP"_"$SCRIPTNAME"

# Load needed modules
module load java/jdk/1.8.0_102
module load samtools/1.8

# Run Picard Tools to get some metrics on data & alignments
cat $MAP |cut -f1 | 
while read i
do
    file="$i"_1.trimmed.sorted.bam

    echo "Computing alignment metrics for $file"
    java -jar $ALIGN \
        R="$GENOMEFOLDER"/"$GENOME" \
        I="$ALIGNEDFOLDER"/"$file" \
        O="$METRICSFOLDER"/"$file"_alignment_metrics.txt

    echo "Computing insert size metrics for $file"
    java -jar $INSERT \
        I="$ALIGNEDFOLDER"/"$file" \
        OUTPUT="$METRICSFOLDER"/"$file"_insert_size_metrics.txt \
        HISTOGRAM_FILE="$METRICSFOLDER"/"$file"_insert_size_histogram.pdf

    echo "Computing coverage for $file"
    samtools depth -a "$ALIGNEDFOLDER"/"$file" | gzip - > "$METRICSFOLDER"/"$file"_coverage.gz

    echo ""
done
