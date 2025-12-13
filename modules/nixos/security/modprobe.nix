{ config, ... }:
{

  config = {
    boot.blacklistedKernelModules = [
      # firewire and thunderbolt
      "firewire-core"
      "firewire_core"
      "firewire-ohci"
      "firewire_ohci"
      "firewire_sbp2"
      "firewire-sbp2"
      "firewire-net"
      "thunderbolt"
      "ohci1394"
      "sbp2"
      "dv1394"
      "raw1394"
      "video1394"
      # Obscure networking protocols
      "dccp" # Datagram Congestion Control Protocol
      "sctp" # Stream Control Transmission Protocol
      "rds" # Reliable Datagram Sockets
      "tipc" # Transparent Inter-Process Communication
      "n-hdlc" # High-level Data Link Control
      "ax25" # Amateur X.25
      "netrom" # NetRom
      "x25" # X.25
      "rose"
      "decnet"
      "econet"
      "af_802154" # IEEE 802.15.4
      "ipx" # Internetwork Packet Exchange
      "appletalk"
      "psnap" # SubnetworkAccess Protocol
      "p8023" # Novell raw IEE 802.3
      "p8022" # IEE 802.3
      "can" # Controller Area Network
      "atm"
      # Various rare filesystems
      "cramfs"
      "freevxfs"
      "jffs2"
      "hfs"
      "hfsplus"
      "udf"
      "squashfs" # compressed read-only file system used for Live CDs
      "cifs" # cmb (Common Internet File System)
      "nfs" # Network File System
      "nfsv3"
      # "nfsv4"
      # "ksmbd"  # SMB3 Kernel Server
      "gfs2" # Global File System 2
      # vivid driver is only useful for testing purposes and has been the
      # cause of privilege escalation vulnerabilities
      "vivid"
      # disable GNSS
      "gnss"
      "gnss-mtk"
      "gnss-serial"
      "gnss-sirf"
      "gnss-usb"
      "gnss-ubx"

      # https://en.wikipedia.org/wiki/Bluetooth#History_of_security_concerns
      "bluetooth"
      "btusb"
      # block loading ath_pci
      "ath_pci"

      # block loading cdrom
      "cdrom"
      "sr_mod"

      # Framebuffer drivers are generally buggy and poorly-supported, and cause
      # suspend failures, kernel panics and general mayhem.  For this reason we
      # never load them automatically.
      "aty128fb"
      "atyfb"
      "radeonfb"
      "cirrusfb"
      "cyber2000fb"
      "cyblafb"
      "gx1fb"
      "hgafb"
      "i810fb"
      "intelfb"
      "kyrofb"
      "lxfb"
      "matroxfb_base"
      "neofb"
      "nvidiafb"
      "pm2fb"
      "rivafb"
      "s1d13xxxfb"
      "savagefb"
      "sisfb"
      "sstfb"
      "tdfxfb"
      "tridentfb"
      "vesafb"
      "vfb"
      "viafb"
      "vt8623fb"
      "udlfb"
    ];
  };

}
