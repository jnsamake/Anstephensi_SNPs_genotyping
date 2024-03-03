#####################################################################################################################################################################################################
# File: variant_calling.sh
#
# Created by Jeanne N. Samake in June 2022
# Filtering was based on script originally written by Philip Lavretsky on 10 August 2021 
# 
#
# Description: 1) call variants from autosomal sorted bam files. 2) filter and remove sites with too many missing samples 3) check depth and remove any samples with <10X depth
# 4) remove indels and generate bi-allelic SNPs dataset with only variants that have been successfully genotyped in 90% of individuals
#####################################################################################################################################################################################################


#Variant calling

bcftools mpileup -a AD,DP,SP -Ou -f/reference_genome.fasta *sorted.bam | bcftools call -f GQ,GP -mv -Oz -o autosomal.calls.vcf.gz


#Filter and remove sites with missing samples

vcftools -gzvcf autosomal.calls.vcf.gz --max-missing 0.50 --minQ 30 --minDP 10 --remove-filtered 'AD<4' --recode --recode-INFO-all --out autosomal.GL


#Check depth 

vcftools --depth --vcf autosomal.GL.recode.vcf --out aut_depth


#Remove samples with <10X depth then re-check depth

vcftools --vcf autosomal.GL.recode.vcf --remove remove.indiv.txt --recode --recode-INFO-all --out autosomal.GL.recode.GS


#Extra filtering to remove indels, missing sites, and generate bi-allelic SNPs dataset in plink format

vcftools --vcf autosomal.GL.recode.GS.recode.vcf --remove-indels --min-alleles 2 --max-alleles 2 --max-missing 0.90 --minQ 30 --minDP 10 --remove-filtered 'AD<4' --maf --plink --out autosomal.plink
