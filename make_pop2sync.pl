#!/usr/bin/perl -w 
#Jesse Dabney
#05.10.17

#This script reads in a file with sample information, then gathers the relevant bams for each patient and creates an mpileup file. Then it calls PoPoolation2 to make a sync file.

my $infile = "sampleInfo_fst_calcs.txt"; #file with columns sampleID, source, patientID
my %data;
my $sam = "/opt/PepPrograms/samtools-1.1/samtools";
#build data hash

open (IN, "<", "$infile") or die "Couldn't open $infile for reading: $?\n";

while (my $line = <IN>) {
	chomp $line;
	my ($sample, $source, $pat) = split "\t", $line;
	$data{$pat}{$source} = $sample;
}
foreach my $patient (keys %data) {
	my $patmpileup = "${patient}.mpileup";
	my $syncout = "${patient}.sync";
	my $culture = $data{$patient}{"culture"};
	my $sputum = $data{$patient}{"sputum"};
	my $cbam = "~/projects/sputum/data/metgen_filtered/${culture}/${culture}_classSeqs.bam";
	my $sbam = "~/projects/sputum/data/metgen_filtered/${sputum}/${sputum}_classSeqs.bam";
	system "$sam mpileup -B -q 30 -Q 20 ${cbam} ${sbam} > ${patmpileup}"; #or die "Couldn't create mpileup file: $?\n";
	unless ($? == 0) {
		die "Couldn't make mpileup file: $?";
	}
	system "java -ea -Xmx7g -jar /opt/PepPrograms/popoolation2_1201/mpileup2sync.jar --input ${patmpileup} --output ${syncout} --fastq-type sanger --min-qual 20 --threads 20" or die "Couldn't make sync file: $?\n";
}
