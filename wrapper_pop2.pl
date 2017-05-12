#!/usr/bin/perl -w 
#calcFST.pl 
#Jesse Dabney
#05.02.17

#This is a wrapper script for PoPoolation2. It takes in a sync file and calls PoPoolation2 scripts to calculate allele frequencies and Fst.
#It is designed to be used with find and xargs.


use strict;

my $progDir = "/opt/PepPrograms/popoolation2_1201";
my $infile = shift @ARGV; #should be sync file named <patientID>.sync
my $gtf = "/home/jdabney/projects/sputum/scripts/metagenFilter/tbdb_gichrom_nc0009623.gtf";

#PoPoolation2 parameters
my $mincount = 3;
my $mincov = 10;
my $maxcov = 350;
my $pool = 10000;

#get patient name
my $prefix = (split "/\./", $infile)[0];


#calculate allele frequencies
system "perl ${progDir}/snp-frequency-diff.pl --input $infile --output-prefix ${prefix} --min-count $mincount --min-coverage $mincov --max-coverage $maxcov";

#convert sync file to genewise sync
system "perl ${progDir}/create-genewise-sync.pl --input $infile --gtf $gtf --output ${prefix}_genes.sync";

#calculate genewise Fst
system "perl ${progDir}/fst-sliding.pl --min-count $mincount --min-coverage $mincov --max-coverage $maxcov --pool-size $pool --window-size 1000000 --step-size 1000000  --input ${prefix}_genes.sync --output ${prefix}_genewise.fst";

#perform Fisher's Exact Test on gene frequencies
system "perl ${progDir}/fisher-test.pl --input ${prefix}_genes.sync --output ${prefix}_genes.fet --min-count $mincount --min-coverage $mincov --max-coverage $maxcov --window-size 1000000 --step-size 1000000";



