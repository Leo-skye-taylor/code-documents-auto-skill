# AGENTS.md - Agent 行为规则

## 自动初始化规则

**当 AI 第一次接触项目时，必须自动执行以下操作：**

### 步骤 1：检查项目状态

```yaml
检查项目:
  - 是否存在 .ai-context/ 目录？
  - 是否存在 CLAUDE.md 文件？
  - 是否存在 AGENTS.md 文件？
```

### 步骤 2：自动设置规则

```yaml
设置 CLAUDE.md:
  检查: 是否存在文件？
  检查: 是否包含强制规则？
  动作: 如果不存在或缺少规则，自动追加

设置 AGENTS.md:
  检查: 是否存在文件？
  检查: 是否包含 Agent 规则？
  动作: 如果不存在或缺少规则，自动追加
```

### 步骤 3：自动扫描代码库

```yaml
扫描代码库:
  检查: 是否存在 .ai-context/ 目录？
  动作: 如果不存在，自动运行 /docs-scan
  结果: 生成完整的文档结构
```

**用户不需要执行任何手动操作，AI 会自动完成所有初始化。**

## Skill 指令驱动

### 指令格式

```
/code-documents-auto <任务描述>
```

### 场景判断

AI 根据用户输入判断执行场景：

```yaml
场景 1 - 开发前读取:
  触发词: 任何任务描述（如 "加跨域配置"、"修改登录"）
  动作: 读取相关文档

场景 2 - 开发后归档:
  触发词: "开发完了"、"改完了"、"完成"、"归档"
  动作: 归档变更
```

## Agent 行为规则

### 开发前 - 读取文档

**当用户输入开发任务时，AI 必须执行：**

```yaml
步骤 1: 解析任务
  - 分析任务描述
  - 识别涉及的模块
  - 识别涉及的功能

步骤 2: 查找文档
  必查目录:
    - .ai-context/modules/
    - .ai-context/features/
    - .ai-context/api/

步骤 3: 读取文档
  必读文档:
    - .ai-context/architecture.md
    - .ai-context/guidelines/README.md
    - .ai-context/modules/{module}/README.md
  
  条件读取:
    - .ai-context/features/{feature}/README.md（如果存在）
    - .ai-context/api/{api}/README.md（如果存在）

步骤 4: 输出摘要
  - 列出已读取的文档
  - 总结关键信息
  - 提示可以开始开发
```

### 开发后 - 归档变更

**当用户表示开发完成时，AI 必须执行：**

```yaml
步骤 1: 检测变更
  - 扫描修改的文件
  - 识别涉及的模块

步骤 2: 生成记录
  位置: .ai-context/changelog/
  格式: YYYY-MM-DD-HHMMSS-auto-archive.md
  内容:
    - 变更描述
    - 修改文件列表
    - 影响分析

步骤 3: 更新文档
  更新文件:
    - .ai-context/modules/{module}/README.md
    - .ai-context/features/{feature}/README.md（如果存在）
    - .ai-context/api/{api}/README.md（如果存在）

步骤 4: 输出摘要
  - 列出已更新的文档
  - 总结变更内容
  - 提示归档完成
```

## 错误处理

```yaml
错误: 缺失文档
处理: 提示用户运行 /docs-scan 初始化

错误: 无法识别任务
处理: 询问用户具体需求

错误: 归档失败
处理: 显示错误信息，提供修复建议
```

## 最佳实践

### 1. 任务描述要清晰

```
❌ 不好: "改代码"
✅ 好: "加跨域请求配置"

❌ 不好: "修 bug"
✅ 好: "修复登录接口的认证错误"
```

### 2. 开发后及时归档

```
❌ 开发完不归档，导致文档过时
✅ 开发完立即归档，保持文档同步
```

### 3. 完整读取文档

```
❌ 只读取部分文档
✅ 读取所有相关文档，理解完整上下文
```

## 常见用法

```bash
# 开发前
/code-documents-auto 加跨域请求配置
/code-documents-auto 修改登录功能，添加记住密码
/code-documents-auto 修复认证模块的 bug
/code-documents-auto 重构数据库层

# 开发后
/code-documents-auto 开发完了，归档
/code-documents-auto 改完了
/code-documents-auto 完成
/code-documents-auto 归档

# 首次使用
/docs-scan
```
