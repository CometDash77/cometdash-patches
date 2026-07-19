# Require a completed host build and runnable artifact

An intermediate JAR appearing during `shadowJar` is not a successful Desktop build. Require Gradle exit `0`, the expected `-all.jar`, a `Main-Class`, archive integrity, and CLI help exit `0` before using the host for patch/sign work.

## Evidence

An interrupted `shadowJar` left a small JAR without `Main-Class`; `java -jar --help` failed and the artifact was rejected. A later `clean shadowJar` exited normally and produced the full runnable CLI JAR.

## Implications

Never infer task success from file existence or size. Preserve the incomplete artifact as failure evidence, then rerun the exact source task only after identifying and clearing the underlying build/download state.
