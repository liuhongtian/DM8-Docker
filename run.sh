docker run -d \
--name dm8 \
-p 5237:5237 \
-v ~/dmdata/data:/dmdata/data \
-e PAGE_SIZE=32 \
-e EXTENT_SIZE=32 \
-e CASE_SENSITIVE=y \
-e CHARSET=1 \
-e INSTANCE_NAME=DBSERVER \
-e PORT_NUM=5237 \
-e SYSDBA_PWD=Huawei2025 \
-e SYSAUDITOR_PWD=Huawei2025 \
dm8:dm8_20251208_x86_CentOS7_64
