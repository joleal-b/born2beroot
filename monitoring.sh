#!/bin/bash

# ARCHITECTURE
arch=$(uname -a)

# CPU PHYSICAL
cpuf=$(grep "physical id" /proc/cpuinfo | wc -l)

# CPU VIRTUAL
cpuv=$(grep "processor" /proc/cpuinfo | wc -l)

# MEM RAM
total_ram=$(free -m | awk '$1 == "Mem:" {print $2}')
used_ram=$(free -m | awk '$1 == "Mem:" {print $3}')
percent_ram=$(free | awk '$1 == "Mem:" {printf("%.2f"), $3/$2*100}')

# MEM DISK
disk_used=$(df -Bm | grep "/dev/" | grep -v "/boot/" | awk '{used += $3} END {print used}')
disk_total=$(df -Bg | grep "/dev/" | grep -v "/boot/" | awk '{total += $2} END {print total}')
disk_perc=$(df -Bm | grep "/dev/" | grep -v "/boot/" | awk '{used += $3} {total += $2} END {printf("%d"), used/total*100}')

# CPU LOAD
cpul=$(top -ibn1 | tr ',' ' ' | awk '$1 == "%Cpu(s):" {print 100 - $8"%"}')

# LAST BOOT
lb=$(who -b | awk '$1 == "system" {printf("%s %s\n", $3, $4)}')

# LVM USE
lvmu=$(if [ $(lsblk | grep "lvm" | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# TCP CONNEXIONS
tcpc=$(ss -ta | grep ESTAB | wc -l)

# USER LOG
ulog=$(who | cut -d " " -f 1 | sort -u | wc -l)

# NETWORK
ip=$(hostname -I)
mac=$(ip link | grep "link/ether" | awk '{printf $2}')

# SUDO
cmnd=$(journalctl _COMM=sudo | grep COMMAND | wc -l)


wall "  #Architecture: $arch
        #CPU physical: $cpuf
        #vCPU: $cpuv
        #Memory Usage: $used_ram/${total_ram}MB (${percent_ram}%)
        #Disk Usage: $disk_used/${disk_total}Gb (${disk_perc}%)
        #CPU load: $cpul
        #Last boot: $lb
        #LVM use: $lvmu
        #Connections TCP: $tcpc ESTABLISHED
        #User log: $ulog
        #Network: IP $ip ($mac)
        #Sudo: $cmnd cmd"
