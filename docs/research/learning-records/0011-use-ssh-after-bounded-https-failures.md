# Use SSH after bounded GitHub HTTPS failures

## Observation

The Phase 4 entry push failed three times through HTTPS connection reset or timeout even while a GitHub web request returned success. Three later HTTPS clones failed the same way. Existing SSH authentication succeeded; one-time SSH push and clone URLs completed without changing the repository's configured remote.

## Reusable action

After bounded HTTPS failures, verify GitHub SSH authentication with batch mode and use an explicit SSH repository URL for the individual transfer. Do not change the global Git configuration or reinterpret a transport failure as missing upstream content. Fetch the pushed ref back into the expected remote-tracking ref before relying on local branch status.
