#!/system/bin/sh

write /sys/class/thermal/thermal_message/sconfig 0
write /proc/sys/kernel/sched_child_runs_first 1
write /proc/sys/kernel/sched_tunable_scaling 0
write /proc/sys/kernel/sched_schedstats 0
write /proc/sys/net/ipv4/tcp_syncookies 0
write /proc/sys/vm/swappiness 200
write /dev/stune/foreground/schedtune.prefer_idle 1
write /dev/stune/top-app/schedtune.prefer_idle 1
write /dev/stune/top-app/schedtune.boost 30
write /sys/block/mmcblk0/queue/read_ahead_kb 128
write /sys/block/mmcblk0/queue/nr_requests 128
write /sys/block/sdc/queue/iostats 0
write /sys/block/sdc/queue/read_ahead_kb 128
write /sys/block/sdc/queue/nr_requests 128
write /sys/block/dm-0/queue/read_ahead_kb 128
write /sys/block/dm-1/queue/read_ahead_kb 128
write /sys/block/dm-2/queue/read_ahead_kb 128
write /sys/block/dm-3/queue/read_ahead_kb 128
write /sys/block/dm-4/queue/read_ahead_kb 128
write /sys/block/dm-5/queue/read_ahead_kb 128

echo "Kernel configured" >> /dev/kmsg