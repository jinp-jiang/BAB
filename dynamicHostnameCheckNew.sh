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
IFS=$'\n'
for hostname in `cat /home/STD-MO/bspLog/proof/hostNameList`;
do
        echo ${hostname}
        if [ -s ${ansibleHostsPath}/${hostname} ];then
                echo "normal" > /dev/null
        else
                su STD-MO -c "ansible ${hostname}.jcd.priv -b --become-user root --become-method sudo -m shell -a '/usr/bin/sh /home/STD-MO/recordInfoNew.sh'"
        fi
        cat ${ansibleHostsPath}/${hostname} >> ${ansibleFinalFile}
done
IFS=$'\n'
for player in `cat ${ansibleFinalFile}`;
do
        v="/home/STD-MO/bspLog/proof/v"
        echo "${player}" > ${v}
        a=`awk '{print $1}' ${v}`
        b=`awk '{print $2}' ${v}`
        tmp=`grep "${a}" ${originalHosts}`
        tmpIP=`grep "${a}" ${originalHosts} | awk '{print $2}'`
        if [ "${tmpIP}" != "${b}" ];then
                sed -i "s/${tmp}/${player}/g" /etc/ansible/hosts
        else
		echo "Normal"
        fi
done
