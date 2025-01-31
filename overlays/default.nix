{ inputs, outputs }:
{
  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = (
    final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.system;
        config.allowUnfree = true;
      };
    }
  );

  ghostty-overlay = (final: prev: { ghostty = final.callPackage ../pkgs/ghostty.nix { }; });
}
