ipAddr=$(ip addr show dev eth0 |grep inet | awk '{print $2}' | awk -F '/' '{print $1}')
name=$(hostname | awk -F '.' '{print $1}')
name1=$(hostname)
hostname=${name^^}
filePath="/home/STD-MO/"
IP="10.179.10.128"
playerID=`DMS-broadsignID`
echo "${hostname}.jcd.priv ansible_host=${ipAddr}" > ${filePath}/${hostname}
echo "${playerID}" > ${filePath}/${name1}

random=`echo $(($RANDOM%180+1))`
echo "睡眠随机时间${random}秒"
sleep ${random}
i=0
while [ ${i} -le 1 ]
do
	if ping -c 3 ${IP} > /dev/null
	then
		lftp sftp://check:'123456'@10.179.10.128:/ansibleHosts/ -e "put /home/STD-MO/${hostname}; bye"
		lftp sftp://check:'123456'@10.179.10.128:/playerID/ -e "put /home/STD-MO/${name1}; bye"
		echo "文件已上传"
                break
	else
		echo "当前网络状态不佳"	
	fi
done
