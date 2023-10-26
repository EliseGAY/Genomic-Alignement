#=======================#
##### Genomic-Alignement
##### Author : Elise GAY
#=======================#

##### Make alignement on supercalculator of sequences fasta against fasta with alignments tools

##### BLAT
Used to align sequences with high similarity level by local and fast alignement run (designed for EST alignment)

Sequences might be protein of nucleiq

sbatch blat.sh

##### BLAST

Used to align sequences in various ways (pairwise or by using NCBI database).

Sequences might be protein of nucleiq

Inconvenient : long run

sbatch blast.sh

##### MUMMER

Used to align whole genome, more accurate than BLAT, but less modulable.


