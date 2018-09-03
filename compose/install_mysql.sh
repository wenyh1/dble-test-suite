#!/bin/bash
#install mysql
echo "copy mysql source"

rm -rf /usr/local/mysql
cd /init_assets && tar -zxf mysql-5.7.13-linux-glibc2.5-x86_64.tar.gz
mv /init_assets/mysql-5.7.13-linux-glibc2.5-x86_64 /usr/local/mysql
cp /usr/local/mysql/support-files/my-default.cnf /etc/my.cnf

groupadd mysql
useradd -r -g mysql -s /bin/false mysql
cd /usr/local/mysql
mkdir data
chown -R mysql:mysql .
yum -y install libaio
yum -y install dos2unix

echo "configure my.cnf!"
sed -i '/mysqld_safe/,+2d' /etc/my.cnf
sed -i -e '$a [client] \nuser=test \npassword=111111 \nhost=127.0.0.1 \n' -e "/\[mysqld\]/a server-id=$(($1+2)) \nsession_track_schema=1 \nsession_track_state_change=1 \nsession_track_system_variables=\"*\" \ngtid-mode=on \nenforce_gtid_consistency=on" /etc/my.cnf

echo "mysql initialize!"
rm -rf /var/lib/mysql
/usr/local/mysql/bin/mysqld --initialize-insecure --basedir=/usr/local/mysql --user=mysql >/dev/null 2>&1

echo "openssl install!"
yum install -y openssl > /tmp/install_openssl.log
yum install -y openssh-server

echo "mysql_ssl_rsa_setup!"
/usr/local/mysql/bin/mysql_ssl_rsa_setup > /tmp/mysql_ssl_rsa_setup.log

echo "mysql start!"
/usr/local/mysql/bin/mysqld_safe --defaults-file=/etc/my.cnf --user=mysql >/dev/null 2>&1 &

sleep 5s
/usr/local/mysql/bin/mysql -uroot --skip-password -e "alter user user() identified by '111111'"

echo "net-tools install!"
yum install -y net-tools > /dev/null 2>&1

rm -rf /usr/bin/mysql
ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
