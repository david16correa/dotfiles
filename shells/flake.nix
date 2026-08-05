{
  description = "my dev shells";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs { inherit system; };

    shells = builtins.attrNames(
      pkgs.lib.filterAttrs (entry: type: type == "directory")
      (builtins.readDir ./.)
    );
  in {
    # all shells are automatically imported
    devShells.${system} = builtins.listToAttrs (
      map (shell: {
        name = shell;
        value = import ./${shell} { inherit pkgs; };
      }) shells
    );
  };
}
