#!/bin/bash

source ~/miniforge3/etc/profile.d/conda.sh


#CODING SEQUENCE PREDICTION --------------------------------------------------------------------------

#activate env for prodigal
conda activate ex4_pt2

#check that raw fna file is in main directory
ls 

#check to see if all necessary packages are installed
gcc --version 
~/Prodigal/prodigal -v
pigz --version

#create directory for cds and go to it
mkdir cds
cd cds

#perform prodigal on fna file 
prodigal \
 -i ../GCF_037966535.1_ASM3796653v1_genomic.fna \
 -c \
 -m \
 -f gff \
 -o cds.gff \
 2>&1 | tee cds.log

#check file output
du -sh cds*
     # 512K : cds.gff
     # 4.0K : cds.log


#compress file and view file output
pigz -9f cds.gff cds.log
gzcat cds.gff.gz | head -n 4
gzcat cds.log.gz

#go back to main directory
cd ..

#deactivate env
conda deactivate

#16S RRNA GENE SEQUENCE EXTRACTION --------------------------------------------------------------------------

#activate new env for barnnap
conda activate ex4_pt1

#check to see if all necessary packages are installed
barrnap --version     
bedtools --version  
pigz --version

#create directory for cds and go to it
mkdir ssu
cd ssu

#perform barrnap
barrnap \
 ../GCF_037966535.1_ASM3796653v1_genomic.fna \
 | grep "Name=16S_rRNA;product=16S ribosomal RNA" \
 > 16S.gff

 #check file output
du -sh 16S.gff    # 4.0K : 16S.gff

#extract nucleotide sequence
bedtools getfasta \
 -fi  ../GCF_037966535.1_ASM3796653v1_genomic.fna \
 -bed 16S.gff -s \
 -fo 16S.fa

#check file output
du -sh 16S.fa     # 4.0K : 16S.fa
grep '>' 16S.fa
cat 16S.fa

#cleanup
rm *.gff
rm ../*.fai

#go back to main directory
cd ..


#BLAST HITS --------------------------------------------------------------------------

#make new directory for blast and go to it
mkdir blast
cd blast

#install blast
brew install blast

#verify blast installation
blast -version

#install 16S rRNA database
curl -O https://ftp.ncbi.nlm.nih.gov/blast/db/16S_ribosomal_RNA.tar.gz
tar -xzvf 16S_ribosomal_RNA.tar.gz

#run blast on 16s rna data 
blastn -query ../ssu/16S.fa -db 16S_ribosomal_RNA -out blast_results.out -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxids sscinames"


#sort by lowest E value and highest percent identity and take top 5 matches
sort -k 11,11n -k 3,3nr blast_results.out | head -n 5 > sorted_top5_blast_results.out

#add header to the sorted blast results
echo -e "query_id\tsubject_id\tpercent_identity\talignment_length\tmismatches\tgap_openings\tq_start\tq_end\ts_start\ts_end\tevalue\tbitscore\ttaxid\tscientific_name" >  blast_with_header.out
cat sorted_top5_blast_results.out >> blast_with_header.out

#convert file to csv file (then to xlsx form manually from excel)
sed 's/\t/,/g' blast_with_header.out > top_ssu_alignments.csv

#compress original 16s file and view file output
pigz -9f ../ssu/16S.fa
gzcat ../ssu/16S.fa.gz 

#deactivate conda env
conda deactivate