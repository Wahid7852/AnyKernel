# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=NoVA by Abdul7852
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

isTimRom() {
  build_prop="/system/build.prop"
  version_prop="ro.crdroid.build.version"

  if grep -q "$version_prop" "$build_prop" && grep -q "timjosten" "$build_prop"; then
    return 0
  else
    return 1
  fi
}

isDerp() {
  build_prop="/system/build.prop"
  version_prop="ro.derp.fingerprint"

  if grep -q "$version_prop" "$build_prop" && grep -q "DerpFest" "$build_prop"; then
    return 0
  else
    return 1
  fi
}

# Initialize block
block=/dev/block/bootdevice/by-name/boot;

if isTimRom; then
    block=boot;
    is_slot_device=auto;
    ramdisk_compression=none;

    . tools/ak3-core.sh;

    ui_print " » Custom ROM recognition: Tim's Signature ";
    ui_print " » Initiating vibration fix deployment "
    ui_print " » Executing NoVA flash....";

    split_boot;
    patch_cmdline initcall_blacklist initcall_blacklist=
    flash_boot;

elif isDerp; then

    block=/dev/block/by-name/boot;
    is_slot_device=0;
    ramdisk_compression=auto;
    no_block_display=true;

    . tools/ak3-core.sh;

    mount -o rw,remount -t auto /vendor >/dev/null;
    restore_file /vendor/etc/init/hw/init.target.rc;

    rm -rf $ramdisk/overlay;
    rm -rf $ramdisk/overlay.d;

    ui_print " » Custom ROM recognition: DerpFest's detected ";
    ui_print " » Executing NoVA flash....";

    dump_boot;
    write_boot;

else

    is_slot_device=0;
    ramdisk_compression=auto;
    no_block_display=true;

    . tools/ak3-core.sh;

    mount -o rw,remount -t auto /vendor >/dev/null;
    restore_file /vendor/etc/init/hw/init.target.rc;

    rm -rf $ramdisk/overlay;
    rm -rf $ramdisk/overlay.d;

    ui_print " » Executing NoVA flash....";

    dump_boot;
    write_boot;

fi
