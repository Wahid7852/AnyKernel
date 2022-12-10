# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=NOVA by Abdul7852
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

## begin vendor changes
mount -o rw,remount -t auto /vendor >/dev/null;

# Make a backup of init.target.rc
restore_file /vendor/etc/init/hw/init.target.rc;

# Clean up other kernels' ramdisk overlay files
rm -rf $ramdisk/overlay;
rm -rf $ramdisk/overlay.d;

ui_print " » Flashing....";

## AnyKernel install
dump_boot;

write_boot;
## end install
