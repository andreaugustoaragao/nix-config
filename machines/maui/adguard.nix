{


  networking.firewall.allowedUDPPorts = [53];
  services.adguardhome={
     enable=true;
     host="127.0.0.1";
     port=3002;
     mutableSettings=false;
     settings = {
        schema_version=20;
	dns = {
	  ratelimit=0;
	  bind_hosts = ["0.0.0.0"];
	  bootstrap_dns = [
           "127.0.0.1:5335"
	  ];
	  upstream_dns = [
	    "127.0.0.1:5335"
	  ];
	};
	filtering={
	  protection_enabled=true;
	  filtering_enabled = true;
	  parental_enabled = false;
	  safe_search={
	     enabled = false;
	  };
	};
     };

  };
  
}
