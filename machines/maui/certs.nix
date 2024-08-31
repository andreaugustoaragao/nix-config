{
  security.acme = {
    acceptTerms = true;
    defaults.email = "adm@faragao.net";
    defaults.renewInterval = "daily";
    defaults.environmentFile = "/data/services/acme/cr.env";
    defaults.dnsProvider = "cloudflare";
    defaults.dnsResolver = "1.1.1.1";
    defaults.validMinDays = 89;
    certs."faragao.net" = {
      extraDomainNames = [
        "*.faragao.net"
      ];
    };
  };
}
