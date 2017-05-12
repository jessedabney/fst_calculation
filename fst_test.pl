#!/usr/bin/perl -w 
#Fst_test.pl 
#Jesse Dabney
#05.04.17

#This is a script to test the results of different parameters in the Fst calculations.
#This is a wrapper script for PoPoolation2. It takes in a sync file and calls PoPoolation2 scripts to calculate allele frequencies and Fst.



use strict;

my $progDir = "/opt/PepPrograms/popoolation2_1201";
my $infile = "~/projects/sputum/data/Fst/patient11.sync";
my $infile2 = "~/projects/sputum/data/Fst/patient11_gene.sync";
my $gtf = "/home/jdabney/projects/sputum/scripts/metagenFilter/tbdb_gichrom_nc0009623.gtf";

#get patient name
my $prefix = "patient11";



sub getFst {
	my($mincount, $mincov, $maxcov, $pool) = @_; 
	#calculate allele frequencies
	system "perl ${progDir}/snp-frequency-diff.pl --input $infile --output-prefix ${prefix}_maxcov${maxcov}_mincov${mincov}_mincount${mincount} --min-count $mincount --min-coverage $mincov --max-coverage $maxcov";

	#convert sync file to genewise sync
	#system "perl /mnt/PepPop_export/PepPrograms/popoolation2_1201/create-genewise-sync.pl --input $infile --gtf $gtf --output ${prefix}_genes.sync";

	#calculate genewise Fst
	system "perl ${progDir}/fst-sliding.pl --min-count $mincount --min-coverage $mincov --max-coverage $maxcov --pool-size $pool --window-size 1000000 --step-size 1000000  --input $infile2 --output ${prefix}_maxcov${maxcov}_mincov${mincov}_mincount${mincount}_poolsize${pool}_genewise.fst";

	#perform Fisher's Exact Test on allele frequencies
	system "perl ${progDir}/fisher-test.pl --input $infile2 --output ${prefix}_mincount${mincount}_mincov${mincov}_maxcov${maxcov}_genes.fet --min-count $mincount --min-coverage $mincov --max-coverage $maxcov --window-size 1000000 --step-size 1000000 --suppress-noninformative";

}

print STDERR "running test 1...\n";
&getFst(2, 4, 350, 10000);

print STDERR "running test 2...\n";
&getFst(6, 10, 350, 10000);

print STDERR "running test 3...\n";
&getFst(2, 10, 350, 10000);

print STDERR "running test 4...\n";
&getFst(2, 4, 150, 10000);

print STDERR "running test 5...\n";
&getFst(2, 4, 350, 500);