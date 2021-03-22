#!/sbin/sh

### Recovery service bootstrap for better Treble support
# Purpose:
#  - Prevent recovery from being restarted when it's killed (equivalent to a one-shot service)
#  - symlink to the correct fstab depending on Treble partition state

# vendor_b partition info
vendor_b_partnum=51
vendor_b_partstart_system=12539904
vendor_b_partend_system=13768703
vendor_b_partstart_userdata=15778834
vendor_b_partend_userdata=17007633
vendor_b_blockdev=/dev/block/mmcblk0p51

# vendor_a partition info
vendor_a_partnum=50
vendor_a_partstart_system=6248448
vendor_a_partend_system=7477247
vendor_a_partstart_userdata=14550032
vendor_a_partend_userdata=15778832
vendor_a_blockdev=/dev/block/mmcblk0p50

# check mount situation and use appropriate fstab
rm /etc/twrp.fstab
rm /etc/recovery.fstab

if [ -b "$vendor_a_blockdev" -a -b "$vendor_b_blockdev" ]; then
	ln -sn /etc/twrp.fstab.treble /etc/twrp.fstab
        ln -sn /etc/recovery.fstab.treble  /etc/recovery.fstab
else
	ln -sn /etc/twrp.fstab.stock /etc/twrp.fstab
        ln -sn /etc/recovery.fstab.stock  /etc/recovery.fstab
fi;

# start recovery
/sbin/recovery &

# idle around
while kill -0 `pidof recovery`; do sleep 1; done

# stop self
stop recovery
