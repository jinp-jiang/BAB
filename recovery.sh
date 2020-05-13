#!/bin/bash

errorHost="/home/STD-MO/bspLog/errorHost"
timestampPath="/home/jcdcn/bspLogHandle/adCopyId/timestamp"
timestamp="${timestampPath}/timestamp"
cat ${timestampPath}/DP > ${timestampPath}/timestamp
cat ${timestampPath}/LED >> ${timestampPath}/timestamp
cat ${timestampPath}/SPE >> ${timestampPath}/timestamp

if [ -s ${timestamp} ];then
for dateRecovery in `cat ${timestampPath}/timestamp`;
do
        ysDateRecovery=`date -d "${dateRecovery} -1 days" "+%Y-%m-%d"`
        DP="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdError/${ysDateRecovery}/DP.txt"
        LED="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdError/${ysDateRecovery}/LED.txt"
        SPE="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdError/${ysDateRecovery}/SPE.txt"
        echo "date: ${dateRecovery}" > /home/STD-MO/bspLog/dateRecovery.yml

        if [ -s ${DP} ];then
                echo "- hosts: " > ${errorHost}
                sed ':t;N;s/\n/,/;b t' ${DP} >> ${errorHost}
                i=`sed ':t;N;s/\n//;b t' ${errorHost}`
                sed -i "2s/.*$/${i}/" /home/STD-MO/bspLog/bspRecoveryLogDP.yml
                su STD-MO -c "/usr/bin/ansible-playbook /home/STD-MO/bspLog/bspRecoveryLogDP.yml"
                rm -rf /home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail/${ysDateRecovery}/DP*
                /usr/bin/sh /home/jcdcn/bspLogHandle/handleRecovery.sh DP ${dateRecovery}
        else
                echo "DP Normal"
        fi
        if [ -s ${DP} ];then
                echo "Still unable to get player log"
        else
                sed -i "/${dateRecovery}/d" /home/jcdcn/bspLogHandle/adCopyId/timestamp/DP
                fi

        if [ -s ${LED} ];then
                echo "- hosts: " > ${errorHost}
                sed ':t;N;s/\n/,/;b t' ${LED} >> ${errorHost}
                i=`sed ':t;N;s/\n//;b t' ${errorHost}`
                sed -i "2s/.*$/${i}/" /home/STD-MO/bspLog/bspRecoveryLogLED.yml
                su STD-MO -c "/usr/bin/ansible-playbook /home/STD-MO/bspLog/bspRecoveryLogLED.yml"
                rm -rf /home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail/${ysDateRecovery}/LED*
                /usr/bin/sh /home/jcdcn/bspLogHandle/handleRecovery.sh LED ${dateRecovery}
        else
                echo "LED Normal"
        fi
        if [ -s ${LED} ];then
                echo "Still unable to get player log"
        else
                sed -i "/${dateRecovery}/d" /home/jcdcn/bspLogHandle/adCopyId/timestamp/LED
        fi

        if [ -s ${SPE} ];then
                echo "- hosts: " > ${errorHost}
                sed ':t;N;s/\n/,/;b t' ${SPE} >> ${errorHost}
                i=`sed ':t;N;s/\n//;b t' ${errorHost}`
                sed -i "2s/.*$/${i}/" /home/STD-MO/bspLog/bspRecoveryLogSPE.yml
                su STD-MO -c "/usr/bin/ansible-playbook /home/STD-MO/bspLog/bspRecoveryLogSPE.yml"
                rm -rf /home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail/${ysDateRecovery}/SPE*
                /usr/bin/sh /home/jcdcn/bspLogHandle/handleRecovery.sh SPE ${dateRecovery}
        else
                echo "SPE Normal"
        fi
        if [ -s ${SPE} ];then
        echo "Still unable to get player log"
        else
                sed -i "/${dateRecovery}/d" /home/jcdcn/bspLogHandle/adCopyId/timestamp/SPE
        fi
done
sed -i "/${dateRecovery}/d" /home/jcdcn/bspLogHandle/adCopyId/timestamp/timestamp
/usr/bin/sh /home/jcdcn/bspLogHandle/TarRecovery.sh ${dateRecovery}
else
        cat /dev/null > /home/jcdcn/bspLogHandle/adCopyId/timestamp/var
        echo “Normal”
fi
