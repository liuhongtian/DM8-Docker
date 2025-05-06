FROM centos:centos7

# 添加安装包及安装响应文件
COPY DMInstall.bin /opt
COPY auto_install.xml /tmp
RUN chmod a+x /opt/DMInstall.bin
RUN chmod 755 /tmp/auto_install.xml

# 配置yum源
RUN sed -i.bak -e 's|^mirrorlist=|#mirrorlist=|g' -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos-vault/centos|g' /etc/yum.repos.d/CentOS-Base.repo
RUN yum update -y

# 安装中文支持
RUN yum install -y kde-l10n-Chinese
RUN yum -y reinstall glibc-common
RUN yum clean all
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
ENV LANG=zh_CN.UTF-8
ENV LC_ALL=zh_CN.UTF-8
RUN echo 'LANG="zh_CN.UTF-8"' > /etc/locale.conf
RUN rm -f /etc/localtime
RUN ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 创建dmdba用户
RUN groupadd dinstall -g 2001
RUN useradd  -G dinstall -m -d /home/dmdba -s /bin/bash -u 2001 dmdba

# 设置dmdba用户资源限制
RUN echo 'dmdba  soft      nice       0' >> /etc/security/limits.conf
RUN echo 'dmdba  hard      nice       0' >> /etc/security/limits.conf
RUN echo 'dmdba  soft      as         unlimited' >> /etc/security/limits.conf
RUN echo 'dmdba  hard      as         unlimited' >> /etc/security/limits.conf
RUN echo 'dmdba  soft      fsize      unlimited' >> /etc/security/limits.conf
RUN echo 'dmdba  hard      fsize      unlimited' >> /etc/security/limits.conf
RUN echo 'dmdba  soft      nproc      65536' >> /etc/security/limits.conf
RUN echo 'dmdba  hard      nproc      65536' >> /etc/security/limits.conf
RUN echo 'dmdba  soft      nofile     65536' >> /etc/security/limits.conf
RUN echo 'dmdba  hard      nofile     65536' >> /etc/security/limits.conf
RUN echo 'dmdba  soft      core       unlimited' >> /etc/security/limits.conf
RUN echo 'dmdba  hard      core       unlimited' >> /etc/security/limits.conf
RUN echo 'dmdba  soft      data       unlimited' >> /etc/security/limits.conf
RUN echo 'dmdba  hard      data       unlimited' >> /etc/security/limits.conf

# 创建dmdata目录，可挂载外部卷到相应目录，以实现持久化。
RUN mkdir -p /dmdata/data

RUN chown -R dmdba:dinstall /dmdata
RUN chmod -R 755 /dmdata

VOLUME [ "/dmdata/data" ]

# 安装数据库
USER dmdba
WORKDIR /opt 
RUN ./DMInstall.bin -q /tmp/auto_install.xml

# 清理安装包
USER root
RUN rm -f /opt/DMInstall.bin
RUN rm -f /tmp/auto_install.xml

USER dmdba
WORKDIR /home/dmdba
RUN echo 'export PATH=$PATH:$DM_HOME/bin:$DM_HOME/tool"' >> .bash_profile
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/dmdba/dmdbms/bin
ENV DM_HOME=/home/dmdba/dmdbms
ENV PATH=$PATH:$DM_HOME/bin:$DM_HOME/tool

# 暴露数据库实例服务端口
EXPOSE 5237

# 添加启动脚本
COPY entrypoint.sh /home/dmdba

# 设置环境变量（可从外部传入从而覆盖缺省值）
ENV PAGE_SIZE=32
ENV EXTENT_SIZE=32
ENV CASE_SENSITIVE=y
ENV CHARSET=1
ENV DB_NAME=DMDB
ENV INSTANCE_NAME=DBSERVER
ENV PORT_NUM=5237
ENV SYSDBA_PWD=Huawei2025
ENV SYSAUDITOR_PWD=Huawei2025

# 启动数据库实例服务
ENTRYPOINT ["/usr/bin/sh", "/home/dmdba/entrypoint.sh"]
