#!/bin/bash
playerIDPath="/home/check/playerID"
lsDate="$1"
ysDate=`date -d "${lsDate} -1 days" "+%Y-%m-%d"`
nametime=`date -d "${lsDate} -1 days" "+%Y%m%d"`
adCopyIdListPath="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdList"
adCopyIdDetailPath="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail"

dataSource()
{
mysql -u root -e "use BAB;truncate HIS_RD${nametime};"
mysql -u root -e "use BAB;
           CREATE TABLE IF NOT EXISTS HIS_RD${nametime}(
           PLAYER_ID INT(11),
           ADCOPY_ID INT(11),
           DATE date,
           PLAY_TIME longtext);"
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
				mysql -u root -e "use BAB;insert into HIS_RD${nametime}(PLAYER_ID,ADCOPY_ID,DATE,PLAY_TIME) values ('${playerID}','${adCopyId}','${ysDate}','${playTime}')"
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
	mysql -u root -e "use BAB;
	CREATE TABLE IF NOT EXISTS ${Type}adCopyId(
	   ID INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	   screenID VARCHAR(128) NOT NULL,
	   adCopyID INT(11),
	   campaignID INT(11),
	   historyCount INT(11),
	   planCount INT(11),
	   difference INT (11),
	   Date date NOT NULL,
	   UNIQUE key(screenID,Date,adCopyID));"
	for adCopyId in `cat ${adCopyIdListPath}/${Type}/${ysDate}`
	do
	   IFS=$'\n'
	   for line in `cat ${adCopyIdDetailPath}/${ysDate}/${Type}/${adCopyId}.txt`
	   do
	        echo ${line} > /home/test.txt
	        screenID=`awk '{print $1}' /home/test.txt`
	        historyCount=`awk '{print $2}' /home/test.txt`
	        planCount=`mysql -u root -N -e "use BAB;select playCount from adCopy where adCopyID = ${adCopyId}"`
	        campaignID=`mysql -u root -N -e "use BAB;select campaign from adCopy where adCopyID = ${adCopyId}"`
	        if [ ! -n "${campaignID}" ];then
	                echo "is NUll" > /dev/null
	        else
			mysql -u root -e "use BAB;insert into ${Type}adCopyId(screenID,adCopyID,campaignID,historyCount,planCount,Date)values('${screenID}','${adCopyId}','${campaignID}','${historyCount}','${planCount}','${ysDate}') on duplicate key update screenID='${screenID}',adCopyID='${adCopyId}',campaignID='${campaignID}',historyCount='${historyCount}',planCount='${planCount}',Date='${ysDate}';"
	        fi
	   done
	done
done
}

#dataSource
ALLadCopyMySQL
