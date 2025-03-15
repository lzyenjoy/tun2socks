#!/bin/bash

echo "==== 停止 tun2socks 透明代理 ===="

# 终止 tun2socks 进程
#sudo pkill tun2socks

# 关闭 TUN 设备
sudo ip link set tun0 down
sudo ip tuntap del mode tun dev tun0

# 删除默认路由
sudo ip route del default

echo "==== 透明代理已关闭 ===="
