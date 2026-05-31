# AGENTS.md - Agent 行为规则

## 自动初始化规则

**当 AI 第一次接触项目时，必须自动执行以下操作：**

### 步骤 1：检查项目状态

```yaml
检查项目:
  - 是否存在 ai-context/ 目录？
  - 是否存在 CLAUDE.md 文件？
  - 是否存在 AGENTS.md 文件？
  - 是否存在工作流日志？
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
  检查: 是否存在 ai-context/ 目录？
  动作: 如果不存在，自动运行 /docs-scan
  结果: 生成完整的文档结构
```

### 步骤 4：自动初始化工作流

```yaml
初始化工作流:
  检查: 是否存在工作流日志？
  动作: 如果不存在，自动创建
  结果: 工作流系统就绪
```

**用户不需要执行任何手动操作，AI 会自动完成所有初始化。**

## Agent 类型

### 1. CodeEditor Agent（代码编辑 Agent）

**职责**：执行代码修改任务

**强制规则**：

#### 开发前（必须执行）

```yaml
步骤 1: 识别影响范围
  - 分析要修改的文件路径
  - 确定涉及的模块（从路径提取）
  - 确定涉及的功能

步骤 2: 自动读取文档
  必读文档:
    - ai-context/architecture.md
    - ai-context/guidelines/README.md
    - ai-context/modules/{module}/README.md
  
  条件读取:
    - ai-context/features/{feature}/README.md（如果存在）
    - ai-context/api/{api}/README.md（如果存在）

步骤 3: 启动工作流
  命令: ./scripts/enforce-workflow.sh start -f "{files}" -m "{modules}"

步骤 4: 验证读取
  命令: ./scripts/enforce-workflow.sh check -f "{files}"
  要求: 必须返回成功才能继续
```

#### 开发中（执行修改）

```yaml
步骤 5: 执行代码修改
  - 使用 Edit 工具修改代码
  - 遵循编码规范
  - 保持代码风格一致
```

#### 开发后（必须执行）

```yaml
步骤 6: 生成变更记录
  命令: ./scripts/record-changes.sh "{description}"
  
步骤 7: 更新模块文档
  文件: ai-context/modules/{module}/README.md
  内容: 添加最近更新记录

步骤 8: 完成工作流
  命令: ./scripts/enforce-workflow.sh complete -f "{modified_files}"

步骤 9: 验证归档
  - 确认变更记录已生成
  - 确认模块文档已更新
  - 确认工作流会话已完成
```

### 2. DocumentReader Agent（文档读取 Agent）

**职责**：读取和理解项目文档

**强制规则**：

```yaml
读取顺序:
  1. ai-context/README.md（项目概览）
  2. ai-context/architecture.md（系统架构）
  3. ai-context/guidelines/README.md（编码规范）
  4. ai-context/modules/{module}/README.md（模块文档）

读取要求:
  - 必须完整读取，不能跳过
  - 必须理解内容
  - 必须记录读取状态

输出:
  - 读取确认
  - 关键信息摘要
  - 影响分析
```

### 3. DocumentWriter Agent（文档写入 Agent）

**职责**：生成和更新项目文档

**强制规则**：

```yaml
生成文档:
  变更记录:
    位置: ai-context/changelog/
    格式: YYYY-MM-DD-{type}-{name}.md
    内容: 完整的变更记录

  模块文档:
    位置: ai-context/modules/{module}/README.md
    内容: 最近更新记录

  决策记录:
    位置: ai-context/decisions/
    格式: YYYY-MM-DD-{decision}.md
    内容: 重要决策记录

更新要求:
  - 必须更新所有相关文档
  - 必须保持文档一致性
  - 必须记录完整信息
```

## Agent 交互流程

### 完整工作流

```
用户请求
    ↓
CodeEditor Agent 启动
    ↓
DocumentReader Agent 读取文档
    ↓
CodeEditor Agent 执行修改
    ↓
DocumentWriter Agent 生成文档
    ↓
CodeEditor Agent 完成工作流
    ↓
返回结果给用户
```

### 强制检查点

```yaml
检查点 1: 开发前
  - 工作流会话是否活跃？
  - 必需文档是否已读取？
  - 如果失败: 阻止编辑，提示读取文档

检查点 2: 开发后
  - 变更记录是否已生成？
  - 模块文档是否已更新？
  - 工作流会话是否已完成？
  - 如果失败: 提示完成归档

检查点 3: 停止前
  - 是否有未归档的修改？
  - 如果失败: 警告需要归档
```

## Agent 通信协议

### 消息格式

```yaml
类型: workflow_update
内容:
  action: "start|check|complete|read|write|archive"
  files: ["file1.ts", "file2.ts"]
  modules: ["module1", "module2"]
  status: "success|failure|pending"
  message: "描述信息"
```

### 错误处理

```yaml
错误类型: missing_documents
处理: 自动读取缺失的文档

错误类型: workflow_not_active
处理: 启动新的工作流会话

错误类型: archive_incomplete
处理: 完成文档归档
```

## Agent 自动化规则

### 规则 1：自动识别文档需求

```python
def identify_required_docs(file_path):
    module = extract_module(file_path)
    docs = [
        "ai-context/architecture.md",
        "ai-context/guidelines/README.md",
        f"ai-context/modules/{module}/README.md"
    ]
    
    # 检查功能文档
    if has_feature_docs(module):
        docs.append(f"ai-context/features/{module}/README.md")
    
    # 检查 API 文档
    if has_api_docs(module):
        docs.append(f"ai-context/api/{module}/README.md")
    
    return docs
```

### 规则 2：自动读取文档

```python
def auto_read_documents(docs):
    for doc in docs:
        if not is_document_read(doc):
            read_document(doc)
            record_reading(doc)
```

### 规则 3：自动生成文档

```python
def auto_generate_docs(modified_files):
    # 生成变更记录
    generate_change_record(modified_files)
    
    # 更新模块文档
    for file in modified_files:
        module = extract_module(file)
        update_module_doc(module)
    
    # 完成工作流
    complete_workflow(modified_files)
```

## Agent 验证机制

### 验证脚本

```bash
# 验证文档读取
./scripts/validate-reading.sh -f "文件列表"

# 验证工作流状态
./scripts/enforce-workflow.sh check -f "文件列表"

# 验证归档完成
./scripts/enforce-workflow.sh verify
```

### 验证结果处理

```yaml
结果: success
处理: 继续执行

结果: failure
处理: 
  - 显示错误信息
  - 列出缺失的步骤
  - 提供修复命令
  - 阻止继续执行
```

## Agent 最佳实践

### 1. 预防性读取

- 在编辑前主动读取所有相关文档
- 不要等到 hooks 报错才读取
- 理解文档内容，不要只是形式上读取

### 2. 完整性归档

- 记录所有修改的文件
- 更新所有相关文档
- 生成完整的变更记录

### 3. 一致性维护

- 保持文档格式一致
- 保持命名规范一致
- 保持工作流流程一致

### 4. 错误恢复

- 如果工作流中断，及时恢复
- 如果文档缺失，及时补充
- 如果归档不完整，及时完成
