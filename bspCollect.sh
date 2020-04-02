#/bin/bash
Type="$1"
lsDate=`date +'%Y-%m-%d'`
#lsDate="$2"
filePath="/home/STD-MO/bspLog/${Type}"

mkdir -p /home/STD-MO/bspLog/${Type}

echo "date: ${lsDate}" > /home/STD-MO/bspLog/date.yml

/usr/bin/ansible-playbook /home/STD-MO/bspLog/bsp${Type}Log.yml

mv /home/STD-MO/bspLog/bsp${Type}Log.retry /home/STD-MO/bspLog/bsp${Type}Log.retry.${lsDate}

mkdir -p /home/jcdcn/bspLogHandle/bspLog/${lsDate}/

mv ${filePath} /home/jcdcn/bspLogHandle/bspLog/${lsDate}/
