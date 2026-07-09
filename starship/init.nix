{
  ...
}:
{
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = builtins.readFile ./pure.toml;
  };
}
