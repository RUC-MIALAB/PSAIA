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
result_dir="$main_directory/result"


rm -rf result
mkdir result
#set patch_number
patch_number=15

#sort high psaia score surface patch and output them in result dir

for i in $(ls $pdb_dir);do
	pdb=$(echo ${i%.*})
	for j in $(cat ${chain_dir}/${pdb}_chains.txt);do
		sort -r -n -t ' ' -k 4 ${patch_psaia_dir}/${pdb}_${j}.txt -o ${patch_psaia_dir}/${pdb}_${j}_sort.txt
                z=1
                keys=1
                echo "chain  ${j}: " >> ${result_dir}/${pdb}_result.txt
                while [ $z -le $patch_number ]
		do
                    patch1=$(sed -n "$keys,1p" ${patch_psaia_dir}/${pdb}_${j}_sort.txt | awk '{print $1}')
                    if [ ! $patch1 ];then
                        break
                    fi
		    if [ -f ${patch_dir}/${pdb}_${j}-by_patch_${patch1}.txt ];then
                        echo "patch${z}" >> ${result_dir}/${pdb}_result.txt
                        awk '{print "res: "$2,$3,$4"   CENTER res: "$6,$7,$8}' ${patch_dir}/${pdb}_${j}-by_patch_${patch1}.txt >>${result_dir}/${pdb}_result.txt
                        z=$((z+1))
		    fi
                    keys=$((keys+1))
		done
		#sed -n "1,1p" 1a8j_H_sort.txt | awk '{print $1}'
	done
done

echo "sorting completed"
