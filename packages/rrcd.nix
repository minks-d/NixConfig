{
  buildPythonApplication,
  pkgs,
  fetchFromGitHub,
  lib,
  setuptools,
  cbor2,
  rns,
  tomlkit,
...
}:
buildPythonApplication (finalattrs: {
  pname = "rrcd";
  version = "0.3.2";
  pyproject = true;
  doCheck = true;

  src = fetchFromGitHub {
    owner = "kc1awv";
    repo = "rrcd";
    rev = "f6d7e9d72bf83c70d7a9373ae8c5edaa052a7bf2"; #No official release as of 06-22-26
    hash = "sha256-9IJ2hpatZ5xLh4sbSGInpHEV7vpbhTj8aAlWj+vkTIY=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "RNS" "cbor2" ];
  
  propagatedBuildInputs = [
    cbor2
    rns
    tomlkit
  ];

  nativeCheckInputs = [
    
  ];
  
  meta.license = lib.licensesSpdx.MIT;
})
