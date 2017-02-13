FROM centos:7
MAINTAINER Alex S. Médice <alex.medice@gmail.com>

ENV container docker

RUN yum -y swap -- remove fakesystemd -- install systemd systemd-libs
RUN yum -y update; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

# SSHD
RUN yum install -y openssh-server && \
    mkdir -p /var/run/sshd && \
    sed -i -e 's/#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
RUN getent passwd sshd || useradd -g sshd sshd

VOLUME [ "/sys/fs/cgroup" ]

CMD ["/usr/sbin/init"]