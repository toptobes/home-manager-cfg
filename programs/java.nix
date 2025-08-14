{ pkgs, ... }:

{
  programs.java = {
    enable = true;
    package =             (pkgs.graalvmPackages.graalvm-ce.overrideDerivation (oldAttrs: {

              postInstall =
                let
                  darwinArgs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
                    "-ENIX_BINTOOLS"
                    "-ENIX_CC"
                    "-ENIX_CFLAGS_COMPILE"
                    "-ENIX_LDFLAGS"
                    "-ENIX_CC_WRAPPER_TARGET_HOST_${pkgs.stdenv.cc.suffixSalt}"
                    "-ENIX_BINTOOLS_WRAPPER_TARGET_HOST_${pkgs.stdenv.cc.suffixSalt}"
                  ];

                  darwinFlags = (map (f: "--add-flags '${f}'") darwinArgs);
                in

                pkgs.lib.replaceStrings [ "/bin/native-image" ] [
                  "/bin/native-image ${toString (darwinFlags)}"
                ] oldAttrs.postInstall;
            }));
  };
}
