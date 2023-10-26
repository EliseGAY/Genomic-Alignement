#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=mummer
#SBATCH --time=00:30:00
#SBATCH -o nucmer_SG_myr_bic.o
#SBATCH -e nucmer_SG_myr_bic.e

# Load module 
module load bioinfo/mummer-4.0.0beta2

# sequences to align
My_Query=/My_PATH_TO/query.fasta
My_REF=/My_PATH_TO/ref.fasta

# prefix : (string) prefix on the name of outputs
prefix="query_vs_ref"

# 1. RUN NUCMER
#===============# 

# The output are "*.delta" files. The MUMmer software uses the "delta" file format to represent the all-vs-all alignment between the input sequences. 
# You do not need to know the details of the "delta" format, MUMmer provides a "show-coords" tool to show alignment coordinates in the "delta" files. 
# -p = output_prefix

nucmer -p ${prefix} ${genome_bic} ${SG_myr_Soc}

# 2. Filtering for best hits
#==========================# 
#-q=Maps each position of each query to its best hit in the reference, allowing for reference overlaps
#-r=Maps each position of each reference to its best hit in the query, allowing for query overlaps
delta-filter -r -q ${prefix}.delta > ${prefix}.filter 

# 3. Analyse file.delta 
#======================# 
# -l = Include sequence length columns in the output
# -r = Sort output lines by reference
# -c = Include percent coverage columns in the output

show-coords -l -r -c ${prefix}.filter >> ${prefix}.coor

# DOT_PLOT 
#==========#
#    -r|IdR          Plot a particular reference sequence ID on the X-axis
#    -q|IdQ          Plot a particular query sequence ID on the Y-axis
#    -R|Rfile        Plot an ordered set of reference sequences from Rfile
#    -Q|Qfile        Plot an ordered set of query sequences from Qfile
#                    Rfile/Qfile Can either be the original DNA multi-FastA
#                    files or lists of sequence IDs, lens and dirs [ /+/-]

# dot plot with all queryand ref sequences
mummerplot -png -p ${prefix} ${prefix}.filter

# Dot plot with specific query sequences (ex : chr1:start-end)
mummerplot -png -p ${prefix}_Chr1Q -q _Chr1:start-end ${prefix}.filter

# Dot plot with specific query sequences (ex : chr1:start-end)
mummerplot -png -p ${prefix}_Chr1R -r _Chr1:start-end ${prefix}.filter

# Output Information
#---------------------#
${prefix}.coor : alignement table, usable for plot
${prefix}.delta : nucmer output, not readable
${prefix}.filter : nucmer output with only best hits
${prefix}.fplot : never used this one
${prefix}.gp : never used this one
${prefix}.png : dotplot
${prefix}.rplot : never used this one
