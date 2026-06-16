---
name: docs-archive
description: >
  检测代码变更并归档文档。开发完成后运行。
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
---

# /docs-archive — 归档变更

**当用户输入 `/docs-archive` 时，执行以下完整流程：**

## 步骤 1：检测变更

使用 Bash 执行以下命令，全面了解代码变更：

```bash
# 查看变更统计
git diff --stat

# 查看变更文件列表（含状态）
git diff --name-status

# 查看未跟踪的新文件
git ls-files --others --exclude-standard

# 查看暂存区变更
git diff --cached --name-status
```

**分析变更内容**：
- 识别修改（M）、新增（A）、删除（D）的文件
- 按模块分类变更文件
- 识别变更类型（功能新增、bug修复、重构、配置变更等）

## 步骤 1.5：收集用户文档

**检查用户是否提供了相关文档：**

询问用户或检测是否有以下文档：
- 需求文档（PRD、需求规格说明等）
- 技术文档（技术方案、架构设计等）
- 测试报告（测试用例、测试结果等）
- 设计文档（UI 设计、流程图等）
- 其他参考（会议纪要、讨论记录等）

**如果用户提供了文档：**

1. **创建文档目录结构**：
   ```bash
   mkdir -p .ai-context/changelog/{文件夹名}/docs/requirements
   mkdir -p .ai-context/changelog/{文件夹名}/docs/technical
   mkdir -p .ai-context/changelog/{文件夹名}/docs/testing
   mkdir -p .ai-context/changelog/{文件夹名}/docs/design
   mkdir -p .ai-context/changelog/{文件夹名}/docs/other
   ```

2. **复制或创建文档**：
   - 如果用户提供了文件路径，复制到对应目录
   - 如果用户提供了内容，创建对应的 md 文件
   - 如果用户口头描述，整理成文档保存

3. **文档分类**：

| 文档类型 | 存放目录 | 典型文件 | 说明 |
|----------|----------|----------|------|
| 需求文档 | `docs/requirements/` | PRD、需求规格、用户故事 | 描述要做什么 |
| 技术文档 | `docs/technical/` | 技术方案、架构设计、API 设计 | 描述怎么做 |
| 测试文档 | `docs/testing/` | 测试用例、测试报告、QA 验收单 | 验证做得对不对 |
| 设计文档 | `docs/design/` | UI 设计稿、交互流程图、架构图 | 视觉和交互设计 |
| 其他文档 | `docs/other/` | 会议纪要、参考资料、讨论记录 | 补充参考材料 |

4. **docs/ 各子目录模板（参考）：**

   **`docs/requirements/{name}.md`**：需求文档
   ```markdown
   # {功能名} - 需求文档

   > 来源：{PRD/用户反馈}
   > 编号：{REQ-XXX}
   > 优先级：{P0/P1/P2/P3}

   ## 背景
   {为什么需要这个功能}

   ## 用户故事
   - 作为 {角色}，我希望 {做什么}，以便 {达成什么}

   ## 验收标准
   - [ ] {标准1}
   - [ ] {标准2}
   ```

   **`docs/technical/{name}.md`**：技术文档
   ```markdown
   # {功能名} - 技术方案

   ## 方案对比
   | 方案 | 优点 | 缺点 |
   |------|------|------|
   | 方案A | ... | ... |

   ## 推荐方案
   {选择哪个方案，为什么}

   ## 风险点
   - ⚠️ {风险1}
   ```

   **`docs/testing/{name}.md`**：测试文档
   ```markdown
   # {功能名} - 测试报告

   ## 测试用例
   | 编号 | 用例描述 | 预期 | 实际 | 状态 |
   |------|----------|------|------|------|

   ## 测试结论
   - 通过率：{%}
   - 是否可发布：{是/否}
   ```

   **`docs/design/{name}.md`**：设计文档
   ```markdown
   # {功能名} - 设计稿

   ## 设计稿链接
   {Figma URL}

   ## 设计规范
   - 主色：{#hex}
   - 字体：{字体}
   ```

   **`docs/other/{name}.md`**：其他文档
   ```markdown
   # {会议/讨论主题} - 纪要

   ## 讨论议题
   ## 决议
   ## 待办
   ```

## 步骤 2：生成变更记录

**⚠️ 关键要求：**

1. **6 个核心文档必须全部生成**（overview/files/technical/impact/testing/deployment），不能跳过
2. **docs/ 子目录按需生成**：只有用户实际提供了对应文档时才生成对应子目录，不要凭空捏造
3. **overview.md 的"标题"必须具体**：如"添加用户登录功能"，**不能只写 feat/fix**

创建迭代文件夹 `.ai-context/changelog/{YYYY-MM-DD-HHMMSS}-{变更标识}/`，包含以下 6 个核心文档：

1. **overview.md** - 变更概述（背景、目的、类型）
   - 标题必须具体描述本次变更做了什么
   - 需求文档引用放"需求背景"部分
2. **files.md** - 文件清单（代码、配置、文档）
   - 按模块分类
   - 列出所有变更文件
3. **technical.md** - 技术细节（核心变更、技术决策）
   - 核心代码变更前后对比
   - 技术决策的备选方案和选择理由
   - 技术文档引用放"技术文档"部分
4. **impact.md** - 影响范围（功能、性能、安全、兼容性）
   - 功能模块影响矩阵
   - 风险点和规避方案
5. **testing.md** - 测试验证（单元测试、集成测试、手动测试）
   - 测试用例执行结果
   - 测试报告引用放"测试报告"部分
6. **deployment.md** - 部署信息（部署要求、验证步骤、回滚方案）
   - 部署步骤
   - 回滚方案

详细模板和完整示例请参考 SKILL.md 中的"完整填入的 Changelog 示例"。

## 步骤 3：更新 changelog 索引

**⚠️ 关键要求：变更历史表格的"标题"列必须填写具体变更标题（如"添加用户登录功能"），不能只填类型（feat/fix）。**

**更新 `changelog/README.md` 索引文件：**

1. 读取现有的 `changelog/README.md`
2. 更新变更统计数据（总变更次数、各类型数量）
3. **在"变更历史"表格中添加新记录**（注意每列的填写规则）：

   | 列名 | 必填 | 填写内容 | 示例 |
   |------|------|----------|------|
   | 日期 | 是 | 变更日期 | 2026-06-16 |
   | 标题 | 是 | **具体变更标题**（不能只填类型） | 添加智能助手命令 |
   | 描述 | 是 | 变更详细说明 | 新增 /docs 统一入口 |
   | 类型 | 是 | feat/fix/refactor/docs/chore/perf/test/ci | feat |
   | 模块 | 是 | 影响的模块名 | commands |
   | 作者 | 是 | 作者名 | AI / 用户名 |
   | 状态 | 是 | done/in-progress/reverted | done |
   | 详情 | 是 | 链接到迭代文件夹 | [查看](./2026-06-16-143000-smart-assistant/) |

4. 更新"按模块统计"和"按类型统计"

## 步骤 4：更新相关文档

**必须检查并更新以下所有相关文档：**

- 模块文档（`modules/{模块}.md`）
- API 文档（`api/{模块}.md`）
- 数据库文档（`database/README.md`）
- 中间件文档（`middleware/README.md`）
- 架构文档（`architecture.md`）
- 编码规范（`guidelines/coding-style.md`）

## 步骤 5：输出归档摘要

```
✅ 归档完成！

---

## 📝 变更记录

**文件夹**: .ai-context/changelog/{日期}-{标识}/
**标题**: {具体变更标题，如"添加用户登录功能"}
**类型**: {feat/fix/refactor}
**概述**: {变更概述}

---

## 📄 更新的文档

| 文档 | 更新内容 | 更新原因 |
|------|----------|----------|
| changelog/README.md | 更新变更统计 | 新增变更记录 |
| modules/auth.md | 新增登录接口说明 | 新增了 AuthController.login() |

---

## 📊 变更统计

| 维度 | 数量 |
|------|------|
| 修改文件 | {数量} |
| 新增文件 | {数量} |
| 删除文件 | {数量} |
| 影响模块 | {数量} |
| 更新文档 | {数量} |

---

✅ 所有文档已同步，可以提交代码！
```
