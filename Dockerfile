FROM alpine:latest
LABEL org.opencontainers.image.authors="lyz7805@126.com"

ENV SSL_DIR=/etc/ssl/mail
ENV TZ=Asia/Shanghai

ADD postfix /etc/postfix
ADD dovecot /etc/dovecot

# 增加用户及用户组，设置权限
RUN set -ex && \
    addgroup -g 5000 vmail && \
    adduser -G vmail -u 5000 -h /var/mail -D vmail

# 设置清华镜像源
RUN set -ex && \
    sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories

# 更新应该并安装必要软件
RUN set -ex && \
    apk update && \
    apk add --no-cache \
    bash ca-certificates openssl tzdata \
    postfix postfix-mysql \
    dovecot dovecot-mysql dovecot-pop3d

# 增加用户及用户组，设置权限
RUN set -ex && \
    chgrp postfix /etc/postfix/mysql-*.cf && \
    chgrp vmail /etc/dovecot/dovecot.conf && \
    chmod g+r /etc/dovecot/dovecot.conf

# 设置工作目录
WORKDIR /app

COPY scripts/* /app

# 初始化部分配置
RUN set -ex && \
    /bin/sh -c ./init.sh

# 移除缓存
RUN set -ex && \
    rm -rf /var/cache/apk/*

# VOLUME [ "/var/mail" ]

# SMTP port
EXPOSE 25
# SMTPS port
EXPOSE 465
# IMAPS port
EXPOSE 993
# POP3S port
EXPOSE 995

ENTRYPOINT ["/bin/sh", "-c", "./run.sh"]