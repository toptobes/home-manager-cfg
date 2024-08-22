{ stdenv
, lib
, fetchurl
}:

stdenv.mkDerivation (self: {
  pname = "gh-debug-cli";
  version = "0.1.1-beta";

  src = fetchurl {
    name = "gh-debug-cli";
    url = "https://github.com/copilot-extensions/gh-debug-cli/releases/download/v${self.version}/linux-amd64";
    hash = "sha256-28BHjIfZH88ng0A8fArp/OgSTk2Nd8fap2tXQfbOzdk=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -m755 -D $src $out/bin/gh-debug-cli

    runHook postInstall
  '';
})
