# update-rc.d是Debian系Linux发行版管理SysV的工具，对应RedHat的chkconfig

# 将某个服务添加到自动启动里
update-rc.d apache2 defaults

# 禁止服务自动启动
update-rc.d -f apache2 remove
