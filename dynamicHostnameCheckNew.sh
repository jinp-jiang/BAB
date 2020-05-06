#!/bin/bash
lsDate=$(date "+%Y_%m_%d_%H_%M_%S")
originalHosts="/etc/ansible/hosts"
ansibleHostsPath="/home/check/ansibleHosts"
ansibleFinalFile="/home/STD-MO/bspLog/proof/ansibleFinalHosts"
logFile="/home/STD-MO/bspLog/proof/log/checkResultNew.log"
cat /dev/null > ${ansibleFinalFile}
#处理前保存原来的hosts文件
cp "$originalHosts" "$originalHosts""$lsDate"
cat /dev/null > $logFile

for hostname in `ls ${ansibleHostsPath}`;
do
	cat ${ansibleHostsPath}/${hostname} >> ${ansibleFinalFile}		
done
IFS=$'\n'
for player in `cat ${ansibleFinalFile}`;
do
	v="/home/STD-MO/bspLog/proof/v"
	echo "${player}" > ${v}
	a=`awk '{print $1}' ${v}`
	tmp=`grep "${a}" ${originalHosts}`
	sed -i "s/${tmp}/${player}/g" /etc/ansible/hosts
done
