# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Nova Kernel by Abdul7852
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=1
device.name1=begonia
device.name2=begoniain
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;
no_block_display=true;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

ui_print " » Credits to @PiotrBurdzinski for anykernel.sh and other files » "

## begin vendor changes
mount -o rw,remount -t auto /vendor >/dev/null;

# Make a backup of init.target.rc
restore_file /vendor/etc/init/hw/init.target.rc;

# Clean up other kernels' ramdisk overlay files
rm -rf $ramdisk/overlay;
rm -rf $ramdisk/overlay.d;

ui_print " » Configuring kernel...";

# begin ramdisk changes
if [ -d $ramdisk/.backup ]; then
	mv /tmp/anykernel/overlay.d $ramdisk/overlay.d
	chmod -R 750 $ramdisk/overlay.d/*
	chown -R root:root $ramdisk/overlay.d/*
	chmod -R 755 $ramdisk/overlay.d/sbin/init.nova.sh
	chown -R root:root $ramdisk/overlay.d/sbin/init.nova.sh
fi;

. overlay.d/sbin/init.nova.sh;

ui_print " » Configured";


## AnyKernel install
dump_boot;

if [ -f $split_img/ramdisk.cpio ]; then
  ui_print " » Ramdisk found";
  unpack_ramdisk;
  repack_ramdisk;
fi;

# Clean up other kernels' ramdisk overlay files
rm -rf $ramdisk/overlay;
rm -rf $ramdisk/overlay.d;

if mountpoint -q /data; then
  # Optimize F2FS extension list (@arter97)
  ui_print " "
  ui_print " » Optimizing F2FS extension list"
  ui_print " "
  for list_path in $(find /sys/fs/f2fs* -name extension_list); do
    hash="$(md5sum $list_path | sed 's/extenstion/extension/g' | cut -d' ' -f1)"

    # Skip update if our list is already active
    if [[ $hash == "43df40d20dcb96aa7e8af0e3d557d086" ]]; then
      echo "Extension list up-to-date: $list_path"
      continue
    fi

    echo "Updating extension list: $list_path"

    echo "Clearing extension list"

    hot_count="$(grep -n 'hot file extens' $list_path | cut -d':' -f1)"
    list_len="$(cat $list_path | wc -l)"
    cold_count="$((list_len - hot_count))"

    cold_list="$(head -n$((hot_count - 1)) $list_path | grep -v ':')"
    hot_list="$(tail -n$cold_count $list_path)"

    for ext in $cold_list; do
      [ ! -z $ext ] && echo "[c]!$ext" > $list_path
    done

    for ext in $hot_list; do
      [ ! -z $ext ] && echo "[h]!$ext" > $list_path
    done

    echo "Writing new extension list"

    for ext in $(cat $home/f2fs-cold.list | grep -v '#'); do
      [ ! -z $ext ] && echo "[c]$ext" > $list_path
    done

    for ext in $(cat $home/f2fs-hot.list); do
      [ ! -z $ext ] && echo "[h]$ext" > $list_path
    done
  done
fi

## AnyKernel install
dump_boot;

write_boot;
## end install