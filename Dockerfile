FROM centos:centos7

COPY DMInstall.bin /opt
COPY auto_install.xml /tmp

RUN chmod a+x /opt/DMInstall.bin
RUN chmod 755 /tmp/auto_install.xml

ARG DMDBA_PASSWORD
#ENV DMDBA_PASSWORD=${DMDBA_PASSWORD}

RUN groupadd dinstall -g 2001
RUN useradd  -G dinstall -m -d /home/dmdba -s /bin/bash -u 2001 dmdba
RUN echo "dmdba:${DMDBA_PASSWORD}" | chpasswd
RUN unset DMDBA_PASSWORD

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

RUN mkdir -p /dmdata/data
RUN mkdir -p /dmdata/arch
RUN mkdir -p /dmdata/dmbak

RUN chown -R dmdba:dinstall /dmdata
RUN chmod -R 755 /dmdata

USER dmdba

WORKDIR /opt

RUN ./DMInstall.bin -q /tmp/auto_install.xml

USER root

RUN /home/dmdba/dmdbms/script/root/root_installer.sh

ENV PATH=$PATH:$DM_HOME/bin:$DM_HOME/tool

WORKDIR /home/dmdba

RUN echo 'export PATH=$PATH:$DM_HOME/bin:$DM_HOME/tool"' >> .bash_profile

USER dmdba
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/dmdba/dmdbms/bin
ENV DM_HOME=/home/dmdba/dmdbms
ENV PATH=$PATH:$DM_HOME/bin:$DM_HOME/tool

WORKDIR /home/dmdba/dmdbms/bin

ENTRYPOINT ["/usr/bin/bash"]
CMD ["/home/dmdba/dmdbms/bin/dminit"]


