{
services.unbound={
  enable = true;
  settings = {
    server = {
       interface = ["127.0.0.1"];
       port =5335;
       access-control = ["127.0.0.1 allow"]; 

       harden-glue = true;
       harden-dnssec-stripped=true;
       use-caps-for-id=false;
       prefetch=true;
       edns-buffer-size=1232;
       
       hide-identity=true;
       hide-version=true;

    };
  };
};
}
