#!/bin/bash


main_directory=`pwd`
pdb_dir="$main_directory/data/pdb"
rsa_dir="$main_directory/data/rsa"
chain_dir="$main_directory/data/chain"
contact_dir="$main_directory/data/contact"
surface_dir="$main_directory/data/surface"
patch_dir="$main_directory/data/patch"
patch_abs_dir="$main_directory/data/patch/abs"
patch_contact_dir="$main_directory/data/patch/contact"
patch_psaia_dir="$main_directory/data/patch/psaia"

#create directory: workspace


#create subdirectories
cd data
for i in $(ls $main_directory/data/);
do
	if [ $i != 'pdb' ];
	then
		rm -rf $i
	fi
done

