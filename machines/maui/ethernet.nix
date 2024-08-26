{lib,...}:
{
  networking.usePredictableInterfaceNames = false;
  
  systemd.network.networks={ 
	  "20-ethernet"={
		  enable = true;
		  name = "eth0";
		  domains = ["lan.faragao.net"];
		  networkConfig = {
			  DHCP="yes";
		  };	
	  };
  };

  networking.enableIPv6=false;
  systemd.network.wait-online.anyInterface = true;
}
