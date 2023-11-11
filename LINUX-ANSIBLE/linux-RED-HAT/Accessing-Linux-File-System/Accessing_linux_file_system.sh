Type of device	                    Device naming pattern
SATA/SAS/USB-attached storage	    /dev/sda, /dev/sdb ...
virtio-blk paravirtualized storage  (some virtual machines)	/dev/vda, /dev/vdb ...
NVMe-attached storage (many SSDs)	/dev/nvme0, /dev/nvme1 ...
SD/MMC/eMMC storage (SD cards)      /dev/mmcblk0, /dev/mmcblk1 ...


'Show a disk usage report for the /usr/share directory on host:
'
[root@host ~]# du /usr/share
...output omitted...
176 /usr/share/smartmontools
184 /usr/share/nano
8 /usr/share/cmake/bash-completion
8 /usr/share/cmake
356676  /usr/share
Show a disk usage report in human-readable format for the /usr/share directory on host:

[root@host ~]# du -h /var/log
...output omitted...
176K  /usr/share/smartmontools
184K  /usr/share/nano
8.0K  /usr/share/cmake/bash-completion
8.0K  /usr/share/cmake
369M  /usr/share


