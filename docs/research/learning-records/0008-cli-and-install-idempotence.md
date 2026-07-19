# Keep CLI recovery idempotent after side effects

Process launchers can split option values containing spaces even when the source array looks correct. Prefer an unambiguous index only after independently proving bundle cardinality; after an install reports success, a later harness assertion failure must be recovered by read-only state queries, not by repeating the install.

## Evidence

The first Desktop attempt split the no-op Patch name and failed before side effects. The corrected unique-index attempt patched and signed successfully. ADB then installed once, but an array `-notmatch` check raised a false failure; package-manager queries proved the installed version without replace, uninstall, or a second install.

## Implications

Separate command execution from postcondition evaluation, reduce arrays with an explicit boolean, and record whether a side effect already occurred before deciding how to recover.
