# UniBalance - 多模型 API 余额监控卫士

<p align="center">
  <img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS-blue" alt="Platform">
  <img src="https://img.shields.io/badge/framework-Flutter-02569B" alt="Framework">
  <img src="https://img.shields.io/badge/state%20management-Riverpod-FF6B6B" alt="State Management">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
  <img src="https://img.shields.io/badge/privacy-first-important" alt="Privacy First">
</p>

**UniBalance** 是一款开源、隐私至上的手机端 App（Android/iOS），旨在解决大模型开发者多平台余额查看难、消耗不透明的问题。

核心理念：**绝对隐私**。App 仅与大模型官方 API 直连，不设中转服务器，不获取用户任何 API Key。

开源策略：代码全开源以建立信任，通过“便利性”（App Store 付费/订阅）和“高级功能”（小组件、同步）实现商业化。

---

## 🎯 项目愿景 (Project Vision)

为 AI 开发者与研究者提供一个**安全、透明、便捷**的多平台 API 余额监控工具。让每一份 Token 消耗都清晰可见，帮助用户避免因余额不足导致的服务中断，并通过智能告警与历史分析优化使用成本。

## 🛠️ 技术栈 (Technical Stack)

| 组件 | 技术选型 | 说明 |
|------|----------|------|
| **框架** | Flutter (Dart) | 跨平台 UI 框架，保证双端 UI 高度一致且开发高效 |
| **状态管理** | Riverpod | 用于复杂的异步数据流（余额刷新）管理 |
| **网络层** | Dio | 支持全局代理配置、拦截器（处理 429 重试）及并发请求控制 |
| **本地安全存储** | flutter_secure_storage | 存储 API Keys（iOS KeyChain / Android KeyStore） |
| **本地数据库** | Isar (NoSQL) | 存储非敏感的余额历史记录、图表数据 |
| **安全认证** | local_auth | 指纹/FaceID 解锁 |
| **图表库** | fl_chart | 用于展示消耗趋势 |
| **后台任务** | workmanager (Android) & Background Fetch (iOS) | 定时刷新与通知 |

## 🚀 核心功能模块 (Core Features)

### A. 资产看板 (Dashboard)
- 多平台卡片式展示（OpenAI, Anthropic, DeepSeek, Google Gemini, 智谱AI, Kimi, OneAPI 等）
- 自动汇率转换（USD → CNY）
- 一键全局刷新（带并发控制与指数退避重试）
- 实时余额进度条与消耗趋势图

### B. 智能告警 (Alerting)
- 自定义阈值告警（如：余额少于 $5 或 10% 时推送通知）
- 额度过期提醒
- 异常消耗波峰检测（本地计算）

### C. 桌面小组件 (Widgets)
- 支持 iOS 灵动岛、锁屏组件及安卓桌面小组件
- Premium 特性：多平台轮播组件、实时进度条

### D. 安全与同步
- 生物识别锁：App 启动或从后台恢复时验证
- 无服务器同步：支持 WebDAV 或 iCloud 备份，数据使用用户自定义密码进行 AES-256-GCM 加密后再上传

## 🏗️ 架构设计 (Architecture)

### 适配器模式 (Adapter Pattern)
定义 `BaseProvider` 抽象类，要求针对不同平台实现：
- `fetchBalance()`: 获取余额
- `fetchUsage()`: 获取历史消耗
- `parseResponse()`: 结合云端规则 (JSONPath) 解析不同格式的返回体

### 目录结构 (Folder Structure)
```
lib/
├── core/               # 网络拦截器、加密算法、常量
├── providers/          # API 适配器实现 (OpenAI, DeepSeek等)
├── models/             # Freezed 自动生成的实体类
├── state/              # Riverpod Providers (余额状态、设置状态)
├── ui/                 # Material 3 UI 组件与页面
│   ├── dashboard/
│   ├── settings/
│   └── widgets/        # 自定义卡片与图表
└── services/           # 后台任务、本地通知、生物识别服务
```

## 📝 Claude Code 实施步骤 (Step-by-Step)

### 1. 初始化项目
```bash
flutter create --org com.yourname.unibalance --platforms android,ios unibalance
cd unibalance
```

添加依赖（`pubspec.yaml`）：
```yaml
dependencies:
  flutter:
    sdk: flutter
  riverpod: ^2.4.9
  dio: ^5.4.0
  flutter_secure_storage: ^9.1.1
  isar: ^3.1.0+1
  isar_flutter_libs: ^3.1.0+1
  path_provider: ^2.1.1
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  fl_chart: ^0.65.0
  local_auth: ^2.1.6
  home_widget: ^0.1.0
```

### 2. 构建安全层
实现 `SecurityService` 类，封装 `flutter_secure_storage`。确保 API Key 在存储前不会被打印到控制台。

### 3. 设计适配器基类
设计 `BaseProvider` 接口，包含处理 Dio 代理设置的方法，并支持从 GitHub Gist 动态加载 API 解析规则（JSONPath）。

### 4. 实现首批 API 接入
优先实现 OpenAI 和 DeepSeek 的余额查询逻辑。注意 OpenAI 需要访问 `/v1/dashboard/billing/usage` 接口。

### 5. UI 开发
创建一个基于 Material 3 的 Dashboard。使用 `ListView.builder` 加载 API 资产卡片。卡片需包含：品牌图标、余额进度条、刷新状态指示器。

## 💰 商业化与开源限制 (Monetization & Open Source)

### 开源范围
- UI 界面与交互逻辑
- 基础适配器实现（OpenAI、DeepSeek 等）
- 本地存储与安全加密逻辑
- 核心监控与告警功能

### 闭源/内购建议（Premium 功能）
- iCloud/WebDAV 自动同步插件
- 高级桌面小组件（灵动岛支持、多平台轮播）
- PDF 详细月度账单导出
- 团队协作与多账户管理

### 防逆向保护
在打包脚本中默认加入 `--obfuscate --split-debug-info` 指令。

## 📄 许可证 (License)

本项目采用 **MIT 许可证**。详见 [LICENSE](LICENSE) 文件。

## 🤝 贡献指南 (Contributing)

我们欢迎任何形式的贡献！请阅读 [CONTRIBUTING.md](CONTRIBUTING.md) 了解如何参与。

## 🐛 问题反馈 (Issues)

如遇问题，请先查阅 [FAQ](docs/FAQ.md)。若未解决，请在 [Issues](https://github.com/yourname/unibalance/issues) 页面提交。

---

**UniBalance - 让每一份 Token 消耗都清晰可见。**