# Phase 1 Morphe 生态独立审查

## 审查身份与边界

- Reviewer：独立 Phase 1 Morphe Ecosystem Reviewer。Reviewer 未接收执行 Agent、研究 Agent 的推理记录，也未以报告正文作为事实证明。
- 审查时间：`2026-07-19T10:52:52+08:00`（`Asia/Hong_Kong`）。
- Phase 1 base/authorization commit：`0e2dd4394ec853278a74f7456f761bb8cad16ea1`。
- Candidate：`003ce9e85502d3393884cc4e328147db45b8ed53`；审查开始和写报告前均确认 `HEAD` 等于 candidate、分支为 `dev`、工作树为空。
- 边界：未进入 Phase 2，未读取、检查、反编译或复制本地 APK，未编写 Patch 或产品代码，未修改 candidate report、evidence ledger 或其他权威文档。

## 固定输入与一手证据方法

本地输入已完整阅读：`AGENTS.md`、`CONTEXT-MAP.md`、`docs/contexts/patch-source/CONTEXT.md`、`docs/contexts/enhanced-voice-over-translation/CONTEXT.md`、`docs/specs/project-charter.md`、`docs/specs/agent-learning-program.md`、`docs/superpowers/plans/2026-07-18-morphe-phase-0-1.md` Tasks 6-9、`docs/research/morphe-ecosystem-architecture.md`、`docs/research/evidence-ledger.md`、`docs/runbooks/repository-workflow.md`、`docs/testing/documentation-gate.md`、`docs/testing/release-gate.md`、`docs/runbooks/upstream-documentation.md`、`docs/upstream/manifest.json`、`tools/sync_upstream_docs.ps1` 与 `tools/check_documentation.ps1`。

Reviewer 通过已认证的 `gh api` 重新读取 GitHub REST API 和 exact frozen commits；没有 clone、vendor 或 checkout 上游源码。原始查询覆盖：

- 组织与清单：`GET /orgs/MorpheApp`、`GET /orgs/MorpheApp/repos?per_page=100&type=all`，以及每个 repository default branch 的 commit API。
- build/publication：template `settings.gradle.kts`、`patches/build.gradle.kts`、`PatchListGenerator.kt`、`.github/workflows/release.yml`、`.releaserc`；Gradle plugin `SettingsPlugin.kt`、`ExtensionPlugin.kt`、`PatchesPlugin.kt`；official patches build/release config；`morphe-patches-library` generator；`changelog` `index.js` 与 `lib/prepare.js`。
- Android Manager：`PatchBundleRepository.kt`、`RemotePatchBundle.kt`、`PatchBundleSource.kt`、`PatchBundle.kt`、`PatchBundleInfo.kt`、`PatchSelectionRepository.kt`、`PatcherWorker.kt`、runtime、`Session.kt`、`KeystoreManager.kt` 和 installer sources。
- Desktop/install：`RemotePatchSourceFactory.kt`、`GitHubPatchSource.kt`、`MultiSourceLoader.kt`、`PatchBundleLoader.kt`、`PatchSelectionViewModel.kt`、`PatchEngine.kt`、`InstallCommand.kt`、`morphe-library` installer/command sources 和 `jadb` build metadata。
- Patcher/support：`Patch.kt`、`Compatibility.kt`、`Patcher.kt`、contexts、`PatcherResult.kt`、`ApkUtils.kt`、`ArsclibResourceCoder.kt`、build/version catalog，以及 frozen `ARSCLib`、`smali`、`Apktool`、`multidexlib2` 配置。
- Excluded challenge：每个 cited frozen path，并额外读取 `morphe-website/public/add-source.html`、`public/js/add-source.js`、Manager `MainActivity.kt`/manifest 的 consumer edge。

## Repository 状态与 diff 范围

```text
git rev-parse HEAD
003ce9e85502d3393884cc4e328147db45b8ed53

git rev-parse 003ce9e
003ce9e85502d3393884cc4e328147db45b8ed53

git merge-base 0e2dd4394ec853278a74f7456f761bb8cad16ea1 003ce9e85502d3393884cc4e328147db45b8ed53
0e2dd4394ec853278a74f7456f761bb8cad16ea1

git diff --name-status 0e2dd4394ec853278a74f7456f761bb8cad16ea1 003ce9e85502d3393884cc4e328147db45b8ed53
M docs/research/evidence-ledger.md
A docs/research/morphe-ecosystem-architecture.md

git diff --stat 0e2dd4394ec853278a74f7456f761bb8cad16ea1 003ce9e85502d3393884cc4e328147db45b8ed53
2 files changed, 264 insertions(+)
```

该 diff 没有 Patch/product/Phase 2 文件，也没有 APK 内容、反编译输出或其他禁止资产。

## 清单与分类复核

认证 API 返回 `public_repos=21`；repository listing 为 21 个 unique、21 个 unarchived，全部 default-branch HEAD 为 40 位 SHA。fork、default branch 和 HEAD 均与 candidate 一致。

| Repository | Fork | Default | Frozen HEAD | Candidate | Reviewer status |
| --- | :---: | --- | --- | --- | --- |
| `.github` | No | `main` | `245e6ad66b51407879ae5a7922808f69cf41a443` | Excluded | Verified |
| `Apktool` | Yes | `main` | `a3f22c3ab59860ee30312da8869e818648c24d38` | Excluded | Verified |
| `ARSCLib` | Yes | `main` | `d003b5ff1ca91fb8c5105619cf1108b450387061` | Supporting | **Rejected: MORPHE-P1-001** |
| `changelog` | Yes | `bundle` | `caa1e931730f097bb6c4dee636b01c2c24ccd72d` | Direct | Verified |
| `ejs` | Yes | `main` | `a2f61b4f378938cf10ba9799d1881dfa67ca2c4d` | Excluded | Verified |
| `jadb` | No | `master` | `6fdaa5bec8369487e6c9d0460f02ac9970709d34` | Supporting | Verified |
| `MicroG-RE` | Yes | `main` | `d8df10ab687a1c1ca05221634cfa46bad262023a` | Excluded | Verified |
| `morphe-branding` | No | `main` | `92e858695fa19fa04e9fcf4e0bddf0dbb2a7db50` | Excluded | Verified |
| `morphe-desktop` | No | `main` | `2f5ce39adc26d4b3e7debe44445eddcaf887bffa` | Direct | Verified |
| `morphe-documentation` | No | `main` | `37b5eeb9c690ea169937fc2bac197bdcdb269014` | Excluded | Verified |
| `morphe-library` | No | `main` | `a5b1fb512306d497cad8a13c0399a5fb28553522` | Direct | Verified |
| `morphe-manager` | No | `main` | `a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948` | Direct | Verified, citation gap MORPHE-P1-004 |
| `morphe-patcher` | No | `main` | `b69536fd33b69a1d1b2643068941f1052cf51708` | Direct | Verified |
| `morphe-patches` | No | `main` | `e12088c89942f5d637a824ce81643a28b86fb851` | Direct | Verified |
| `morphe-patches-gradle-plugin` | No | `main` | `52be641ed3b965a20c33bd43e0cbe9efd308bc64` | Direct | Verified |
| `morphe-patches-library` | No | `main` | `9e555a2273533ef13e51db70a55d3fd544752756` | Supporting | Verified |
| `morphe-patches-template` | No | `main` | `93ade63a00a4b5954c63af78dbd9d8e6ec4f95fe` | Direct | Verified |
| `morphe-website` | No | `main` | `57a6d8cb9541101d09fc73fef8c1e0c3304e7dc7` | Excluded | **Rejected: MORPHE-P1-002** |
| `multidexlib2` | No | `main` | `41cccc644cf1804362f7aa2fae96a6ffe67ffd22` | Excluded | Verified |
| `nowinandroid` | Yes | `main` | `ef6d320c013b0155a8a945a574e1a57ee92f1276` | Excluded | Verified |
| `smali` | Yes | `master` | `b6365a84f40c8355af14004dcf7b8324ee050b9f` | Supporting | Verified |

`8 Direct + 4 Supporting + 9 Excluded = 21` 的算术成立，但两项分类证据不成立，因此该 population partition 未通过。特别复核结论：

- `changelog` 生成 Manager/Desktop runtime discovery 所消费的 `patches-bundle.json`，拥有 publication metadata boundary；`morphe-patches-library` 的 `patches-list.json` generator 在 frozen Manager/Desktop 中没有 runtime consumer，故两者分别为 Direct 与 Supporting 是合理的。
- `morphe-library` 由 Desktop `InstallCommand` 实际调用并返回 install result；`jadb` 是其 transport，因此 Direct/Supporting 边界成立。
- `smali` 的 coordinate 是 `com.github.MorpheApp.smali:smali`；`Apktool` 和 `multidexlib2` 没有 frozen Direct reverse edge，三项分类成立。
- `ARSCLib` 和 `morphe-website` 见 Blocking findings。

## 生命周期复核

| Area | Independent trace | Assessment |
| --- | --- | --- |
| Build | `SettingsPlugin` includes projects；`ExtensionPlugin` 将 release DEX 同步为 `.mpe`；`PatchesPlugin` 组装 `.mpp`、manifest、runtime-provided exclusions，并由 D8 添加 Android DEX。 | Verified |
| Publication | `changelog.prepare` 写 `patches-bundle.json`；Gradle build/generator 生成 `.mpp`/`patches-list.json`；Git plugin commit metadata；GitHub plugin 上传 `.mpp`。 | **Blocked by contradictory graph ordering, MORPHE-P1-003** |
| Android Manager | GitHub/GitLab/direct JSON normalization；metadata fetch；`download_url` 写入 read-only `patches.jar`；DEX validation/load；package/version compatibility 和 persisted selection；Runtime -> Session -> Patcher；copy -> `applyTo` -> sign -> output。 | Behavior verified; installer evidence row incomplete, MORPHE-P1-004 |
| Desktop | provider factory -> GitHub/GitLab fetch；`.mpp` download；JAR loader；GUI/CLI selection/filter；Patcher -> `applyTo` -> sign -> final output；`InstallCommand` -> `morphe-library` -> `jadb`。 | Verified |
| Patcher | JAR/DEX loader only accepts named Patch objects from public static fields or public static zero-arg methods；host owns compatibility selection；`plusAssign` closes dependencies；decode -> dependency-first execute -> reverse finalize -> `PatcherResult`；`ApkUtils.applyTo` deletes/merges resources, writes DEX and realigns。 | Verified |
| Supporting dependencies | `smali` provides DEX model/assembly and `jadb` provides ADB transport；Patcher calls ARSCLib APIs, but the dependency resolves `REAndroid`, not the MorpheApp fork。 | Blocked for inventory edge |

Edge ledger rows include producer/input/consumer/output. The artifact table exposes Artifact/Producer/Consumer/Semantics but does not explicitly record producer input and produced output per row; see MORPHE-P1-005. Every one of 132 MorpheApp URL occurrences (75 unique URLs) uses an exact 40-character commit, and all 75 unique URLs resolved successfully. URL immutability therefore passes; claim support does not fully pass because MORPHE-P1-001 and MORPHE-P1-004 cite paths that do not prove the stated repository/installer edge.

## Findings

| ID | Severity | Finding | Evidence path:line | Status |
| --- | --- | --- | --- | --- |
| `MORPHE-P1-001` | Blocking | `MorpheApp/ARSCLib` is classified Supporting without a frozen dependency/caller edge to that fork. Patcher declares `com.github.REAndroid:arsclib`, while `ArsclibResourceCoder` proves only API use. The ledger also records the MorpheApp fork as verified. Inventory counts and the verified ledger statement are therefore unsupported. | `docs/research/morphe-ecosystem-architecture.md:18`, `:24`, `:50`; `docs/research/evidence-ledger.md:47`, `:56`; `MorpheApp/morphe-patcher@b69536fd33b69a1d1b2643068941f1052cf51708:gradle/libs.versions.toml:20`; `:build.gradle.kts:74`; `MorpheApp/ARSCLib@d003b5ff1ca91fb8c5105619cf1108b450387061:build.gradle.kts:5` | Open; do not fix in review |
| `MORPHE-P1-002` | Blocking | `morphe-website` is excluded after inspecting only deploy/package hosting, but frozen source owns an add-Source handoff: it fetches a Source blocklist, builds the `morphe.software/add-source` intent, and Manager consumes that exact deep link into `pendingDeepLinkSource`. This is a real source/caller edge omitted from the report. The report must evaluate the boundary and reclassify it as Direct or Supporting under its declared rules; Excluded is not supported. | `docs/research/morphe-ecosystem-architecture.md:39`, `:48`, `:50`; `MorpheApp/morphe-website@57a6d8cb9541101d09fc73fef8c1e0c3304e7dc7:public/js/add-source.js:6`, `:73`, `:143`; `MorpheApp/morphe-manager@a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948:app/src/main/java/app/morphe/manager/MainActivity.kt:126`, `:158`; `:app/src/main/AndroidManifest.xml:115` | Open; do not fix in review |
| `MORPHE-P1-003` | Blocking | The lifecycle graph orders `.mpp -> patches-list.json -> semantic-release/changelog -> patches-bundle.json/GitHub Release`, but the report's own source-backed prose and `.releaserc` put `@MorpheApp/changelog` preparation before Gradle generator/version replacement, metadata commit and GitHub asset publication. The graph also falsely makes `patches-list.json` an input to changelog. Required build/publication artifact ordering is internally contradictory. | `docs/research/morphe-ecosystem-architecture.md:76`, `:77`, `:78`, `:79`, `:157`; `MorpheApp/morphe-patches-template@93ade63a00a4b5954c63af78dbd9d8e6ec4f95fe:.releaserc:36`, `:44`, `:46`, `:54`, `:67`; `MorpheApp/changelog@caa1e931730f097bb6c4dee636b01c2c24ccd72d:index.js:18` | Open; do not fix in review |
| `MORPHE-P1-004` | Blocking | Manager install ownership is true in frozen source, but the inventory/matrix/artifact row cites `PatcherWorker` or `SessionInstaller` for system/Shizuku/root/external orchestration. `PatcherWorker` stops at signed output; `SessionInstaller` covers system/Shizuku, not root/external. The artifact row therefore lacks exact supporting paths for all claimed outputs, violating the per-row evidence requirement. | `docs/research/morphe-ecosystem-architecture.md:33`, `:60`, `:113`, `:173`; `MorpheApp/morphe-manager@a2c3d31bd7ab42e6bc4b9dd528ed856fc72fb948:app/src/main/java/app/morphe/manager/patcher/worker/PatcherWorker.kt:337`, `:374`; `:app/src/main/java/app/morphe/manager/domain/installer/SessionInstaller.kt:37`; `:app/src/main/java/app/morphe/manager/domain/installer/InstallerManager.kt:223`; `:app/src/main/java/app/morphe/manager/ui/viewmodel/InstallViewModel.kt:785` | Open; do not fix in review |
| `MORPHE-P1-005` | Blocking | The artifact table does not record the required producer input and produced output for each row. Naming the resulting Artifact plus Producer/Consumer/Semantics is not equivalent to the required four-field provenance, so the artifact-row completeness check cannot pass even where the linked path is valid. | `docs/research/morphe-ecosystem-architecture.md:101`, `:103`, `:105`, `:113`; compare the explicit edge schema at `:115`, `:117` | Open; do not fix in review |

## Failed evidence calls 与 Unverified 复核

- 报告保留的 8 个 malformed recursive-tree 404 属于 PowerShell URL construction failure。Reviewer 对相同 8 个 frozen repositories 重查，全部 `truncated=false`；resolution 准确。
- `morphe-patches@e120...:patches/src/main/kotlin/util/PatchListGenerator.kt` 重查为 HTTP 404；`morphe-patches-library@9e555...:patch-library/src/main/kotlin/app/morphe/util/PatchListGenerator.kt` 成功，official `patches/build.gradle.kts` 的 `mainClass` 指向它；resolution 准确。
- Manager code search 当前仍返回 `6db48374...` URL；compare API 证明 frozen `a2c3d31...` 在其后一个 commit。报告改用 exact-ref contents；resolution 准确。
- 报告已列出的 six Unverified facts 都给出 evidence limit 和 later-phase gate。MORPHE-P1-001 与 MORPHE-P1-002 则是未标记 Unverified 的 unsupported classification facts，因此此 rubric 项未通过。

## 三个 Phase 1 必答问题

### Manager 是否修改 APK？

是，但修改的是 original APK 的副本，并且要区分 orchestration 与 primitive ownership。Manager `Session.run` 建立 Patcher、执行 selected Patch、取得 `PatcherResult`、复制 input，再调用 `result.applyTo(copy)`；`PatcherWorker` 负责签名到 output。实际删除/合并 ZIP resources、写 DEX 和 realign 的 primitive 属于 `morphe-patcher ApkUtils.applyTo`。Candidate 的答案准确，没有把 original APK 说成原地修改，也没有把 mutation implementation 错归 Manager。

### Patch 与 APK 是什么关系？

Patch 是从 `.mpp` 通过 JAR/DEX reflection loader 得到的 named executable transformation object，携带 compatibility、dependencies、options、execute/finalize behavior；APK 是 host 提供的 target input。Host 选择 Patch set，Patcher 在解码 context 上执行并把结果应用到 APK 副本。Patch、`.mpp`、APK 和 modified APK 不是同一 artifact。Candidate 的答案准确。

### 为什么需要 Patch Source？

Patch Source 用 versioned metadata 将 Patch Bundle 的发现、版本和下载与用户提供的目标 APK 分离：`patches-bundle.json` 指向 `.mpp` asset，host 下载 executable Patch 后在本地与 APK 组合。Candidate 的核心答案准确；但 MORPHE-P1-002 表明报告遗漏了 website -> Manager 的 Source onboarding/handoff edge。

## Rubric assessment

| Requirement | Result |
| --- | --- |
| 21-repository API inventory, metadata and immutable HEADs | PASS |
| Every repository exactly once with correct Direct/Supporting/Excluded source edge | BLOCKED (`MORPHE-P1-001`, `MORPHE-P1-002`) |
| Build/publication ownership and artifact ordering | BLOCKED (`MORPHE-P1-003`) |
| Android Manager trace | BLOCKED on complete cited installer ownership (`MORPHE-P1-004`); other trace behavior verified |
| Desktop trace | PASS |
| morphe-patcher loader/execution/mutation trace | PASS |
| Artifact/edge rows and immutable exact paths | BLOCKED on artifact schema and claim support (`MORPHE-P1-001`, `MORPHE-P1-004`, `MORPHE-P1-005`); URL immutability itself passes |
| Three required semantic answers | PASS, with website omission noted |
| Failed calls preserved; unknowns gated | BLOCKED because two unsupported classifications were not Unverified |
| Phase/safety/diff boundary | PASS |

## Command outputs

```text
pwsh -NoProfile -File tools/check_documentation.ps1
Documentation checks passed: 31 Markdown files, 6 ADRs.
exit=0

pwsh -NoProfile -File tools/sync_upstream_docs.ps1 -Check
recorded=37b5eeb9c690ea169937fc2bac197bdcdb269014
upstream=37b5eeb9c690ea169937fc2bac197bdcdb269014
Official documentation snapshot is current.
exit=0

git diff --check 0e2dd4394ec853278a74f7456f761bb8cad16ea1 003ce9e85502d3393884cc4e328147db45b8ed53
<no output>
exit=0

MorpheApp URL audit
all_occurrences=132 unique_urls=75 moving_or_invalid=0 checked=75 failures=0

Post-review-artifact verification
pwsh -NoProfile -File tools/check_documentation.ps1
Documentation checks passed: 32 Markdown files, 6 ADRs.
exit=0

pwsh -NoProfile -File tools/sync_upstream_docs.ps1 -Check
recorded=37b5eeb9c690ea169937fc2bac197bdcdb269014
upstream=37b5eeb9c690ea169937fc2bac197bdcdb269014
Official documentation snapshot is current.
exit=0

git diff --check
<no output>
exit=0
```

## Final verdict

BLOCKED

本 verdict 不授权 Phase 2、Patch implementation 或任何 release。即使未来 Phase 1 Reviewer verdict 为 PASS，PASS 本身也不授权 Phase 2；只有 findings 解决、独立复核通过并由用户明确作出下一阶段决定后，才可进入后续阶段。

---

## Candidate `38d1613` 独立重审

### 重审身份、固定范围与方法

- 重审时间：`2026-07-19T11:21:27+08:00`（`Asia/Hong_Kong`）。
- Phase 1 base/authorization commit：`0e2dd4394ec853278a74f7456f761bb8cad16ea1`。
- 初始 candidate：`003ce9e85502d3393884cc4e328147db45b8ed53`；初审 commit：`44f757efc2ab455924f7814cd3e3c870caa3d239`。
- 修复 candidate：`38d161378183649301ca3863c463ab221f6aae5b`；重审开始和写报告前均确认 `HEAD` 等于该 candidate、分支为 `dev`、工作树为空。
- Reviewer 重新完整阅读 candidate report、evidence ledger、accepted baseline、Tasks 6-9、门禁和本文件的初审记录；没有把修复 diff 或报告正文当作事实证明。
- Reviewer 通过已认证的 GitHub API 重新读取组织清单、21 个 default-branch HEAD 和 candidate 的 frozen source/config paths。没有 clone、vendor 或 checkout 上游源码。
- 边界保持不变：未进入 Phase 2，未读取、检查、反编译或复制本地 APK，未编写 Patch 或产品代码；本次只修改 Reviewer report。

修复 diff `44f757efc2ab455924f7814cd3e3c870caa3d239..38d161378183649301ca3863c463ab221f6aae5b` 只修改 `docs/research/evidence-ledger.md` 与 `docs/research/morphe-ecosystem-architecture.md`。完整 Phase 1 diff `0e2dd4394ec853278a74f7456f761bb8cad16ea1..38d161378183649301ca3863c463ab221f6aae5b` 只含 initial Reviewer report、evidence ledger 和 architecture report；没有 Patch/product/Phase 2 文件或禁止资产。

### 独立证据重查结果

- 组织 API 仍返回 `public_repos=21`；repository listing 为 21 个 unique、21 个 unarchived。fork、default branch 和全部 21 个 40 位 HEAD 均与修复 candidate 的 inventory 一致。
- 修复 candidate report 包含 152 个 MorpheApp frozen source URL occurrences、78 个 unique URL；全部使用 `blob|tree/<40-sha>`，通过 exact-ref API 重查为 `78/78` 成功。
- 对 template、Gradle plugin、official patches、patches library、changelog、Manager、Desktop 和 Patcher 的 8 个 recursive trees 重查均成功且 `truncated=false`。错误的 official-repo `PatchListGenerator.kt` assumed path 仍为 404；实际 shared-library path 成功，原 failed-check resolution 准确。
- `morphe-patcher@b69536f:gradle/libs.versions.toml` 明确声明 `com.github.REAndroid:arsclib` 和 `com.github.MorpheApp.smali:smali`。因此修复后的 `ARSCLib=Excluded`、`smali=Supporting` 及相关计数成立。
- `morphe-website@57a6d8c:public/js/add-source.js` 读取 blocklist 并构造 `morphe.software/add-source` intent；Manager `MainActivity.kt` 和 manifest 消费同一 App Link 并写入 `pendingDeepLinkSource`。因此 `morphe-website=Supporting` 成立。
- Manager `InstallerManager.kt` 构造 internal、Shizuku、root/mount 与 external plans；`InstallViewModel.kt` dispatch/执行这些路径，并调用 `SessionInstaller`、`RootInstaller` 或 external intent。`PatcherWorker` 的边界被修正为 signed output。修复后的 install ownership 与逐边 citations 足以支持对应行。
- Artifact 表现在逐行显式记录 Input、Producer、Output artifact 和 Consumer；edge ledger 保留 producer/input/consumer/output/frozen evidence。schema 缺口已关闭。

### 初审 findings 处置

| ID | 重审状态 | 处置与独立证据 |
| --- | --- | --- |
| `MORPHE-P1-001` | **Resolved** | Inventory、分类说明和 ledger 均改为 `MorpheApp/ARSCLib=Excluded`，并引用 Patcher 的实际 `REAndroid` coordinate；计数仍为 `Direct=8`、`Supporting=4`、`Excluded=9`。 |
| `MORPHE-P1-002` | **Resolved** | `morphe-website` 已改为 Supporting；inventory、分类规则、artifact row 和 edge row 均记录 website -> Manager 的 Source onboarding handoff。 |
| `MORPHE-P1-003` | **Open - Blocking** | 修复图仍把含 `JVM classes + DEX + manifest` 的 `.mpp` 置于 `semantic-release prepare` 之前，并把 exec/PatchListGenerator 标成 `prepare step 2`。冻结 `.releaserc` 的实际 prepare plugin order 是 changelog -> `gradle-semantic-release-plugin` -> exec；template `package-lock.json` 固定后者为 `1.10.3`。该版本 [`prepare.ts`](https://github.com/KengoTODA/gradle-semantic-release-plugin/blob/75037a67e3729787c38d2374bab528233ddddaec/src/prepare.ts) 在 prepare 只更新/核对 `gradle.properties` version，[`publish.ts`](https://github.com/KengoTODA/gradle-semantic-release-plugin/blob/75037a67e3729787c38d2374bab528233ddddaec/src/publish.ts) 才在 semantic-release publish lifecycle 调用 Gradle `publish`。Template `generatePatchesList` 只 `dependsOn(build)`；Morphe [`PatchesPlugin.kt`](https://github.com/MorpheApp/morphe-patches-gradle-plugin/blob/52be641ed3b965a20c33bd43e0cbe9efd308bc64/src/main/kotlin/app/morphe/patches/gradle/PatchesPlugin.kt) 则使 Gradle `publish` 依赖 `buildAndroid`，后者才把 DEX 加入 `.mpp`。所以完整 Android `.mpp` 不能作为 semantic-release prepare 的前置输入，图仍遗漏 Gradle prepare 和后续 Gradle publish/buildAndroid stage。见 candidate report `:76-82`、`:169`，template `.releaserc:36-50`、`patches/build.gradle.kts:31-44`、`release.yml:37-40`。 |
| `MORPHE-P1-004` | **Resolved** | Inventory、matrix、artifact/edge rows 和 Manager core entry 现均引用 `InstallerManager.kt` 与 `InstallViewModel.kt`，并明确 `PatcherWorker` 止于 signed output；system/Shizuku/root/mount/external ownership 有 exact frozen paths。 |
| `MORPHE-P1-005` | **Resolved** | Artifact table 已改为所需四字段 provenance，并逐行补齐相应 frozen evidence。 |

`MORPHE-P1-003` 不是措辞偏好：Task 7 明确要求追踪 `.mpp` build、metadata generation 与 publication，Task 8 明确要求 lifecycle graph 和 artifact input/output。当前图把最终 executable artifact 放在实际生成 stage 之前，且遗漏一个 prepare plugin 与 Gradle publish lifecycle；因此关键 publication ordering 仍未达到独立门禁的证据一致性要求。

### 重审 rubric

| Requirement | Result |
| --- | --- |
| 21-repository API inventory, metadata and immutable HEADs | PASS |
| Every repository exactly once with correct Direct/Supporting/Excluded source edge | PASS |
| Build/publication ownership and artifact ordering | **BLOCKED (`MORPHE-P1-003`)** |
| Android Manager trace and complete installer ownership | PASS |
| Desktop trace | PASS |
| morphe-patcher loader/execution/mutation trace | PASS |
| Artifact/edge rows and immutable exact paths | PASS |
| Three required semantic answers | PASS |
| Failed calls preserved; unknowns gated | PASS |
| Phase/safety/diff boundary | PASS |

### 重审命令结果

```text
Authenticated MorpheApp inventory
public_repos=21 listed=21 unique=21 archived=0
21/21 default-branch HEADs matched the candidate inventory

Candidate MorpheApp URL audit
all_occurrences=152 unique_urls=78 moving_or_invalid=0 checked=78 failures=0

Recursive tree rechecks
morphe-patches-template entries=60 truncated=False
morphe-patches-gradle-plugin entries=42 truncated=False
morphe-patches entries=2654 truncated=False
morphe-patches-library entries=104 truncated=False
changelog entries=21 truncated=False
morphe-manager entries=627 truncated=False
morphe-desktop entries=270 truncated=False
morphe-patcher entries=196 truncated=False

pwsh -NoProfile -File tools/check_documentation.ps1
Documentation checks passed: 32 Markdown files, 6 ADRs.
exit=0

pwsh -NoProfile -File tools/sync_upstream_docs.ps1 -Check
recorded=37b5eeb9c690ea169937fc2bac197bdcdb269014
upstream=37b5eeb9c690ea169937fc2bac197bdcdb269014
Official documentation snapshot is current.
exit=0

git diff --check
<no output>
exit=0
```

### 重审 verdict

**BLOCKED**

初审五项中四项已解决，但 `MORPHE-P1-003` 仍开放。该 verdict 不授权 Phase 2、Patch implementation 或 release；修复后仍需独立重审，之后由用户作最终阶段决定。
