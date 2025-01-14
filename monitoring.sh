#! /bin/bash

# The architecture of your operating system:
arch=$(uname -a)

# The number of physical processors:
phcpu=$(cat /proc/cpuinfo | grep "physical id" | wc -l)

# nbr of virtual processorr:
vcpu=$(grep -c "processor" /proc/cpuinfo)

#The current available RAM :
MemoryUsage=$(free --mega | awk 'NR==2' | awk '{printf("%d/%dMB (%.2f%%)", $3, $2, ($3/$2) * 100)}')

# The current available memory and  percentage:
total_disk=$(df -Bg | grep "^/dev" | grep -v "/boot" | awk '{sum += $2} END {print sum"Gb"}')
used_disk=$(df -Bm | grep '^/dev' | grep -v "boot" | awk '{sum += $3} END {print sum}')
rate=$(df -h --total | grep "total" | awk '{printf("(%d%%)", ($3/$2) *100)}')

# The current utilization rate of your processors as a percentage:
CPU_load=$(grep 'cpu ' /proc/stat | awk '{printf("%.2f%%",100-($5*100/($2+$3+$4+$5+$6+$7+$8)))}')

#The date and time of the last reboot:
Last_boot=$(uptime -s)

#LVM use
lvm=$(if [ $(lsblk | grep "lvm" | wc -l) -eq 0 ]; then echo no; else echo yes; fi)

#The number of active connections:
Connections_TCP=$(netstat -an | grep ESTABLISHED | wc -l)

#The number of users using the server:
User_log=$(who | awk '{print $1}' | sort | uniq | wc -l)

#The IPv4 address of your server and its MAC (Media Access Control) address:
ip=$(hostname -I)
MAC=$(ip link | grep "ether" | awk '{print $2}')

#Sudo
n_sudo=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)

wall "
    #Architecture: $arch
    #CPU physical : $phcpu
    #vCPU : $vcpu
    #Memory Usage: $MemoryUsage
    #Disk Usage:  $used_disk/$total_disk $rate
    #CPU load: $CPU_load
    #Last boot: $Last_boot
    #LVM use: $lvm
    #Connections TCP: $Connections_TCP ESTABLISHED
    #User log: $User_log
    #Network: IP $ip ($MAC)
    #Sudo : $n_sudo cmd
"
