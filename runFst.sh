#!/usr/bin/bash
#testing popoolation2 scripts to make the sync file
#ERR867546 (patient 11, culture) has average depth of 314
#ERR867538 (patient 11, sputum) has average depth of 146


sam mpileup -B -q 30 -Q 20 ../metgen_filtered/ERR867546/ERR867546_classSeqs.bam ../metgen_filtered/ERR867538/ERR867538_classSeqs.bam 

sam mpileup -B -q 30 -Q 20 ../metgen_filtered/ERR867546/ERR867546_classSeqs.bam ../metgen_filtered/ERR867538/ERR867538_classSeqs.bam 