{
	services.nginx={
		enable=true; 

		virtualHosts={
		        "faragao.net"={
			 serverAliases = ["*.faragao.net"];
			 locations."/.well-known/acme-challenge" = {
			  root="/var/lib/acme/.challenges";
			  }; 
			  locations."/"={
			      return = "301 https://$host$request_uri";
			  };
			};

			"adguard.faragao.net"={
				forceSSL = true;
				useACMEHost = "faragao.net";

				locations."/" = {
					extraConfig = ''
						proxy_pass http://127.0.0.1:3002;
					proxy_set_header Host $host;
					proxy_set_header X-Real-IP $remote_addr;
					proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
					allow 192.168.0.0/24; 
					deny all;
					'';
				};
			};
		};
	};

	security.acme.acceptTerms=true;
	security.acme.certs."faragao.net" = {
	   webroot="/var/lib/acme/.challenges";
	   email="admin@faragao.net";
	   group="nginx";
	   server	="https://acme-staging-v02.api.letsencrypt.org/directory";
	};

	users.users.nginx.extraGroups=["acme"];

}
