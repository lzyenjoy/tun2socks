#!/bin/bash

# 退出时显示错误
set -e

echo "==== 检查 tun2socks 是否已安装 ===="
if command -v tun2socks &> /dev/null; then
    echo "✅ tun2socks 已安装，跳过下载步骤。"
else
    echo "🚀 未找到 tun2socks，开始下载安装。"

    # 确定 CPU 架构
    ARCH=$(uname -m)
    [[ $ARCH == "x86_64" ]] && ARCH="amd64"
    [[ $ARCH == "aarch64" ]] && ARCH="arm64"

    # 下载 tun2socks
    wget -O tun2socks-linux-${ARCH}.zip "https://github.com/xjasonlyu/tun2socks/releases/download/v2.5.2/tun2socks-linux-${ARCH}.zip"
    
    # 安装 unzip（如果没有的话）
    sudo apt update && sudo apt install unzip -y
    
    # 解压文件
    unzip tun2socks-linux-${ARCH}.zip
    chmod +x tun2socks-linux-${ARCH}
    mv tun2socks-linux-${ARCH} tun2socks
    
    # 移动到 /usr/local/bin 并赋予权限
    chmod +x tun2socks
    sudo mv tun2socks /usr/local/bin/
fi

echo "==== tun2socks 安装完成 ===="

echo "==== 检查 tun0 设备是否已存在 ===="
if ip link show tun0 &> /dev/null; then
    echo "✅ tun0 设备已存在，跳过创建步骤。"
else
    echo "🚀 创建 tun0 设备..."
    sudo ip tuntap add mode tun dev tun0
    sudo ip addr add 198.18.0.1/15 dev tun0
    sudo ip link set dev tun0 up
fi

echo "==== 配置路由和 DNS ===="
sudo ip route del default > /dev/null 2>&1 &
sudo ip route add default dev tun0
sudo ip route add default via 198.18.0.1 dev tun0 metric 1
sudo ip route add default via 192.168.0.1 dev enp2s0 metric 10


echo "==== 启动 tun2socks ===="
#nohup sudo tun2socks -device tun0 -proxy socks://127.0.0.1:10808 > /dev/null 2>&1 &
#sudo tun2socks -device tun0 -proxy socks5://192.168.0.105:10808 > /dev/null 2>&1 &




#sudo sh -c 'echo "nameserver 8.8.8.8" > /etc/resolv.conf'

#echo "✅ 透明代理已启动，测试 IP 变更..."
#curl ip.sb
