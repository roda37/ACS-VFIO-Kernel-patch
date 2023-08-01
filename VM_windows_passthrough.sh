#!/bin/bash
STORAGE="./windows10.qcow2"
ISO="./Win10_22H2_English_x64.iso"
OVMF="/usr/share/edk2/x64/OVMF_CODE.fd"
CPU_SOCKET="1"
CPU_CORES="2"
CPU_THREAD="2"
RAM="4096"
args=(
	-enable-kvm -m "$RAM" -cpu SandyBridge-v2,kvm=on
	-machine q35
	-smp "$CPU_THREAD",cores="$CPU_CORES",sockets="$CPU_SOCKET"
	-drive if=pflash,format=raw,readonly=on,file="$OVMF"
	-usb -device usb-kbd -device usb-tablet -device usb-mouse
	-device virtio-mouse-pci,evdev=/dev/input/by-id/
	-device virtio-keyboard-pci,evdev=/dev/input/by-id/,grab=all,repeat=on,grabToggle=ctrl-ctrl
	-device usb-kbd
	-drive format=raw,file="$STORAGE"
	#-drive file="$ISO",media=cdrom
	-netdev user,id=net0 -device e1000,netdev=net0
	-device vfio-pci,host=27:00.0,x-vga=on -vga none
	-device vfio-pci,host=27:00.1
	-nographic # pass display to console (no virtual output)
	-monitor none
	#-vga qxl
)
qemu-system-x86_64 "${args[@]}"

# XML for virt-manager, these inputs must be modified with the keyboard event and mouse event located in /dev/input/by-id
#<input type='evdev'>
	#<source dev='/dev/input/by-id/'/>
#</input>
#<input type='evdev'>
	#<source dev='/dev/input/by-id/' grab='all' repeat='on' grabToggle='ctrl-ctrl'/>
#</input>
