This guide is made for ArchLinux

Update your system, because kernel must be rebuilt making sure nothing will break
      
      pacman -Syu p7zip

Download the official kernel tree
      
      git clone https://github.com/archlinux/linux /usr/src/linux

Check the current kernel (on the updated system)
      
      uname -r
      
The kernel tree will contain newer versions that are still in building, you must change to the version latest to your system
      
      cd /usr/src/linux
      git checkout vx.x.x-arch1

Patch VFIO and ACS
      
      patch -p1 < vfiopatch.patch

Copy your live kernel config

      cp /proc/config.gz /usr/src/linux
      7z x config.gz
      mv config .config
      make menuconfig

Load the .config in menuconfig, save it as is and exit
    
Compiling the kernel (as root)

      make -j$(nproc) clean && make -j$(nproc) && make -j$(nproc) modules && make -j$(nproc) modules_install

After that the kernel is compiled and now we need to set it into it's directory.

      cp arch/x86/boot/bzImage /boot/vmlinuz-custom

Create a new initramfs

      cp mkinitramfs.conf /etc/

Create a new kernel preset

      cp custom.preset /etc/mkinitcpio.d/

Build initramfs image
      
      mkinitcpio -p custom

Rebuild grub config

      cp grub /etc/default/
      grub-mkconfig -o /boot/grub/grub.cfg

Now install nvidia-dkms package, that should automatically generate and sign your proprietary kernel modules

