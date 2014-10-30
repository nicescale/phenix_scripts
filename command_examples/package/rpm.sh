# Example1: To list installed softwares execute below command

rpm -qa
yum list installed

yum info <package-name>

# 添加EPEL软件包源
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
# To install a package:
rpm -ivh <rpm>

# To remove a package:
rpm -e <package>

# To find what package installs a file:
rpm -qf </path/to/file>

# To find what files are installed by a package:
rpm -qpl <rpm>

# To list all installed packages:
rpm -qa
