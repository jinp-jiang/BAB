ysDate=`date -d'yesterday' +'%F'`
errorHost="/home/STD-MO/bspLog/errorHost"
DP="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdError/${ysDate}/DP.txt"
LED="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdError/${ysDate}/LED.txt"
SPE="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdError/${ysDate}/SPE.txt"

if [ -s ${DP} ];then
        echo "- hosts: " > ${errorHost}
        sed ':t;N;s/\n/,/;b t' ${DP} >> ${errorHost}
        i=`sed ':t;N;s/\n//;b t' ${errorHost}`
        sed -i "2s/.*$/${i}/" /home/STD-MO/bspLog/bspRecoveryLogDP.yml
        su STD-MO -c "/usr/bin/ansible-playbook /home/STD-MO/bspLog/bspRecoveryLogDP.yml"
        rm -rf /home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail/${ysDate}/DP*
        /usr/bin/sh /home/jcdcn/bspLogHandle/handle.sh DP
else
        echo "DP empty"
fi

if [ -s ${LED} ];then
        echo "- hosts: " > ${errorHost}
        sed ':t;N;s/\n/,/;b t' ${LED} >> ${errorHost}
        i=`sed ':t;N;s/\n//;b t' ${errorHost}`
        sed -i "2s/.*$/${i}/" /home/STD-MO/bspLog/bspRecoveryLogLED.yml
        su STD-MO -c "/usr/bin/ansible-playbook /home/STD-MO/bspLog/bspRecoveryLogLED.yml"
        rm -rf /home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail/${ysDate}/LED*
        /usr/bin/sh /home/jcdcn/bspLogHandle/handle.sh LED
else
        echo "LED empty"
fi

if [ -s ${SPE} ];then
        echo "- hosts: " > ${errorHost}
        sed ':t;N;s/\n/,/;b t' ${SPE} >> ${errorHost}
        i=`sed ':t;N;s/\n//;b t' ${errorHost}`
        sed -i "2s/.*$/${i}/" /home/STD-MO/bspLog/bspRecoveryLogSPE.yml
        su STD-MO -c "/usr/bin/ansible-playbook /home/STD-MO/bspLog/bspRecoveryLogSPE.yml"
        rm -rf /home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail/${ysDate}/SPE*
        /usr/bin/sh /home/jcdcn/bspLogHandle/handle.sh SPE
else
        echo "SPE empty"   
fi

/usr/bin/sh /home/jcdcn/bspLogHandle/Tar.sh
