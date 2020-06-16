#!/bin/bash
playerIDPath="/home/check/playerID"
lsDate="$1"
ysDate=`date -d "${lsDate} -1 days" "+%Y-%m-%d"`
nametime=`date -d "${lsDate} -1 days" "+%Y%m%d"`
adCopyIdListPath="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdList"
adCopyIdDetailPath="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail"

dataSource()
{
mysql -h 10.179.245.222 -u'STD-MO' -p'STdg123!' -e "use BABdaily;
           CREATE TABLE IF NOT EXISTS DC${nametime}(
           ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
           playerID INT(11),
           adCopyID INT(11),
           date date NOT NULL,
           playTime longtext,
           UNIQUE key(playerID,adcopyID,date));"
for Type in `cat /home/jcdcn/bspLogHandle/DBNEW/Type.txt`
do
        bspLog="/home/jcdcn/bspLogHandle/bspLog/${lsDate}/${Type}"
        adCopyIdList="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdList/${Type}/${ysDate}"
        v="/home/jcdcn/bspLogHandle/DBNEW/v.txt"
        for hostname in `ls ${bspLog}`
        do
                playerID=`cat ${playerIDPath}/${hostname}`
                for adCopyId in `cat ${adCopyIdList}`
                do
                        zcat ${bspLog}/${hostname}/var/opt/bsp/share/bsp/logs/*.gz | grep "Playing ad copy id ${adCopyId}" | awk '{print $1}' > ${v}
                        if [ -s ${v} ];then
			sed -i "s/\[${ysDate}T//g" ${v} > /dev/null
                                sed -i "s/\](message)//g" ${v} > /dev/null
                                playTime=`sed ':t;N;s/\n/,/;b t' /home/jcdcn/bspLogHandle/DBNEW/v.txt`
                                mysql -h 10.179.245.222 -u'STD-MO' -p'STdg123!' -e "use BABdaily;insert into DC${nametime}(playerID,adCopyID,date)values('${playerID}','${adCopyId}','${ysDate}') on duplicate key update playerID='${playerID}',adCopyID='${adCopyId}',date='${ysDate}';"
                                /usr/bin/python /home/jcdcn/bspLogHandle/DBNEW/support.py ${adCopyId} ${playerID} ${ysDate}
                else
                                echo "Without the AD ${adCopyId}" > /dev/null
                        fi
                done
        done
done
}

ALLadCopyMySQL()
{
for Type in `cat /home/jcdcn/bspLogHandle/DBNEW/Type2.txt`
do
        mysql -h 10.179.245.222 -u'STD-MO' -p'STdg123!' -e "use BAB;
        CREATE TABLE IF NOT EXISTS dataAnalysis(
           ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
           customerName VARCHAR(128),
           screenName VARCHAR(128) NOT NULL,
           adCopyID INT(11),
           campaignID INT(11),
	   historyCount INT(11),
           planCount INT(11),
           difference INT (11),
           date date NOT NULL,
           mediaType VARCHAR(128),
           UNIQUE key(screenName,date,adCopyID));"
        for adCopyId in `cat ${adCopyIdListPath}/${Type}/${ysDate}`
        do
           IFS=$'\n'
           for line in `cat ${adCopyIdDetailPath}/${ysDate}/${Type}/${adCopyId}.txt`
           do
                echo ${line} > /home/test.txt
                screenID=`awk '{print $1}' /home/test.txt`
                historyCount=`awk '{print $2}' /home/test.txt`
                customerName=`mysql -h 10.179.245.222 -u'STD-MO' -p'STdg123!' -N -e "use BAB;select customerName from customerInfo where adCopyID = ${adCopyId} and startTime <= '${ysDate}' and endTime >= '${ysDate}'"`
                planCount=`mysql -h 10.179.245.222 -u'STD-MO' -p'STdg123!' -N -e "use BAB;select planCount from customerInfo where adCopyID = ${adCopyId} and startTime <= '${ysDate}' and endTime >= '${ysDate}'"`
                campaignID=`mysql -h 10.179.245.222 -u'STD-MO' -p'STdg123!' -N -e "use BAB;select campaignID from customerInfo where adCopyID = ${adCopyId} and startTime <= '${ysDate}' and endTime >= '${ysDate}'"`
                if [ ! -n "${campaignID}" ];then
                        echo "is NUll" > /dev/null
                else
                        echo ${campaignID} ${adCopyId} ${screenID}
			mysql -h 10.179.245.222 -u'STD-MO' -p'STdg123!' -e "use BAB;insert into dataAnalysis(customerName,screenName,adCopyID,campaignID,historyCount,planCount,date)values('${customerName}','${screenID}','${adCopyId}','${campaignID}','${historyCount}','${planCount}','${ysDate}') on duplicate key update customerName='${customerName}',screenName='${screenID}',adCopyID='${adCopyId}',campaignID='${campaignID}',historyCount='${historyCount}',planCount='${planCount}',date='${ysDate}';"
                fi
           done
        done
done
}

dataSource
ALLadCopyMySQL
