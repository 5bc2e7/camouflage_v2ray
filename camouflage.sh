#!/bin/bash

#fonts color
Green="\033[32m"
Red="\033[31m"
# Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"

#notification information
OK="${Green}[OK]${Font}"
Error="${Red}[错误]${Font}"

camouflagedir="$(head -c 6 /dev/urandom | md5sum | head -c 6)"

camouflage_v2ray(){
cat /root/v2ray_info.inf
sleep 2
echo -e "${RedBG} 请保存v2ray的配置信息 选择是否继续（y/n）${Font}" && read -r install
case $install in
    [yY][eE][sS] | [yY])
        echo -e "${GreenBG} 继续 ${Font}"
        sleep 2
		    demo
        ;;
    *)
        echo -e "${RedBG} 终止 ${Font}"
        exit 0
        ;;
    esac
}

demo(){
rm -rf /root/install.sh
rm -rf /root/v2ray_info.inf
systemctl stop v2ray
systemctl disable v2ray
mv /etc/v2ray /etc/${camouflagedir}
mv /usr/bin/v2ray /usr/bin/${camouflagedir}
mv /usr/bin/${camouflagedir}/v2ray /usr/bin/${camouflagedir}/${camouflagedir}
mv /usr/local/bin/v2ray /usr/local/bin/${camouflagedir}
mv /usr/local/lib/v2ray /usr/local/lib/${camouflagedir}
#sed -i "s/v2ray/${camouflagedir}/g" /etc/systemd/system/v2ray.service
#mv /etc/systemd/system/v2ray.service /etc/systemd/system/${camouflagedir}.service
rm -rf /etc/systemd/system/v2ray.service
echo "
[Unit]
Description=${camouflagedir} Service
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
Environment=V2RAY_LOCATION_ASSET=/usr/local/lib/${camouflagedir}/
ExecStart=/usr/local/bin/${camouflagedir} -config /etc/${camouflagedir}/config.json
Restart=on-failure

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/${camouflagedir}.service
chmod 644 /etc/systemd/system/${camouflagedir}.service
systemctl start ${camouflagedir}.service
systemctl enable ${camouflagedir}.service

systemctl stop nginx
sed -i "s/v2ray/${camouflagedir}/g" /etc/nginx/conf/conf.d/v2ray.conf
mv /etc/nginx/conf/conf.d/v2ray.conf /etc/nginx/conf/conf.d/${camouflagedir}.conf
mv /data/v2ray.crt /data/${camouflagedir}.crt
mv /data/v2ray.key /data/${camouflagedir}.key
systemctl start nginx

echo -e "${OK} ${GreenBG} v2ray已经伪装成为${camouflagedir} 不再支持升级版本 也无法卸载 ${Font}"
exit 0
}

camouflage_v2ray
