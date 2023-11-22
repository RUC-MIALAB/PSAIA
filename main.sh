#!/bin/bash
if [ -e Program/naccess2.1.1 ];then
	chmod u+x Program/naccess2.1.1/*
fi
if [ -e Program/Qcontacts ];then
	        chmod u+x Program/Qcontacts/*
fi
cd Program/naccess2.1.1/
csh install.scr
cd ../../
bash work/clear_file.sh
bash work/divide_patch.sh
bash work/sort_patch.sh
