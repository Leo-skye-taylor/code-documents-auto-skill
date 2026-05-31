# CLAUDE.md - 强制工作流规则

## 核心原则

**CRITICAL: 以下规则是强制性的，不可跳过。**

## 自动初始化规则

**当 AI 第一次接触项目时，必须自动执行：**

1. **检查项目状态**
   - 检查是否存在 `ai-context/` 目录
   - 检查是否存在 `CLAUDE.md` 文件
   - 检查是否存在 `AGENTS.md` 文件

2. **自动设置规则**
   - 如果 `CLAUDE.md` 不存在，创建并追加强制规则
   - 如果 `CLAUDE.md` 存在但没有强制规则，追加规则
   - 如果 `AGENTS.md` 不存在，创建并追加 Agent 规则
   - 如果 `AGENTS.md` 存在但没有 Agent 规则，追加规则

3. **自动扫描代码库**
   - 如果 `ai-context/` 不存在，运行 `/docs-scan` 生成文档

4. **自动初始化工作流**
   - 确保工作流日志存在
   - 确保读取日志存在

**用户不需要执行任何手动操作，AI 会自动完成所有初始化。**

## 强制工作流

### 规则 1：开发前必须读取文档

**当用户请求修改代码时，AI 必须：**

1. **识别影响范围**
   - 分析要修改的文件
   - 确定涉及的模块
   - 确定涉及的功能

2. **自动读取相关文档**
   - 读取架构文档：`ai-context/architecture.md`
   - 读取编码规范：`ai-context/guidelines/README.md`
   - 读取模块文档：`ai-context/modules/[模块名]/README.md`
   - 读取功能文档：`ai-context/features/[功能名]/README.md`（如果存在）
   - 读取 API 文档：`ai-context/api/[API名]/README.md`（如果存在）

3. **记录读取**
   - 运行：`./scripts/enforce-workflow.sh start -f "文件列表" -m "模块列表"`
   - 确保工作流会话已启动

4. **验证读取完成**
   - 运行：`./scripts/enforce-workflow.sh check -f "文件列表"`
   - 确保所有必需文档已读取

5. **只有读取完成后才能编辑代码**

### 规则 2：开发后必须归档文档

**当代码修改完成后，AI 必须：**

1. **生成变更记录**
   - 运行：`./scripts/record-changes.sh "变更描述"`
   - 或运行：`./hooks/force-archive.sh`

2. **更新相关文档**
   - 更新模块文档：`ai-context/modules/[模块名]/README.md`
   - 更新功能文档：`ai-context/features/[功能名]/README.md`（如果存在）
   - 更新 API 文档：`ai-context/api/[API名]/README.md`（如果存在）

3. **完成工作流会话**
   - 运行：`./scripts/enforce-workflow.sh complete -f "修改的文件列表"`

4. **只有归档完成后才能继续其他工作**

### 规则 3：禁止跳过任何步骤

**以下行为是严格禁止的：**

- ❌ 跳过文档读取直接编辑代码
- ❌ 跳过文档归档直接结束工作
- ❌ 忽略 hooks 的警告信息
- ❌ 不记录工作流会话

## 工作流示例

### 示例 1：修改认证模块

```
用户：请修改 src/auth/login.ts 文件，添加记住密码功能

AI 必须执行：
1. 读取 ai-context/architecture.md
2. 读取 ai-context/guidelines/README.md
3. 读取 ai-context/modules/auth/README.md
4. 运行 ./scripts/enforce-workflow.sh start -f "src/auth/login.ts" -m "auth"
5. 验证读取完成
6. 执行代码修改
7. 运行 ./scripts/record-changes.sh "添加记住密码功能"
8. 更新 ai-context/modules/auth/README.md
9. 运行 ./scripts/enforce-workflow.sh complete -f "src/auth/login.ts"
```

### 示例 2：修改多个模块

```
用户：请修改用户登录和权限验证功能

AI 必须执行：
1. 读取 ai-context/architecture.md
2. 读取 ai-context/guidelines/README.md
3. 读取 ai-context/modules/auth/README.md
4. 读取 ai-context/modules/user/README.md
5. 运行 ./scripts/enforce-workflow.sh start -f "src/auth/login.ts,src/user/user.service.ts" -m "auth,user"
6. 验证读取完成
7. 执行代码修改
8. 运行 ./scripts/record-changes.sh "修改用户登录和权限验证功能"
9. 更新 ai-context/modules/auth/README.md
10. 更新 ai-context/modules/user/README.md
11. 运行 ./scripts/enforce-workflow.sh complete -f "src/auth/login.ts,src/user/user.service.ts"
```

## Hooks 验证机制

### PreToolUse Hook（编辑前验证）

- 检查工作流会话是否活跃
- 检查必需文档是否已读取
- 如果检查失败，阻止编辑并提示 AI 读取文档

### PostToolUse Hook（编辑后验证）

- 记录修改的文件
- 更新模块文档
- 提示 AI 需要完成归档

### Stop Hook（停止前验证）

- 检查是否有未归档的修改
- 警告 AI 需要完成归档

## 违规处理

**如果 AI 跳过任何步骤：**

1. hooks 会阻止操作
2. AI 会收到错误信息
3. AI 必须完成缺失的步骤才能继续

## 文档结构

```
ai-context/
├── README.md                    # 项目概览
├── architecture.md              # 系统架构
├── guidelines/                  # 编码规范
├── modules/                     # 模块文档
├── features/                    # 功能文档
├── api/                         # API 文档
├── changelog/                   # 变更记录
└── decisions/                   # 决策日志
```

## 快速参考

### 读取文档命令

```bash
# 读取架构文档
cat ai-context/architecture.md

# 读取编码规范
cat ai-context/guidelines/README.md

# 读取模块文档
cat ai-context/modules/[模块名]/README.md
```

### 工作流命令

```bash
# 启动工作流
./scripts/enforce-workflow.sh start -f "文件列表" -m "模块列表"

# 检查读取状态
./scripts/enforce-workflow.sh check -f "文件列表"

# 完成工作流
./scripts/enforce-workflow.sh complete -f "修改的文件列表"
```

### 归档命令

```bash
# 记录变更
./scripts/record-changes.sh "变更描述"

# 强制归档
./hooks/force-archive.sh
```
