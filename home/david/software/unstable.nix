{ config, lib, unstable, inputs, ... }:
{
  ########################################
  # home packages
  ########################################

  home.packages = with unstable; [
    vicinae
    yazi
    noctalia-shell
  ];

  ########################################
  # extra session variables
  ########################################

  systemd.user.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3"; # https://docs.noctalia.dev/v4/getting-started/faq/#why-are-some-of-my-app-icons-missing
  };

}
