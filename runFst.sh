#!/usr/bin/bash

#This is a script to fun the full Fst calculation. 

#make dir
mkdir /home/jdabney/projects/sputum/data/Fst
cd ~/projects/sputum/data/Fst

#Make sync file from bams.
~/projects/sputum/scripts/Fst/make_pop2sync.pl

#calculate Fst
find -maxdepth 1 -name "*.sync" | xargs -n 1 basename | xargs -n 1 -P 12 -I{} ~/projects/sputum/scripts/fst_calculation/wrapper_pop2.pl {}