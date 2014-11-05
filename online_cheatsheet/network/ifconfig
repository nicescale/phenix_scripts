# 最常用的网络接口配置工具

# 显示eth0网卡的配置
ifconfig eth0

# 显示所有接口的配置，包括down掉的接口
ifconfig -a

# 激活或禁用接口eth0
ifconfig eth0 {up|down} 

# 为eth0网卡设定IP地址
ifconfig eth0 192.168.1.100 netmask 255.255.255.0

# 添加一个接口别名
ifconfig eth0:0 192.168.1.101 netmask 255.255.255.0

# 设置网卡eth0进入混杂模式
ifconfig eth0 promisc

# 禁用混杂模式
ifconfig eth0 -promisc

# 修改eth0的mac地址
ifconfig eth0 down
ifconfig eth0 hw ether 00:11:22:33:44:99
ifconfig eth0 up
