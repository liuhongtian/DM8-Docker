export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/dmdba/dmdbms/bin
export DM_HOME=/home/dmdba/dmdbms
export PATH=$PATH:$DM_HOME/bin:$DM_HOME/tool

cd /home/dmdba/dmdbms/bin

if [ ! -f /dmdata/data/$DB_NAME/dm.ini ]; then
    # 如果dm.ini不存在，则初始化数据库
    ./dminit path=/dmdata/data PAGE_SIZE=$PAGE_SIZE EXTENT_SIZE=$EXTENT_SIZE CASE_SENSITIVE=$CASE_SENSITIVE CHARSET=$CHARSET DB_NAME=$DB_NAME INSTANCE_NAME=$INSTANCE_NAME PORT_NUM=$PORT_NUM SYSDBA_PWD=$SYSDBA_PWD SYSAUDITOR_PWD=$SYSAUDITOR_PWD
fi

# 启动数据库
./dmserver /dmdata/data/$DB_NAME/dm.ini
