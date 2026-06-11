#!/bin/bash
apt update && apt upgrade -y
apt install -y vsftpd s3fs fuse db-util libpam-mysql openssl net-tools awscli 


export PORT="000"
export PASV_MIN="000"
export PASV_MAX="000"
export PUBLIC_IP="000.000.000.000"
export BUCKET="ftp-collections-000"
export MYSQL_USER="..."
export MYSQL_PASS="..."
export MYSQL_HOST="..."
export MYSQL_PORT="..."
export DOMAIN="invictus-ftp-..."
    # echo $...


## Crear los directorios necesarios
sudo mkdir -p /etc/vsftpd
sudo mkdir -p /mnt/ftp-bucket
sudo mkdir -p /mnt/ftp-bucket/aliados/.user_conf
sudo mkdir -p /etc/vsftpd/user_conf


## Crear el usuario del sistema 'ftp' para mapear los usuarios virtuales
sudo adduser --system --home /home/ftp --shell /usr/sbin/nologin --group ftp
sudo mkdir -p /home/ftp
sudo chown -R ftp:ftp /home/ftp
sudo chown -R ftp:ftp /mnt/ftp-bucket


## Configurar las credenciales de AWS para s3fs
sudo sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf || true
echo "$BUCKET /mnt/ftp-bucket fuse.s3fs _netdev,allow_other,nonempty,iam_role=auto,uid=ftp,gid=ftp,use_path_request_style,url=https://s3.amazonaws.com 0 0" | sudo tee -a /etc/fstab
sudo mount -a
    # sudo df -h | grep ftp-bucket
    # sudo mount | grep /mnt/ftp-bucket
    # journalctl -xe | grep s3fs


## Comentar todas las líneas - Luego agregar las líneas necesarias para la autenticación con MySQL
sudo sed -i 's/^\(.*\S.*\)$/# \1/' /etc/pam.d/vsftpd
echo "auth    required  pam_mysql.so user=$MYSQL_USER passwd=$MYSQL_PASS host=$MYSQL_HOST port=$MYSQL_PORT db=dynamicstorage table=FTP_USERS_GESTION usercolumn=username passwdcolumn=password crypt=1" | sudo tee -a /etc/pam.d/vsftpd
echo "account required  pam_mysql.so user=$MYSQL_USER passwd=$MYSQL_PASS host=$MYSQL_HOST port=$MYSQL_PORT db=dynamicstorage table=FTP_USERS_GESTION usercolumn=username passwdcolumn=password crypt=1" | sudo tee -a /etc/pam.d/vsftpd


## Configuración principal de vsftpd
sudo tee /etc/vsftpd.conf > /dev/null <<EOF
# Archivo de configuración principal de vsftpd
listen=YES
listen_ipv6=NO
listen_port=$PORT
hide_ids=YES
local_umask=027
local_enable=YES
write_enable=YES
use_localtime=YES
seccomp_sandbox=NO
dirmessage_enable=YES
dual_log_enable=YES
log_ftp_protocol=YES
xferlog_enable=YES
xferlog_std_format=YES
vsftpd_log_file=/var/log/xferlog

# TLS / FTPS explícito
allow_anon_ssl=NO
require_ssl_reuse=NO
force_local_logins_ssl=YES
force_local_data_ssl=YES
ssl_enable=YES
ssl_sslv2=NO
ssl_sslv3=NO
ssl_tlsv1=YES
ssl_ciphers=HIGH
rsa_cert_file=/etc/ssl/private/vsftpd.pem

# Usuarios virtuales
anonymous_enable=NO
anon_world_readable_only=NO
guest_enable=YES
guest_username=ftp
pam_service_name=vsftpd
virtual_use_local_privs=YES
user_config_dir=/etc/vsftpd/user_conf

# Chroot para usuarios locales y virtuales
chroot_local_user=YES
allow_writeable_chroot=YES

# CONFIGURACION DE PASV
pasv_enable=YES
pasv_promiscuous=NO
pasv_min_port=$PASV_MIN
pasv_max_port=$PASV_MAX
pasv_address=$PUBLIC_IP
max_per_ip=5
max_login_fails=5
idle_session_timeout=600
data_connection_timeout=120
EOF
    #vsftpd /etc/vsftpd.conf


## Configuración específica para el usuario principal "ftp"
sudo tee /etc/vsftpd/user_conf/invictus > /dev/null <<EOF
local_root=/mnt/ftp-bucket/
write_enable=YES
EOF


## Generar certificados SSL/TLS autofirmados
sudo openssl req -x509 -nodes -days 14600 -newkey rsa:2048 \
-keyout /etc/ssl/private/vsftpd.pem \
-out /etc/ssl/private/vsftpd.pem \
-subj "/C=CO/ST=Antioquia/L=Medellin/O=UX Technology/OU=Fabrica de Software/CN=$DOMAIN" \
-addext "subjectAltName=DNS:$DOMAIN"

chmod 600 /etc/ssl/private/vsftpd.pem
chown root:root /etc/ssl/private/vsftpd.pem
openssl x509 -in /etc/ssl/private/vsftpd.pem -text -noout


## Sincronizar usuarios VSFTPD
sudo tee /usr/local/bin/vsftpd-sync.sh > /dev/null <<EOF
#!/bin/bash
while true; do
    cp -n /mnt/ftp-bucket/aliados/.user_conf/* /etc/vsftpd/user_conf/ 2>/dev/null || true
    sleep 5
done
EOF

sudo tee /etc/systemd/system/vsftpd-sync.service > /dev/null <<EOF
[Unit]
Description=Sync VSFTPD user_conf from S3 bucket
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/vsftpd-sync.sh
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

sudo chmod +x /usr/local/bin/vsftpd-sync.sh
sudo systemctl daemon-reload
sudo systemctl enable vsftpd-sync
sudo systemctl start vsftpd-sync
    # systemctl status vsftpd-sync


## Override del servicio vsftpd en systemd para usar configuración personalizada
sudo mkdir -p /etc/systemd/system/vsftpd.service.d
sudo tee /etc/systemd/system/vsftpd.service.d/override.conf > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=/usr/sbin/vsftpd /etc/vsftpd.conf
EOF
    # sudo systemctl edit vsftpd


## Inciar servicio VSFTPD
sudo systemctl daemon-reload
sudo systemctl enable vsftpd
sudo systemctl start vsftpd
sudo systemctl status vsftpd --no-pager
    # sudo netstat -tulnp | grep vsftpd


## Añadir reglas al Firewall
sudo ufw allow 22/tcp
sudo ufw allow $PORT/tcp
sudo ufw allow $PASV_MIN:$PASV_MAX/tcp
sudo ufw --force enable
    # sudo ufw status
