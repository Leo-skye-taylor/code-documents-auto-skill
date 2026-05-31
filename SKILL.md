---
name: code-documents-auto
description: >
  通过指令驱动的代码文档管理。用户输入 /code-documents-auto 触发 AI 读取文档或归档变更。
metadata:
  version: "2.0"
  author: "trainMini"
---

# Code Documents Auto Skill

通过 `/code-documents-auto` 指令驱动的代码文档管理系统。

## 使用方式

```
/code-documents-auto <任务描述>
```

**AI 会根据你的输入自动判断并执行相应操作。**

## 指令场景

### 场景 1：开发前 - 读取文档

当用户描述要开发的任务时，AI 自动读取相关文档。

**示例：**
```
/code-documents-auto 加跨域请求配置
/code-documents-auto 修改登录功能，添加记住密码
/code-documents-auto 修复认证模块的 bug
/code-documents-auto 重构数据库层
```

**AI 执行流程：**
1. **解析任务** - 分析任务描述，识别涉及的模块、功能、文件
2. **查找文档** - 在 `.ai-context/` 下查找相关文档
3. **读取文档** - 读取所有相关文档（模块文档、功能文档、API 文档、架构文档、编码规范）
4. **输出摘要** - 向用户展示已读取的文档列表和关键信息

### 场景 2：开发后 - 归档变更

当用户表示开发完成时，AI 自动归档变更。

**示例：**
```
/code-documents-auto 开发完了，归档
/code-documents-auto 改完了
/code-documents-auto 完成
/code-documents-auto 归档
```

**AI 执行流程：**
1. **检测变更** - 扫描项目中修改的文件
2. **生成记录** - 创建变更记录到 `.ai-context/changelog/`
3. **更新文档** - 更新相关模块文档、功能文档、API 文档
4. **输出摘要** - 向用户展示已归档的变更内容

## 自动初始化

**当 AI 第一次接触项目时，会自动执行：**

1. 检查 `.ai-context/` 目录是否存在
2. 检查 `CLAUDE.md` 文件是否存在
3. 如果不存在，运行 `/docs-scan` 生成初始文档

**用户无需手动操作，AI 自动完成。**

## 文档结构

```
.ai-context/
├── README.md              # 项目概览
├── architecture.md        # 系统架构
├── guidelines/            # 编码规范
├── modules/               # 模块文档
├── features/              # 功能文档
├── api/                   # API 文档
├── changelog/             # 变更记录
└── decisions/             # 决策记录
```

## 辅助命令

### `/docs-scan` - 初始扫描

首次使用时扫描代码库，生成结构化文档：

```
/docs-scan [目录]
```

**输出：**
- `.ai-context/` 目录及完整文档结构

## 最佳实践

1. **开发前先说任务** - 让 AI 读取相关文档，了解上下文
2. **开发后说归档** - 让 AI 记录变更，保持文档同步
3. **任务描述要清晰** - 帮助 AI 准确识别涉及的模块和功能

## 常见用法

```
# 开发前
/code-documents-auto 添加用户头像上传功能
/code-documents-auto 修改订单查询接口，支持分页

# 开发后
/code-documents-auto 开发完了，归档
/code-documents-auto 改完了，记录一下

# 首次使用
/docs-scan
```
