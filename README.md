# DM8 Docker镜像（X86_64版本）

基于DM8官方Linux X86镜像（dm8_20250122_x86_rh7_64.iso）构建，并构建在 **CentOS 7** 基础上。

## no-volume目录

此目录中存放的是不指定命名卷的镜像的构建脚本，已废弃。

## 关于dminit脚本的参数

可以执行如下命令，查看dminit脚本的全部可用参数：

```bash
dminit help
```

以下是dm8_20250122_x86_rh7_64版本的所有可用参数：

```
关键字                     说明（默认值）
--------------------------------------------------------------------------------
INI_FILE                   初始化文件dm.ini存放的路径
PATH                       初始数据库存放的路径
CTL_PATH                   控制文件路径
LOG_PATH                   日志文件路径
EXTENT_SIZE                数据文件使用的簇大小(16)，可选值：16, 32, 64，单位：页
PAGE_SIZE                  数据页大小(8)，可选值：4, 8, 16, 32，单位：K
LOG_SIZE                   日志文件大小(4096)，单位为：M，范围为：256M ~ 8G
CASE_SENSITIVE             大小敏感(Y)，可选值：Y/N，1/0
CHARSET/UNICODE_FLAG       字符集(0)，可选值：0[GB18030]，1[UTF-8]，2[EUC-KR]
SEC_PRIV_MODE              权限管理模式(0)，可选值：0[TRADITION]，1[BMJ]，2[EVAL]，3[BAIST]，4[ZBMM]
SYSDBA_PWD                 设置SYSDBA密码
SYSAUDITOR_PWD             设置SYSAUDITOR密码
DB_NAME                    数据库名(DAMENG)
INSTANCE_NAME              实例名(DMSERVER)
PORT_NUM                   监听端口号(5236)
BUFFER                     系统缓存大小(8000)，单位M
TIME_ZONE                  设置时区(+08:00)
PAGE_CHECK                 页检查模式(3)，可选值：0/1/2/3
PAGE_HASH_NAME             设置页检查HASH算法
EXTERNAL_CIPHER_NAME       设置默认加密算法
EXTERNAL_HASH_NAME         设置默认HASH算法
EXTERNAL_CRYPTO_NAME       设置根密钥加密引擎
RLOG_ENCRYPT_NAME          设置日志文件加密算法，若未设置，则不加密
RLOG_POSTFIX_NAME          设置日志文件后缀名，长度不超过10。默认为log，例如DAMENG01.log
USBKEY_PIN                 设置USBKEY PIN
PAGE_ENC_SLICE_SIZE        设置页加密分片大小，可选值：0、512、4096，单位：Byte
ENCRYPT_NAME               设置全库加密算法
BLANK_PAD_MODE             设置空格填充模式(0)，可选值：0/1
SYSTEM_MIRROR_PATH         SYSTEM数据文件镜像路径
MAIN_MIRROR_PATH           MAIN数据文件镜像
ROLL_MIRROR_PATH           回滚文件镜像路径
MAL_FLAG                   初始化时设置dm.ini中的MAL_INI(0)
ARCH_FLAG                  初始化时设置dm.ini中的ARCH_INI(0)
MPP_FLAG                   Mpp系统内的库初始化时设置dm.ini中的mpp_ini(0)
CONTROL                    初始化配置文件（配置文件格式见系统管理员手册）
AUTO_OVERWRITE             是否覆盖所有同名文件(0) 0:不覆盖 1:部分覆盖 2:完全覆盖
USE_NEW_HASH               是否使用改进的字符类型HASH算法(1)
ELOG_PATH                  指定初始化过程中生成的日志文件所在路径
AP_PORT_NUM                分布式环境下协同工作的监听端口
HUGE_WITH_DELTA            是否仅支持创建事务型HUGE表(1) 1:是 0:否
RLOG_GEN_FOR_HUGE          是否生成HUGE表REDO日志(1) 1:是 0:否
PSEG_MGR_FLAG              是否仅使用管理段记录事务信息(0) 1:是 0:否
CHAR_FIX_STORAGE           CHAR是否按定长存储(N)，可选值：Y/N，1/0
SQL_LOG_FORBID             是否禁止打开SQL日志(N)，可选值：Y/N，1/0
DPC_MODE                   指定DPC集群中的实例角色(0) 0:无 1:MP 2:BP 3:SP，取值1/2/3时也可以用MP/BP/SP代替
USE_DB_NAME                路径是否拼接DB_NAME(1) 1:是 0:否
MAIN_DBF_PATH              MAIN数据文件存放路径
SYSTEM_DBF_PATH            SYSTEM数据文件存放路径
ROLL_DBF_PATH              ROLL数据文件存放路径
TEMP_DBF_PATH              TEMP数据文件存放路径
ENC_TYPE                   数据库内部加解密使用的加密接口类型(1), 可选值: 1: 优先使用EVP类型 0: 不启用EVP类型
RANDOM_CRYPTO              随机数算法所在加密引擎名
DPC_TENANCY                指定DPC集群是否启用多租户模式(0) 0:不启用 1:启用，取值0/1时也可以用FALSE/TRUE代替
HELP                       打印帮助信息
```

## entrypoint.sh

这是容器的运行入口，逻辑是：如果数据库的 **dm.ini** 文件不存在，则初始化数据库。之后，启动数据库。

## 运行容器

**run.sh** 脚本用于运行容器，这个脚本只是为了简化运行容器时的输入。脚本内容如下：

```bash
docker run -d \
--name dm8 \
-p 5237:5237 \
-v ./dmdata/data:/dmdata/data \
-e PAGE_SIZE=32 \
-e EXTENT_SIZE=32 \
-e CASE_SENSITIVE=y \
-e CHARSET=1 \
-e INSTANCE_NAME=DBSERVER \
-e PORT_NUM=5237 \
-e SYSDBA_PWD=Huawei2025 \
-e SYSAUDITOR_PWD=Huawei2025 \
dm8:dm8_20250122_x86_rh7_64
```

以上脚本指定了容器名称（dm8），挂载了数据库目录卷（./dmdata/data:/dmdata:data），并指定了一系列环境变量（覆盖了Dockerfile中的缺省值）：

```bash
PAGE_SIZE=32
EXTENT_SIZE=32
CASE_SENSITIVE=y
CHARSET=1
INSTANCE_NAME=DBSERVER
PORT_NUM=5237
SYSDBA_PWD=Huawei2025
SYSAUDITOR_PWD=Huawei2025
```

这是目前的镜像支持的全部参数，如果想指定其他变量，需要修改Dockerfile、entrypoint.sh，并重新构建镜像。
