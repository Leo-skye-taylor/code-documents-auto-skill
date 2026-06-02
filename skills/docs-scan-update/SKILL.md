---
name: docs-scan-update
description: >
  增量更新文档，只更新变更部分。日常开发后运行，比全量扫描更快。
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Agent
---

# /docs-scan-update — 增量更新文档

**当用户输入 `/docs-scan-update` 时，你必须执行增量更新流程：**

## 前置检查

- 检查 `.ai-context/` 目录是否存在
- 如果不存在，提示用户先运行 `/docs-scan` 进行全量扫描

## 步骤 1：检测变更

```bash
# 获取变更文件
git diff --name-status HEAD~10

# 查看未跟踪的新文件
git ls-files --others --exclude-standard
```

## 步骤 2：分析变更影响

根据变更文件，确定需要更新的文档：

| 变更文件类型 | 需要更新的文档 |
|-------------|---------------|
| Entity/Model 文件 | database/README.md, modules/{模块}.md |
| Repository/DAO 文件 | database/README.md, modules/{模块}.md |
| Controller 文件 | api/{模块}.md, modules/{模块}.md |
| Service 文件 | modules/{模块}.md |
| 中间件配置 | middleware/README.md |
| 配置文件 | README.md（如果技术栈变化） |
| 架构相关文件 | architecture.md |

## 步骤 3：增量更新文档

**只更新受影响的文档，不重新生成未变化的文档：**

1. **读取现有文档** - 读取需要更新的文档的当前内容
2. **分析变更内容** - 理解代码变更的具体内容
3. **更新文档内容** - 只修改受影响的部分，保留其他内容
4. **写入更新后的文档** - 使用 Write 工具覆盖更新

## 步骤 4：创建变更记录

创建 `changelog/{YYYY-MM-DD-HHMMSS}-incremental-update/` 文件夹，包含：
- overview.md - 变更概述
- files.md - 文件清单
- technical.md - 技术细节
- impact.md - 影响范围
- testing.md - 测试验证
- deployment.md - 部署信息
- docs/ - 用户提供的文档（可选）

更新 `changelog/README.md` 索引文件。

## 步骤 5：输出增量更新摘要

```
✅ 增量更新完成！

---

## 变更检测

| 变更类型 | 文件数 |
|----------|--------|
| 修改 | {数量} |
| 新增 | {数量} |
| 删除 | {数量} |

---

## 更新的文档

| 文档 | 更新原因 | 更新内容 |
|------|----------|----------|
| modules/auth.md | 修改了 AuthController | 新增了 login() 方法说明 |
| api/chat.md | 新增了流式接口 | 新增了 /chat/stream 接口文档 |

---

## 未更新的文档（无变更）

- architecture.md - 无架构变化
- database/README.md - 无数据模型变化

---

✅ 文档已同步到最新状态！
```

## 注意事项

- 增量更新不会删除文档，只会添加或修改
- 如果变更涉及架构级别的调整，建议使用全量扫描
- 增量更新会保留手动添加的文档内容
- 如果检测不到变更，提示用户确认是否需要全量扫描
