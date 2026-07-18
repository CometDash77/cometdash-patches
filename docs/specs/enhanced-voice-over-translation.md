# Enhanced Voice Over Translation 规范

## 产品目标

在官方 Voice over translation 的基础能力上，提供可观察、可配置、对 LLM 供应商开放且更重视上下文质量的 YouTube 译配音 Patch。优先级为：可观察与稳定性，其次翻译/字幕质量，最后语言与声音扩展。

首版只声明支持已实测的 YouTube `21.04.223`。Patch 使用独立 `evot` 命名空间，不能与官方 `Voice over translation` 同时选择。

## 交互

- 播放器按钮短按切换 `Voice Translation Enabled`。该偏好跨视频和 App 重启保持，直到用户手动关闭。
- 长按打开扩展 BottomSheet。顶部显示 Pipeline Status、当前 Translation Run 配置和恢复动作，下部保留语言、TTS、音量及模型快选。
- 普通状态只在用户主动打开面板时显示。首次阻断性失败可自动弹窗一次；后续状态变化不反复打断观看。
- 失败面板提供重试、停止本视频语音翻译和进入相关设置。无意义的动作必须禁用。
- Provider/model/参数/prompt 的修改只影响下一个视频，不提供当前视频立即重载。

## Translation Run

每次加载视频建立一个 Translation Run，并冻结以下配置：目标语言、Provider Profile、模型、请求参数、思考模式、自定义指令、上下文预算、TTS voice 与音量。后台任务必须携带 run generation；旧 generation 的结果不得写入当前视频。

Pipeline Status 不是单一布尔值，至少分别呈现：

- Caption：等待、获取中、可用、无字幕、失败。
- Context：关闭、准备中、可用、失败后降级。
- Translation：等待、翻译中、部分可用、可用、失败。
- Speech：空闲、预取、发声、暂停、失败。
- Run：未启用、启动中、活动、用户停止、完成、失败。

状态快照包含阶段、进度、当前 provider/model、目标语言、最后错误分类、可执行恢复动作和脱敏 correlation ID。

## Provider Profile

首版提供：

- 内置 OpenRouter profile。
- 内置 DeepSeek 中国服务 profile。
- 多个用户命名的 OpenAI-compatible Custom Provider Profile。

用户可以新增、编辑、复制和删除 Custom profile；内置 profile 不可删除。删除当前选中 profile 前必须先选择替代项。

Provider Profile 的持久字段：稳定 ID、显示名、类型、Base URL、加密 credential reference、可选敏感 headers、模型目录能力、streaming 能力、reasoning 映射能力、数据同意 fingerprint。API Key 与敏感 header 值使用 Android Keystore 保护且永不导出。

公网 Base URL 必须是 HTTPS。loopback 或私网地址可在二次警告后使用 HTTP。认证信息不得跟随跨 host 重定向。

首次启用每个 profile 时说明会发送视频标题、简介、字幕片段、上下文摘要与已有译文历史；不发送视频或音频文件。Base URL 改变或用户撤销同意后必须重新确认。

## 模型发现与配置

- 按需请求 OpenAI-compatible `/models`，显示加载、错误和最后成功更新时间。
- 上次成功列表可缓存和搜索；接口缺失或失败时始终允许手填 model ID。
- 每个 `provider + model` 保存独立 Model Configuration。
- Temperature 默认 `0`。
- Max output tokens 默认按目标批次自动估算，可显式覆盖。
- 请求超时使用验证后的安全默认值，可显式覆盖。
- Reasoning 为 `Auto / Enabled / Disabled` 三态，由 provider adapter 映射；不支持时禁用控件且不发送未知字段。
- 保持 streaming。首版不暴露 top-p、frequency/presence penalty、seed 或自由 JSON request template。

系统 prompt 必须保留目标语言、编号、逐行、不合并/跳过等解析协议。用户只能追加翻译风格、术语和语气指令，可预览最终 prompt 并恢复默认。

## Provider 诊断

测试按钮依次验证：认证/连通、模型存在、以当前参数和 prompt 翻译固定样例字幕、输出格式解析。每一步显示结果与耗时。测试不得改变当前 Translation Run，也不得泄露 API Key、敏感 headers 或完整请求正文。

## 翻译调度

- 默认维护播放头前方约 90 秒的待用译文，并保留后方约 30 秒结果用于小幅回退。
- 当前批次优先；seek 后取消或降优先旧请求并围绕新位置重建窗口。
- 译文仅保存在当前 App 会话，不做跨会话磁盘缓存。
- 网络超时、429 和 5xx 可有限指数退避并尊重 `Retry-After`。
- 401/403、模型不存在、无效参数和输出解析失败不自动循环请求，直接进入可操作失败状态。

## 三层上下文

1. Video Context Summary：用标题、简介和受预算限制的原始字幕生成视频语义摘要。默认使用翻译模型，也可选择另一个已配置模型；失败时继续无摘要翻译。
2. Neighbor Context：请求携带目标批次前后的原始字幕作为只读参考，只要求输出目标编号。
3. Timeline History：只使用目标时间之前、已成功且连续的 N 轮源文/译文。不得按网络完成顺序建立历史。

每个 provider+model 独立配置摘要字幕字符上限、前后邻近字幕字符上限和历史轮数。UI 显示估算 token 与模型上下文超限警告。seek 到没有连续历史的区域时，只使用摘要和邻近原文。

## TTS 与原声

- 复用经过验证的系统 TTS/Edge TTS 行为，具体实现以阶段二源码研究为准。
- 只有 TTS 音频实际发声时才应用 Audio Ducking；翻译、摘要、合成和等待期间保持原声。
- 沿用可调原声音量比例并使用短淡变。
- TTS 完成、停止、失败、暂停处理、seek、切视频、关闭功能或生命周期中断时必须恢复 multiplier。
- 不得写入或覆盖 YouTube 的持久音量设置。

## AI 字幕

首版产品不承诺显示 LLM 字幕。先执行 Native CC Injection Probe，验证固定版本上 translated cue 能稳定进入 YouTube 原生 caption renderer，并覆盖暂停、seek、倍速和切视频。

探针失败时保存证据并暂缓该功能；不实现自绘字幕 overlay，也不以 YouTube 原生自动翻译冒充 LLM 字幕。

## 明确不做

- 不提供任意 JSON 请求模板或多种原生非 OpenAI 协议 adapter。
- 不提供当前视频立即切换 provider/model。
- 不做持久译文缓存、自动供应商故障切换、术语表或费用统计。
- 不声明未经真实 APK 门禁验证的 YouTube 版本支持。
- 首版派生完成后不主动同步官方 VoT 源码修复；该维护风险由 CometDash Patches 承担。
