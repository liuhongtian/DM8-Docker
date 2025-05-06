export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/dmdba/dmdbms/bin
export DM_HOME=/home/dmdba/dmdbms
export PATH=$PATH:$DM_HOME/bin:$DM_HOME/tool
cd /home/dmdba/dmdbms/bin
./DmServiceDMDB start
tail -f /dev/null
