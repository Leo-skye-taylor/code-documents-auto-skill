# CLAUDE.md - 工作流规则

## 核心原则

**CRITICAL: 以下规则是强制性的，不可跳过。**

## 自动初始化规则

**当 AI 第一次接触项目时，必须自动执行：**

1. **检查项目状态**
   - 检查是否存在 `.ai-context/` 目录
   - 检查是否存在 `CLAUDE.md` 文件

2. **自动设置规则**
   - 如果 `CLAUDE.md` 不存在，创建并追加工作流规则
   - 如果 `.ai-context/` 不存在，提示用户运行 `/docs-scan`

**用户不需要执行任何手动操作，AI 会自动完成所有初始化。**

## Skill 指令驱动工作流

### 指令格式

```
/code-documents-auto <任务描述>
```

### 规则 1：开发前必须读取文档

**当用户输入开发任务时，AI 必须：**

1. **检查文档是否存在**
   - 检查 `.ai-context/` 目录是否存在
   - 如果不存在，提示用户先运行 `/docs-scan`

2. **解析任务描述**
   - 识别涉及的模块
   - 识别涉及的功能
   - 识别可能涉及的文件

3. **自动读取相关文档**
   - 读取架构文档：`.ai-context/architecture.md`
   - 读取编码规范：`.ai-context/guidelines/coding-style.md`
   - 读取模块文档：`.ai-context/modules/[模块名].md`
   - 读取 API 文档：`.ai-context/api/[API名].md`

4. **输出读取摘要**
   - 列出已读取的文档
   - 总结关键信息
   - 提示用户可以开始开发

### 规则 2：开发后必须归档文档

**当用户表示开发完成时，AI 必须：**

1. **检测变更**
   - 使用 `git diff` 扫描修改的文件
   - 识别涉及的模块

2. **生成变更记录**
   - 创建 `.ai-context/changelog/YYYY-MM-DD-HHMMSS-auto-archive.md`
   - 包含变更描述、修改文件列表、影响分析

3. **更新相关文档**
   - 更新模块文档：`.ai-context/modules/[模块名].md`
   - 更新 API 文档：`.ai-context/api/[API名].md`

4. **输出归档摘要**
   - 列出已更新的文档
   - 总结变更内容
   - 提示归档完成

### 规则 3：禁止跳过任何步骤

**以下行为是严格禁止的：**

- ❌ 跳过文档读取直接编辑代码
- ❌ 跳过文档归档直接结束工作
- ❌ 忽略用户的 `/code-documents-auto` 指令

## 指令场景示例

### 示例 1：开发前读取

```
用户：/code-documents-auto 加跨域请求配置

AI 必须执行：
1. 检查 .ai-context/ 是否存在
2. 解析任务 → 识别涉及 "跨域"、"配置"、"请求" 相关模块
3. 查找文档 → .ai-context/modules/config/, .ai-context/api/ 等
4. 读取文档 → 读取所有相关文档
5. 输出摘要 → "已读取以下文档：..."
```

### 示例 2：开发后归档

```
用户：/code-documents-auto 开发完了，归档

AI 必须执行：
1. 检测变更 → git diff 扫描修改的文件
2. 生成记录 → 创建 changelog
3. 更新文档 → 更新相关模块文档
4. 输出摘要 → "已归档以下变更：..."
```

### 示例 3：多模块变更

```
用户：/code-documents-auto 修改用户登录和权限验证功能

AI 必须执行：
1. 读取相关文档
2. 用户开发
3. 归档变更
```

## 文档结构

```
.ai-context/
├── README.md                    # 项目概览
├── architecture.md              # 系统架构
├── guidelines/                  # 编码规范
│   └── coding-style.md
├── modules/                     # 模块文档
│   ├── {模块1}.md
│   └── {模块2}.md
├── api/                         # API 文档
│   ├── {API1}.md
│   └── {API2}.md
├── changelog/                   # 变更记录
└── decisions/                   # 决策记录
```

## 快速参考

### 读取文档指令

```
/code-documents-auto <任务描述>
```

示例：
```
/code-documents-auto 加跨域请求配置
/code-documents-auto 修改登录功能
/code-documents-auto 修复认证 bug
```

### 归档指令

```
/code-documents-auto 开发完了，归档
/code-documents-auto 改完了
/code-documents-auto 完成
/code-documents-auto 归档
```

### 初始扫描

```
/docs-scan
```
