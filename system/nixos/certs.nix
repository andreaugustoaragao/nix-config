{
  config,
  pkgs,
  lib,
  server ? false,
  ...
}: {
  #  environment.variables.JAVAX_NET_SSL_TRUSTSTORE =
  #	  let
  #	    caBundle = config.environment.etc."ssl/certs/ca-bundle.crt".source;
  #  	    p11kit = pkgs.p11-kit.overrideAttrs (oldAttrs: {
  #	    	  mesonFlags = [
  #	    	  	(lib.mesonOption "trust_paths" "${caBundle}")
  #	    	  ];
  #            });
  #	    #p12kit = pkgs.p11-kit;
  #  in derivation {
  #	  name = "java-cacerts3";
  #	  builder = pkgs.writeShellScript "java-cacerts-builder" ''
  #	  	  echo ${caBundle}
  #		  ${p11kit.bin}/bin/trust extract --format=java-cacerts --purpose=server-auth $out
  #		  '';
  #          system = "aarch64-linux";
  #	  # system = builtins.currentSystem;
  #  };

  #discourse.nixos.org/t/custom-ssl-certificates-for-jdk/1897/8
}
