#***********************************************#
#!bin/bash										#
#***********************************************#

#从被迁移的服务器上取片子
#有2条命令可供选择：① dcmqr  ② getscu

#**********************************************************************************************************************************************
#① dcmqr --------------------------------------------------------------------------------------------------------------------------------------
#**********************************************************************************************************************************************
#get_pacs()
#{
#dcm_server=dcm.beijing.rimag.com.cn:11112		#被迁移的服务器
#dcmqr_server=/home/setup/dcm4che/bin/dcmqr		#dcmqr命令的路径
#type_server=CT						#片子的类型
#route_server=/tmp/Geek					#要保存片子的本地路径
#
#sudo ${dcmqr_server} -L GETME@localhost:11113 DCM4CHEE@${dcm_server} -cget -qStudyInstanceUID=${uid_server} -cstore ${type_server} -cstoredest ${route_server} -S
#}
#----------------------------------------------------------------------------------------------------------------------------------------------
#**********************************************************************************************************************************************

#② getscu
get_pacs()
{
dcm_server=dcm.cloud.neimeng.rimag.com.cn:11112
getscu_server=/home/setup/dcm4che/bin/getscu
route_server=/tmp/Geek
uid_server=1.2.840.113704.1.111.11452.1464750123.1

sudo ${getscu_server} -c DCM4CHEE@${dcm_server} -m StudyInstanceUID=${uid_server} --directory ${route_server}
}

out_pacs()
{
#dcm_pacs=dcm.rimag.com.cn:11112					#要迁移的服务器
dcm_pacs=dcm2.neimeng.rimag.com.cn:11112					#要迁移的服务器
storescu_pacs=/home/setup/dcm4che/bin/storescu	#storescu命令的路径
route_pacs=/tmp/Geek							#被迁移服务器的片子路径

sudo ${storescu_pacs} -b NMGCFSSYYCT2 -c DCM4CHEE@${dcm_pacs} ${route_pacs}
}

delete_AET()
{
sudo rm -r /tmp/Geek
sudo mkdir /tmp/Geek
}

get_ID()
{
db_server=nfs.beijing.rimag.com.cn				#被迁移服务器的数据库
db_user=pacs									#数据库账号
db_passwd=pacs									#数据库密码
db_db=pacsdb									#被迁移数据库的名称
uid_file=uid_file.Geek							#保存UID的文件名

sudo mysql -h${db_server} -u${db_user} -p${db_passwd} -D ${db_db} -e "select study.study_iuid from study left join series on series.study_fk=study.pk where series.src_aet='BJCWTTPHYYCT' group by study.study_iuid" | awk NR>${uid_file}
}


delete_ID()
{
twiddle_delete=/home/setup/Geek_zhangyi/dcm4chee/jboss-4.2.3.GA/bin/
del_user=admin
del_passwd=admin

sudo ${twiddle_delete}./twiddle.sh -u${del_user} -p${del_passwd} invoke "dcm4chee.archive:service=ContentEditService" purgeStudy ${uid_server}
}

read_ID()
{
cat uid_file.Geek | while read uid_server		#逐行读取UID文件中的序列，并将UID赋值给变量
do
echo "No.==>: " " $uid_server"
sleep 1											#每迁移一个UID延时3秒
#delete_AET										#将保存在本地的片子发到要迁移服务器
get_pacs										#从被迁移的服务器上取片子
out_pacs										#将保存在本地的片子发到要迁移服务器

delete_ID
done
}

#get_ID
#read_ID
get_pacs
#out_pacs
