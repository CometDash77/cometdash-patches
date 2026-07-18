# Morphe Patch Agent 培养路线

## 原则

学习进度由输入、证据、产物和门禁衡量，不使用日、周、月估算。阶段采用门禁式螺旋：允许为当前目标补齐最小依赖知识，但未通过门禁不得进入下一能力层。

所有事实必须形成可复用资产。研究条目至少说明作用、问题、涉及文件、证据 revision、代码案例、常见错误和实际应用。

## 阶段

### 0. 决策与记忆基线

产物：Agent 规则、领域上下文、产品规范、ADR、证据账本、官方文档快照、运行手册和验收门禁。

通过条件：独立 Reviewer 确认本次访谈的决定完整、无冲突、分类正确；用户最终确认。

### 1. Morphe 生态

研究组织内全部活跃官方仓库，再收敛参与 Patch 发现、构建、应用和发布的组件。输出《Morphe 生态架构分析报告》，明确输入、输出、调用关系和排除项。

通过条件：关键结论锚定固定 commit 与源码路径；能够有证据地回答 Manager 是否修改 APK、Patch 与 APK 的关系、Patch Source 的存在理由。不得编写 Patch。

### 2. 官方 Voice Over Translation

追踪 Patch 定义、fingerprint、extension、字幕获取、翻译、TTS、播放时钟和原声 multiplier。建立数据流、状态、线程和失败模式模型。

通过条件：独立复核关键调用链；未知 hook 明确标记，不能以类名推测代替证据。

### 3. 开发与构建基线

安装并验证 JDK、Gradle、Morphe 工具、JADX 和设备工作流。对用户提供的 `21.04.223` APK 建立哈希、构建与安装证据。

通过条件：空 Patch Source 构建可重复；APK、密钥与反编译输出均未进入版本控制。

### 4. 可观察状态

建立分阶段 Pipeline Status、播放器长按面板、分类错误与恢复动作。这是首个功能增量。

通过条件：字幕、上下文、翻译、语音各阶段可区分；失败原因可操作且日志脱敏。

### 5. Provider 与模型

实现 Built-in/Custom Provider Profile、模型发现、Model Configuration、思考三态、自定义附加提示词、分阶段诊断与密钥保护。

通过条件：OpenRouter、DeepSeek 中国服务和一个自定义 OpenAI-compatible endpoint 分别通过契约测试与真实诊断。

### 6. 调度、上下文与音频

实现动态 Translation Window、三层上下文、时间线历史、分类重试和严格 Audio Ducking 生命周期。

通过条件：暂停、倍速、缓冲、seek、切视频、前后台和失败恢复场景不混用配置、不遗留 TTS、不改变持久音量。

### 7. 原生字幕技术探针

对固定 YouTube 版本定位原生 caption cue/renderer 数据流，验证 LLM 译文能否稳定进入原生 CC。

通过条件：若暂停、seek、倍速和切视频均通过，则提出独立功能计划；否则记录失败证据并暂缓，不开发自绘字幕层。

### 8. Source 发布

完成产品投影、预发布、稳定发布、用户安装说明和真实 Morphe App 冒烟门禁。后续增加版本时逐 APK 放行。

## 阶段门禁

执行 Agent提交产物和原始证据。Reviewer 只获得目标、rubric、产物和固定证据，不获得执行 Agent 的思考记录。Reviewer 的阻断问题解决后，用户决定是否进入下一阶段。
