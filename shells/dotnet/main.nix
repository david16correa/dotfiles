{ pkgs }:

pkgs.mkShell{
  name = "dotnet";
  buildInputs = with pkgs; [
    dotnetCorePackages.dotnet_10.sdk
  ];
  # shellHook = ''
  #     exec ${pkgs.zsh}/bin/zsh
  # '';
}
