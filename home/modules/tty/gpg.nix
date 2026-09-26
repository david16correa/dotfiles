{ lib, config, pkgs, ... }:
let
  cfg = config.my.gpg;
in
{
  options.my.gpg = {
    enable = lib.mkEnableOption "enable my gpg configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.gpg = {
      enable = true;

      settings = {
        # Reasonable modern defaults
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";

        default-preference-list =
          "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";

        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";

        display-charset = "utf-8";
        no-comments = true;
        no-emit-version = true;
        keyid-format = "0xlong";

        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = true;

        require-cross-certification = true;
        no-symkey-cache = true;
      };
    };

    services.gpg-agent = {
      enable = true;

      # Keep decrypted key material cached for 30 minutes.
      defaultCacheTtl = 1800;
      maxCacheTtl = 7200;

      # Needed if you want to use GPG keys as SSH keys.
      enableSshSupport = false;

      # Choose the appropriate Pinentry frontend for your desktop.
      pinentry.package = pkgs.pinentry-gnome3;

      enableZshIntegration = true;
    };
  };
}
