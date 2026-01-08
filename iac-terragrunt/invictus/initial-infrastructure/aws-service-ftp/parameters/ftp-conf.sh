#!/bin/bash
sudo -i
apt update && apt upgrade -y
apt install -y net-tools vsftpd s3fs db-util libpam-modules awscli lftp


# Crear los directorios necesarios
sudo mkdir -p /etc/vsftpd
sudo mkdir -p /mnt/ftp-bucket
sudo mkdir -p /etc/vsftpd/user_conf


# Crear el usuario del sistema 'ftp' para mapear los usuarios virtuales
sudo adduser --system --home /home/ftp --shell /usr/sbin/nologin --group ftp
sudo mkdir -p /home/ftp
sudo chown -R ftp:ftp /home/ftp
sudo chown -R ftp:ftp /mnt/ftp-bucket


# Configurar las credenciales de AWS para s3fs
sudo sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf || true
echo "$S3_BUCKET /mnt/ftp-bucket fuse.s3fs _netdev,allow_other,nonempty,iam_role=auto,use_path_request_style,url=https://s3.amazonaws.com 0 0" | sudo tee -a /etc/fstab
sudo mount -a
sudo df -h | grep ftp-bucket
sudo mount | grep /mnt/ftp-bucket
#journalctl -xe | grep s3fs


# Crear el archivo de usuarios virtuales
sudo tee /etc/vsftpd/list_users.txt > /dev/null <<EOF
guest
R3d!t0s.2025*
EOF


# Crear la base de datos de usuarios virtuales
sudo db_load -T -t hash -f /etc/vsftpd/list_users.txt /etc/vsftpd/users.db
sudo chmod 600 /etc/vsftpd/list_users.txt
sudo chmod 600 /etc/vsftpd/users.db


# Comentar todas las líneas que no estén vacías - Luego agregar las líneas necesarias para la autenticación PAM
sudo sed -i 's/^\(.*\S.*\)$/# \1/' /etc/pam.d/vsftpd
echo "auth    required pam_userdb.so db=/etc/vsftpd/users" | sudo tee -a /etc/pam.d/vsftpd
echo "account required pam_userdb.so db=/etc/vsftpd/users" | sudo tee -a /etc/pam.d/vsftpd



# Configuración principal de vsftpd
export PORT="00000"
export PASV_MIN="00000"
export PASV_MAX="00000"
export PUBLIC_IP="000.000.000.000"
export S3_BUCKET="ftp-collections-000"

sudo tee /etc/vsftpd.conf > /dev/null <<EOF
# Archivo de configuración principal de vsftpd
listen=YES
listen_ipv6=NO
listen_port=$PORT

anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
xferlog_std_format=YES
vsftpd_log_file=/var/log/xferlog
connect_from_port_20=YES

# TLS / FTPS explícito
ssl_enable=YES
allow_anon_ssl=NO
force_local_logins_ssl=YES
force_local_data_ssl=YES
require_ssl_reuse=NO
seccomp_sandbox=NO
ssl_sslv2=NO
ssl_sslv3=NO
rsa_cert_file=/etc/ssl/certs/vsftpd.pem
rsa_private_key_file=/etc/ssl/private/vsftpd.key


# Usuarios virtuales
guest_enable=YES
guest_username=ftp
virtual_use_local_privs=YES
pam_service_name=vsftpd
user_config_dir=/etc/vsftpd/user_conf

# CONFIGURACIÓN DE PASV
pasv_enable=YES
pasv_min_port=$PASV_MIN
pasv_max_port=$PASV_MAX
pasv_address=$PUBLIC_IP

# Chroot para usuarios locales y virtuales
chroot_local_user=YES
allow_writeable_chroot=YES

# Permitimos solo las cuentas listadas por PAM (virtual users)
userlist_enable=YES
userlist_deny=NO
userlist_file=/etc/vsftpd/list_users.txt
EOF


# Configuración específica para el usuario virtual "guest"
sudo tee /etc/vsftpd/user_conf/guest > /dev/null <<EOF
local_root=/mnt/ftp-bucket/guest
write_enable=YES
local_umask=022
EOF

# Crear el directorio para el usuario virtual "guest"
sudo mkdir -p /mnt/ftp-bucket/guest
sudo chown -R ftp:ftp /mnt/ftp-bucket/guest
sudo chmod 750 /mnt/ftp-bucket/guest


# Generar certificados SSL/TLS autofirmados
export DOMAIN="invictus-ftp-..."

sudo openssl req -x509 -nodes -days 14600 -newkey rsa:2048 \
-keyout /etc/ssl/private/vsftpd.key \
-out /etc/ssl/certs/vsftpd.pem \
-subj "/C=CO/ST=Antioquia/L=Medellin/O=UX Technology/OU=Fabrica de Software/CN=$DOMAIN" \
-addext "subjectAltName=DNS:$DOMAIN"
sudo openssl x509 -in /etc/ssl/certs/vsftpd.pem -text -noout

sudo chmod 600 /etc/ssl/private/vsftpd.key
sudo chmod 644 /etc/ssl/certs/vsftpd.pem


sudo systemctl start vsftpd
sudo systemctl status vsftpd --no-pager
sudo systemctl enable vsftpd

sudo systemctl stop ufw
sudo systemctl disable ufw


## Agregar las siguientes líneas:
sudo systemctl edit vsftpd
[Service]
ExecStart=
ExecStart=/usr/sbin/vsftpd /etc/vsftpd.conf


# Reiniciar el servicio vsftpd para aplicar los cambios
sudo systemctl daemon-reexec
sudo systemctl restart vsftpd
sudo systemctl status vsftpd --no-pager
sudo netstat -tulnp | grep vsftpd


# Probar la conexión FTP usando lftp
lftp -u guest,'R3d!t0s.2025*' -p $PORT 127.0.0.1
