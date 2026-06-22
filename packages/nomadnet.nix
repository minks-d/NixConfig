{
  lib,
  pkgs,
  fetchFromGitHub,
  buildPythonApplication,
  setuptools,
  rns,
  qrcode,
  lxmf,
  urwid,
  ...
}:
buildPythonApplication (finalAttrs: {
  pname = "nomad-net";
  version = "1.2.0";
  pyproject = true;
  
  src = fetchFromGitHub {
    owner = "markqvist";
    repo = "NomadNet";
    tag = finalAttrs.version;
    hash = "sha256-BaRZfqQ9oNpWQc5uQ0PvVduauW3+gTnDljYeBXlmJ9w=";
  };

  build-system = [
    setuptools
  ];
  
  pythonImportsCheck = [ "RNS" ];
  
  propagatedBuildInputs = [
    rns
    qrcode
    lxmf
    urwid
    setuptools
  ];

  meta.license = lib.licenses.unfree;
})
