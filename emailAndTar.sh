#!/bin/bash

ysDate=`date -d'yesterday' +'%F'`
#lsDate="$1"
#ysDate=`date -d "${lsDate} -1 days" "+%Y-%m-%d"`

Count()
{
cat /dev/null > /home/jcdcn/bspLogHandle/1.txt
for LEDadCopyID in `cat /home/jcdcn/bspLogHandle/adCopyId/adCopyIdList/LED/${ysDate}`
do
        a=`mysql -h 10.179.245.222 -u'STD-MO' -p'STdg123!' -e "use BAB;select adCopyID from customerInfo where adCopyID = '${LEDadCopyID}'"`
echo ${a}
        if [ -n "${a}" ];then
                sort -t " " -k2 -n /home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail/${ysDate}/LED/${LEDadCopyID}.txt | awk '{print $2}' > /home/jcdcn/bspLogHandle/LEDpercent.txt
                echo ${LEDadCopyID}: >> /home/jcdcn/bspLogHandle/1.txt
                uniq -c /home/jcdcn/bspLogHandle/LEDpercent.txt | awk '$0=$0"次)"' | awk '$1=$1"台("' | sed "s/( /(/g" | sed ':t;N;s/\n/,/;b t' >> /home/jcdcn/bspLogHandle/1.txt
        fi
done

cat /dev/null > /home/jcdcn/bspLogHandle/2.txt
for DPadCopyID in `cat /home/jcdcn/bspLogHandle/adCopyId/adCopyIdList/DP/${ysDate}`
do
        a=`mysql -h 10.179.245.222 -u'STD-MO' -p'STdg123!' -e "use BAB;select adCopyID from customerInfo where adCopyID = '${DPadCopyID}'"`
echo ${a}
        if [ -n "${a}" ];then
                sort -t " " -k2 -n /home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail/${ysDate}/DP/${DPadCopyID}.txt | awk '{print $2}' > /home/jcdcn/bspLogHandle/DPpercent.txt
                echo ${DPadCopyID}: >> /home/jcdcn/bspLogHandle/2.txt
                uniq -c /home/jcdcn/bspLogHandle/DPpercent.txt | awk '$0=$0"次)"' | awk '$1=$1"台("' | sed "s/( /(/g" | sed ':t;N;s/\n/,/;b t' >> /home/jcdcn/bspLogHandle/2.txt
        fi
done
echo "" >> /home/jcdcn/bspLogHandle/1.txt
}

#Package and upload to FTP
Tar()
{
cd /home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail
tar -czf ${ysDate}.tar.gz ${ysDate}
rm -rf /var/www/html/MO/bspLog/${ysDate}.tar.gz
mv /home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail/${ysDate}.tar.gz /var/www/html/MO/bspLog
scp -r  /var/www/html/MO/bspLog/${ysDate}.tar.gz root@beta.chengtong.tech:/home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail
}

#Calculate the middle number of LED media history playcount
LEDpercent()
{
cat /dev/null > /home/jcdcn/bspLogHandle/1.txt
for adCopyID in `cat /home/jcdcn/bspLogHandle/adCopyId/adCopyIdList/LED/${ysDate}`
do
        sort -t " " -k2 -n /home/jcdcn/bspLogHandle/adCopyId/adCopyIdDetail/${ysDate}/LED/${adCopyID}.txt | awk '{print $2}' > /home/jcdcn/bspLogHandle/LEDpercent.txt
        num=`wc -l /home/jcdcn/bspLogHandle/LEDpercent.txt | awk '{print $1}'`
        let n=${num}%2
        if [ ${n} = "1" ];then
                let i=${num}/2+1
                echo ${adCopyID} >> /home/jcdcn/bspLogHandle/1.txt
                sed -n "${i},${i}p" /home/jcdcn/bspLogHandle/LEDpercent.txt >> /home/jcdcn/bspLogHandle/1.txt
        else
                let i=${num}/2
                let k=${num}/2+1
                a=`sed -n "${i},${i}p" /home/jcdcn/bspLogHandle/LEDpercent.txt`
                b=`sed -n "${k},${k}p" /home/jcdcn/bspLogHandle/LEDpercent.txt`
                let c=($a+$b)/2
                echo ${adCopyID} >> /home/jcdcn/bspLogHandle/1.txt
                echo ${c} >> /home/jcdcn/bspLogHandle/1.txt
        fi
done
}

#email to someone
sendmail()
{
echo "Dears," > /home/jcdcn/bspLogHandle/report
echo " " >> /home/jcdcn/bspLogHandle/report
a="未有播放机日志缺失，现可登录ftp://ftp.chengtong.tech 下载压缩包。"
host="/home/jcdcn/bspLogHandle/errorHost"
cat /home/jcdcn/bspLogHandle/adCopyId/adCopyIdError/${ysDate}/DP.txt > ${host}
cat /home/jcdcn/bspLogHandle/adCopyId/adCopyIdError/${ysDate}/LED.txt >> ${host}
cat /home/jcdcn/bspLogHandle/adCopyId/adCopyIdError/${ysDate}/SPE.txt >> ${host}
sed -i "s/.jcd.priv//g" ${host}
c=`sed ':t;N;s/\n/、/;b t' ${host}`
b="${c}播放机日志缺失，现可登录ftp://ftp.chengtong.tech 下载压缩包。"

if [ -s ${host} ];then
        echo "${ysDate}日志收集已完成，${b}" >> /home/jcdcn/bspLogHandle/report
else
        echo "${ysDate}日志收集已完成，${a}" >> /home/jcdcn/bspLogHandle/report
fi

echo " " >> /home/jcdcn/bspLogHandle/report

echo "${ysDate} LED素材ID播放详情如下：" >> /home/jcdcn/bspLogHandle/report
echo " " >> /home/jcdcn/bspLogHandle/report
echo "素材ID   播放次数"  >> /home/jcdcn/bspLogHandle/report
awk '{if (NR%2==0){print $0} else {printf"%s  ",$0}}' /home/jcdcn/bspLogHandle/1.txt >> /home/jcdcn/bspLogHandle/report

echo " " >> /home/jcdcn/bspLogHandle/report
echo "Best Regards" >> /home/jcdcn/bspLogHandle/report
#su STD-MO -c "cat /home/jcdcn/bspLogHandle/report | /usr/bin/mutt -s "${ysDate}日志收集" jinp.jiang@jcdecaux.com"

su STD-MO -c "cat /home/jcdcn/bspLogHandle/report | /usr/bin/mutt -s "${ysDate}日志收集" james.ling@jcdecaux.com,ekko.gu@jcdecaux.com,dechen.xu@jcdecaux.com -c "eric.zhu@jcdecaux.com,yassel.jiang@jcdecaux.com,sam.cheng@jcdecaux.com,jinp.jiang@jcdecaux.com""

echo "OK" > /home/jcdcn/bspLogHandle/email-tmp
}

Tar
LEDpercent
count
emailstamp="/home/jcdcn/bspLogHandle/email-tmp"
if [ -s ${emailstamp} ];then
        echo "ok"
else
        sendmail
fi
