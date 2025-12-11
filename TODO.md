### Things on my list to follow up on 
- Live Preview Markdown in emacs
- Lynis or similar biweekly email updates
- Auto Auditing as well. https://saylesss88.github.io/nix/hardening_NixOS.html#auditd
- https://saylesss88.github.io/nix/hardening_NixOS.html#openssh-server
- Evaluate disk encryption though mdadm raid
- Impermanance
- nix-shell -p grype sbomnix --run '
  sbomnix /run/current-system --csv /dev/null --spdx /dev/null --cdx sbom.cdx.json;
  grype sbom.cdx.json
' <- Automate this as well, or similar
