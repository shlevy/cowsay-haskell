let
  nixpkgs = fetchTarball
    https://github.com/NixOS/nixpkgs/archive/6f1d4149d54524a1140138f2525ec3a155d2e671.tar.gz;

  config = "x86_64-apple-darwin14";

  pkgs = import nixpkgs {
    crossSystem = {
      inherit config;

      useiOSCross = true;

      isiPhoneSimulator = true;

      arch = "x86_64";

      libc = "libSystem";
    };

    config.packageOverrides = p: {
      darwin = p.darwin // {
        ios-cross = p.darwin.ios-cross.override {
          inherit (p.llvmPackages_38) llvm clang;
        };
      };
    };
  };

  f = { mkDerivation, base, directory, stdenv }:
      mkDerivation {
        pname = "cowsay-haskell";
        version = "0.1.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [ base directory ];
        homepage = "https://github.com/MelleB/cowsay-haskell";
        description = "A cowsay implementation in Haskell";
        license = stdenv.lib.licenses.gpl2;
      };

in {
  cowsay = pkgs.haskell.packages.ghcCross.callPackage f {};

  populate = pkgs.runCommand "populate" {} ''
    mkdir -p $out/bin
    ${pkgs.stdenv.ccCross}/bin/${config}-cc -x c++ -std=c++11 ${./populate-cow.cc} -o $out/bin/populate-cow
  '';
}
