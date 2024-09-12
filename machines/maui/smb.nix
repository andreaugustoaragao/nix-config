{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = FARAGAO
      server string = maui
      netbios name = maui
      security = user
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.10. 192.168.20 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      timemachine = {
        path = "/data/timemachine";
        validUsers = ["backup"];
        public = "no";
        writeable = "yes";
        guestOk = false;
        comment = "Time machine backup for all macs";
        #"force user" = "username";
        "fruit:aapl" = "yes";
        "fruit:time machine" = "yes";
        "fruit:model" = "MacSamba";
        "fruit:time machine max size" = "3T";
        "vfs objects" = "catia fruit streams_xattr";
      };
    };
  };
  services.avahi.enable = true;
  services.avahi.openFirewall = true;
  services.avahi.publish.enable = true;
  services.avahi.domainName = "faragao.net";
}
