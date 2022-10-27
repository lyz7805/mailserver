# Docker MailServer - Postfix + Dovecot + MySQL
Simple mail server with [Postfix](https://www.postfix.org) and [Dovecot](https://www.dovecot.org/) in docker, the server uses MySQL to manage all your email domains and users.

## Reuqire
* Docker - to run the application
* MySQL - to manage the email domains and users, you can create db by run the [DBinit.sql](DBinit.sql) file

## Build
```sh
sh -c ./build.sh
```

## Usage
1. Pull the image
    ```sh
    docker pull 94love1/mailserver
    ```
2. Create envionment file
    ```sh
    cp .env.template .env
    ```
3. Set your configuration
    * save your SSL certificates `.key` and `.crt` into `/path/to/certs` dir
    * set yourt environment vars
4. Docker run
    ```sh
    docker run -d \
        --name mailserver \
        --env-file .env \
        -p 25:25 \
        -p 465:465 \
        -p 993:993 \
        -p 995:995 \
        -v /path/to/certs:/etc/ssl/mail \
        -v /path/to/key/mail.private:/var/db/dkim/mail.private \
        -v mailserver-mail:/var/mail \
        94love1/mailserver
    ```

## Reference
* [Linux邮件服务器搭建攻略(一文吃透Postfix+Dovecot+MySQL)](https://www.jianshu.com/p/ffe2182c12f3)
* [Postfix + Dovecot + MySQL 搭建邮件服务器](https://my.oschina.net/barat/blog/4965904)
* [Postfix SASL Howto](https://www.postfix.org/SASL_README.html)
* [Postfix TLS Support](http://www.postfix.org/TLS_README.html)
* [Postfix before-queue Milter support](https://www.postfix.org/MILTER_README.html)
* [OpenDKIM README](http://www.opendkim.org/opendkim-README)
* [catatnight/docker-postfix](https://github.com/catatnight/docker-postfix)
* [juanluisbaptiste/docker-postfix](https://github.com/juanluisbaptiste/docker-postfix)
* [Codegyre/DockerPostfixDovecot](https://github.com/Codegyre/DockerPostfixDovecot)
* [bokysan/docker-postfix](https://github.com/bokysan/docker-postfix)
* [SPF Policy Daemon for Postfix (policyd-spf-fs) README](https://www.freestone.net/ftp/policyd-spf-fs/policyd-spf-fs_23/README)