##################################################################################################
# File: aut_from_sorted_bam.sh
#
# Created by Jeanne N. Samake on June 2022
# 
#
# Description: extract autosomal regions from sorted bam files
#
##################################################################################################


#Extract autosomal regions for sorted bam files for each chromosome

for i in `ls *.sorted.bam`;
    do samtools view -b $i "NC_050202.1" > $i_A2.bam;
done;

#Merge autosomal files, index, and sort them 

for i in `cat SampleNames.txt`;
    do samtools merge ${i}.A.bam ${i}.sorted.bam.A2.bam ${i}.sorted.bam.A3.bam;
done;

for k in `ls *A.bam`;
    do samtools index ${k};
done;

for j in `ls *A.bam`;
    do samtools sort ${j}.sorted.bam;
done;

