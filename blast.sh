#!/bin/sh
#SBATCH --clusters=mesopsl1
#SBATCH --account=gay
#SBATCH --partition=def
#SBATCH --qos=mesopsl1_def_long
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --job-name=BLAST
#SBATCH --time=03:00:00
#SBATCH -o blast.o
#SBATCH -e blast.e

# Load module 
module load bioinfo/blast-2.2.26

#----------------------------------------#
# 1. Get NCBI database or make custom DB
#----------------------------------------#
'''
BLAST database

BLAST databases are updated daily and may be downloaded via FTP from ftp://ftp.ncbi.nlm.nih.gov/blast/db/. 
 nr.*tar.gz = Non-redundant protein sequences from GenPept, Swissprot, PIR, PDF, PDB, and NCBI RefSeq
'''

# IF PUBLIC database is needed : NCBI database 
#----------------------------------------------#
# If you need to download the NCBI database (Very heavy file (~70G)
wget 'ftp://ftp.ncbi.nlm.nih.gov/blast/db/nr.*.tar.gz'
# Unzip database
cat nr.*.tar.gz | tar -zxvi -f -C .


# IF CUSTOM database is needed 
#------------------------------#
# in : your fasta file
# dbtype : chose prot or nucl
# out : string to name your .db output
# parse_seqids : mandatory
makeblastdb -in input.fasta -dbtype prot/nucl -out input.db -parse_seqids

#--------------------------------#
# 2. RUN BLASTN on nucleiq sequence
#--------------------------------#
# p : blastn or blastp
# db : nr = non-redontant NCBI database
# db : input.db = to specify your own database created with "makeblastdb"
# evalue : evalue to keep in the results
# outfmt : format of the output. 
#	- outfmt 6  : means the following column in output table :
#		1. qseqid, query or source (gene) sequence id
#		2.sseqid: subject or target (reference genome) sequence id
#		3.pident: percentage of identical positions
#		4.length: alignment length (sequence overlap)
#		5.mismatch: number of mismatches
#		6.gapopen: number of gap openings
#		7.qstart: start of alignment in query
#		8.qend: end of alignment in query
#		9.sstart: start of alignment in subject
#		10.send: end of alignment in subject
#		11.evalue: expect value
#		12.bitscore: bit score
# max_target_seqs : nb of alignment to output
# max_hsps : no more than X HSPs (alignments) by query will be print

blastall -p blastn -query dna.fasta -num_threads 15 -db nr -evalue 0.00001 -outfmt "6 qseqid sseqid pident qcovs qlen length mismatch qstart qend gapope scomnames staxids sskindoms evalue bitscore" -out blast.table -max_target_seqs 10 -max_hsps 10

#--------------------------------------#
# 3. Get functionnal annotation of hits
#--------------------------------------#

# Get the Accession number of functionnal annotation in the blast.table output
# -entry : list of Id function (example : "XP_003842061,OAK95644,XP_018388209,KNG45754,RAR00147,OWY46376")

# Get function for each ID
blastdbcmd -db nr -dbtype prot -range 1-10 -entry "XP_003842061,OAK95644,XP_018388209,KNG45754,RAR00147,OWY46376" -out definition_gene.table