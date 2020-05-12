#/bin/bash
#MO-ITS-Jinp

Type="$1"
lsDate=`date +'%Y-%m-%d'`
ysDate=`date -d'yesterday' +'%F'`

#lsDate="$2"
#ysDate=`date -d "${lsDate} -1 days" "+%Y-%m-%d"`

filePath="/home/jcdcn/bspLogHandle"
adCopyIdDetailPath="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail"
adCopyIdListPath="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdList"
bspLogPath="/home/jcdcn/bspLogHandle/bspLog/${lsDate}/${Type}"

#Collate the copyid in all logs, and create a daily corresponding folder.
adCopyIdList()
{
echo "### adCopyIdList handle start ###"
cat /dev/null > ${adCopyIdListPath}/${Type}/adCopyId${ysDate}
for hostname in `ls ${bspLogPath}`;
do
        zcat ${bspLogPath}/${hostname}/var/opt/bsp/share/bsp/logs/*.gz | grep -a 'Playing ad copy id' | awk '{print $8}' >> ${adCopyIdListPath}/${Type}/adCopyId${ysDate}
done
        sort ${adCopyIdListPath}/${Type}/adCopyId${ysDate} | uniq > ${adCopyIdListPath}/${Type}/${ysDate}

for adCopyId in `cat ${adCopyIdListPath}/${Type}/${ysDate}`;
do
        mkdir -p ${adCopyIdDetailPath}/${ysDate}/${Type}/${adCopyId}
done
        rm -rf ${adCopyIdListPath}/${Type}/adCopyId${ysDate}
echo "### adCopyIdList handle finish ###"
}

#Generate a file named details of the adocopyid.
adCopyIdDetail()
{
echo "### adCopyIdDetail handle start ###"
for adCopyId in `ls ${adCopyIdDetailPath}/${ysDate}/${Type}`;
do
        for hostname in `ls ${bspLogPath}`;
        do
                count=`zcat ${bspLogPath}/${hostname}/var/opt/bsp/share/bsp/logs/*.gz | grep -a "Playing ad copy id ${adCopyId}" | wc -l`
                #echo ${count}
                if [ "${count}" = "0" ];then
                        echo "${count}"
                else
                        zcat ${bspLogPath}/${hostname}/var/opt/bsp/share/bsp/logs/*.gz | grep -a "Playing ad copy id ${adCopyId}" > ${adCopyIdDetailPath}/${ysDate}/${Type}/${adCopyId}/${hostname}_${count}
                fi
        done
done
echo "### adCopyIdDetail handle end ###"
}

#Change the server hostname to the corresponding screen name according to the list.
Rename()
{
echo "### rename start ###"
for hostname in `ls ${bspLogPath}`;
do
        for adCopyId in `ls ${adCopyIdDetailPath}/${ysDate}/${Type}`;
        do
                screenName=`grep ${hostname} ${filePath}/hostname${Type}List | awk '{print $2}'`
                echo ${screenName}      
                cd ${adCopyIdDetailPath}/${ysDate}/${Type}/${adCopyId}
                pwd
                rename "${hostname}" "${screenName}" *
        done
done
echo "### rename end ###"
}

#Servers that failed to log collection.
bspLogError()
{
adCopyIdError="/home/jcdcn/bspLogHandle/adCopyId/adCopyIdError"
mkdir -p ${adCopyIdError}/${ysDate}
ls /home/jcdcn/bspLogHandle/bspLog/${lsDate}/${Type} > /home/jcdcn/bspLogHandle/bspLog/${lsDate}/${Type}.txt

cat /dev/null > ${adCopyIdError}/${ysDate}/${Type}.txt

for hostname in `awk '{print $1}' /home/jcdcn/bspLogHandle/hostname${Type}List`;
        do
                a=`grep "${hostname}" /home/jcdcn/bspLogHandle/bspLog/${lsDate}/${Type}.txt | wc -l`
                playerIDPath="/home/check/playerID/${hostname}"
                b=`cat /home/check/playerID/${hostname}`
                c=`mysql -u root -N -e "use MO;select playerID from playerID where playerName = '${hostname}'"`
                if [ -s ${playerIDPath} ];then
                        echo "normal" > /dev/null
                else
                        su STD-MO -c "ansible ${hostname} -b --become-user root --become-method sudo -m shell -a '/usr/bin/sh /home/STD-MO/recordInfoNew.sh'"
                fi
                b=`cat /home/check/playerID/${hostname}`
                if [[ "${a}" = "0" || "${b}" != "${c}" ]];then
                        echo ${lsDate} >> /home/jcdcn/bspLogHandle/adCopyId/timestamp/var
                        echo ${hostname} >> ${adCopyIdError}/${ysDate}/${Type}.txt
                fi
        done
sort /home/jcdcn/bspLogHandle/adCopyId/timestamp/var | uniq > /home/jcdcn/bspLogHandle/adCopyId/timestamp/${Type}
cp /home/jcdcn/bspLogHandle/adCopyId/adCopyIdError/${ysDate}/${Type}.txt /home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail/${ysDate}/

}

#Generate text for easy count
bspLogDataTxt()
{
rm -rf ${adCopyIdDetailPath}/${ysDate}/${Type}/*.txt
for adCopyId in `ls ${adCopyIdDetailPath}/${ysDate}/${Type}`;
do
        ls ${adCopyIdDetailPath}/${ysDate}/${Type}/${adCopyId} > ${adCopyIdDetailPath}/${ysDate}/${Type}/${adCopyId}.txt
        sed -i "s/_/ /g" ${adCopyIdDetailPath}/${ysDate}/${Type}/${adCopyId}.txt
done
}

#Be used for BAB Show
ALLadCopyMySQL()
{
mysql -u root -e "use BAB;truncate ${Type}adCopyId;"
mysql -u root -e "use BAB;
CREATE TABLE IF NOT EXISTS ${Type}adCopyId(
   ID INT UNSIGNED AUTO_INCREMENT primary key,
   screenID VARCHAR(255),
   adCopyID INT(11),
   campaignID INT(11),
   historyCount INT(11),
   planCount INT(11),
   difference INT (11),
   Date VARCHAR(255));"
mysql -u root -e "use BAB;truncate ${Type}adCopyId;"
for adCopyId in `cat ${adCopyIdListPath}/${Type}/${ysDate}`
do
   IFS=$'\n'
   for line in `cat ${adCopyIdDetailPath}/${ysDate}/${Type}/${adCopyId}.txt`
   do
        echo ${line} > /home/test.txt
        screenID=`awk '{print $1}' /home/test.txt`
        historyCount=`awk '{print $2}' /home/test.txt`
        planCount1=`mysql -u root -e "use BAB;select playCount from adCopy where adCopyID = ${adCopyId}"`
        planCount=`echo ${planCount1} | awk '{print $2}'`
        echo ${planCount}
        campaignID1=`mysql -u root -e "use BAB;select campaign from adCopy where adCopyID = ${adCopyId}"`
        campaignID=`echo ${campaignID1} | awk '{print $2}'`
        echo ${campaignID}
        if [ ! -n "${campaignID}" ];then
                echo "is NUll"
        else
                mysql -u root -e "use BAB;
                insert into ${Type}adCopyId(screenID,adCopyID,campaignID,historyCount,planCount,Date)values(
                '${screenID}','${adCopyId}','${campaignID}','${historyCount}','${planCount}','${ysDate}')"
        fi
   done
done
}

adCopyIdList
adCopyIdDetail
Rename
bspLogError
bspLogDataTxt
#ALLadCopyMySQL
