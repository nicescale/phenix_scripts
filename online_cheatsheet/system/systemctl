# 列出所有启用的服务, 类似过去chkconfig --list
systemctl list-units

# 查看服务状态，类似过去service foo status
systemctl status foo.service

# 启动一个服务, 类似service foo start
systemctl start foo.service

# 重启一个服务，类似service foo restart
systemctl restart foo.service

# 停止一个服务，类似service foo stop
systemctl stop foo.service

# 重新载入一个服务，往往是配置修改的情况下
systemctl reload foo.service

# 启用一个服务，类似chkconfig foo on
systemctl enable foo.service

# 禁用一个服务，类似chkconfig foo off
systemctl disable foo.service

# 列出foo所依赖的服务
systemctl list-dependencies foo.service 

# 列出类型是target的systemd单元(units)
systemctl list-units --type=target

# 和过去的修改runlevel比较类似
systemctl isolate foo.target

# 激活foo.target
systemctl enable foo.target
