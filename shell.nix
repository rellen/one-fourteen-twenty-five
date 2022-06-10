{ pkgs ? import <nixpkgs> { }, nixpkgs ? <nixpkgs> }:
let
   erlang = pkgs.beam.interpreters.erlangR25;

   buildElixir = pkgs.callPackage (import "${nixpkgs}/pkgs/development/interpreters/elixir/generic-builder.nix") { erlang = erlang; };
   elixir = buildElixir {
      version = "main";
      rev = "888eba76ee0d0976ef959d9c0c33477dfec0518c";
      minimumOTPVersion = "25";
    }; 

    inherit (pkgs.lib) optional optionals;

in pkgs.mkShell rec {
  name = "elixir-1.14_env";
  buildInputs = with pkgs; [
    rebar
    rebar3
    erlang
    elixir
   ] ++ optional stdenv.isLinux inotify-tools ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ CoreFoundation CoreServices ]);
}
