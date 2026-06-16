---
name: docs-scan
description: >
  全量扫描代码库，生成完整的项目文档。首次使用或重大重构后运行。
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - Agent
  - WebFetch
---

# /docs-scan — 全量扫描生成文档

**当用户输入 `/docs-scan` 时，你必须执行以下完整流程：**

## 前置检查

检查 `.ai-context/` 是否已存在：
- 如果已存在，询问用户：
  - 选择 `全量重新生成` - 覆盖所有文档
  - 选择 `增量更新` - 只更新变更部分（建议）
  - 选择 `取消` - 不执行任何操作
- 如果不存在，执行全量扫描

## 第一步：扫描项目结构

使用 Bash 工具执行以下命令，了解项目整体结构：

```bash
# 查看根目录
ls -la

# 查看目录树（排除无关目录）
find . -maxdepth 3 -type d \
  -not -path '*/node_modules/*' \
  -not -path '*/.git/*' \
  -not -path '*/__pycache__/*' \
  -not -path '*/vendor/*' \
  -not -path '*/dist/*' \
  -not -path '*/build/*' \
  -not -path '*/target/*' \
  -not -path '*/.ai-context/*' | sort
```

## 第二步：识别项目类型

检查以下文件来判断项目类型：

| 文件 | 项目类型 |
|------|----------|
| package.json | Node.js/TypeScript |
| requirements.txt / pyproject.toml / setup.py | Python |
| pom.xml / build.gradle | Java |
| go.mod | Go |
| Cargo.toml | Rust |

## 第二步半：判断项目分类

在识别项目类型后，**进一步判断项目分类**，决定是否需要生成数据库和中间件文档：

| 项目分类 | 识别规则 | 文档范围 |
|----------|----------|----------|
| **纯前端** | 仅包含前端框架（react/vue/angular/svelte/next/nuxt/sveltekit/solid-js/preact），无后端框架（express/koa/fastify/nestjs/egg），无数据库依赖 | 跳过 database/ 和 middleware/ 文档 |
| **纯后端** | 仅包含后端框架，无前端框架 | 生成所有文档 |
| **全栈** | 同时包含前端和后端框架 | 生成所有文档 |
| **库/工具** | 仅包含工具库，无 UI 框架 | 跳过 database/，按需生成 middleware/ |
| **桌面/移动** | 包含 electron/tauri/react-native/uniapp/ionic | 跳过 database/ 和 middleware/（按需） |

**前端框架识别（满足任一即为前端项目）：**

| 框架 | 识别特征（package.json dependencies） |
|------|--------------------------------------|
| React | `react`, `react-dom` |
| Vue | `vue`, `nuxt` |
| Angular | `@angular/core` |
| Svelte | `svelte`, `@sveltejs/kit` |
| Solid | `solid-js` |
| Preact | `preact` |
| Next.js | `next` |
| Remix | `@remix-run/react` |

**数据库依赖识别（无以下依赖 = 无数据库）：**

`mysql`, `mysql2`, `pg`, `mongoose`, `sequelize`, `prisma`, `typeorm`, `knex`, `mongodb`, `redis`, `ioredis`, `drizzle-orm`

**后端服务依赖识别（无以下依赖 = 无后端服务）：**

`express`, `koa`, `fastify`, `@nestjs/core`, `egg`, `hapi`, `restify`, `polka`, `micro`

**判定结果记录：**

将项目分类记录到扫描上下文中，后续步骤根据分类决定是否执行：

```
项目分类：{纯前端/纯后端/全栈/库/桌面移动}
是否生成 database/ 文档：{是/否}
是否生成 middleware/ 文档：{是/否}
```

## 第三步：读取关键文件

根据项目类型，读取以下文件：

**所有项目：**
- 读取 README.md（如果存在）
- 读取配置文件（package.json, pom.xml 等）

**Node.js 项目：**
- 读取 package.json（获取依赖、脚本、项目描述）
- 读取 tsconfig.json（如果存在）
- 读取入口文件（src/index.ts, src/main.ts 等）

**Java 项目：**
- 读取 pom.xml 或 build.gradle（获取依赖）
- 读取 application.yml 或 application.properties（获取配置）
- 读取主启动类

**Python 项目：**
- 读取 requirements.txt 或 pyproject.toml
- 读取 main.py 或 app.py

## 第四步：分析代码模块

使用 Glob 工具查找代码文件：

```
# Node.js/TypeScript
**/*.ts, **/*.tsx, **/*.js, **/*.jsx

# Java
**/*.java

# Python
**/*.py
```

对每个模块目录，读取其核心文件，理解：
- 这个模块做什么
- 有哪些核心类/函数
- 对外暴露什么接口
- 依赖什么其他模块

## 第五步：分析数据库模块

**⚠️ 条件执行**：仅当第二步半判定"是否生成 database/ 文档"为**是**时执行此步骤。

**如果是纯前端项目且无数据库依赖，跳过此步骤。**

**识别数据库类型和配置：**

| 文件/依赖 | 数据库类型 |
|-----------|-----------|
| mysql-connector, pg, mysql2 | 关系型数据库 |
| mongoose, prisma, typeorm, sequelize | ORM/ODM |
| redis, ioredis | 缓存数据库 |
| mongodb, MongoClient | 文档数据库 |
| application.yml 中的 datasource.* | Spring 数据源配置 |

**分析内容：**

1. **数据模型/实体**
   - 查找 Entity、Model、Schema 定义文件
   - 读取每个实体的字段定义和类型
   - 识别实体间关系（一对一、一对多、多对多）

2. **数据库配置**
   - 读取数据库连接配置
   - 识别连接池设置
   - 查找迁移/种子文件

3. **数据访问层**
   - 查找 Repository、DAO、Mapper 文件
   - 分析 CRUD 操作实现
   - 识别复杂查询和索引

4. **生成数据库文档**

创建 `.ai-context/database/README.md`

## 第六步：分析中间件使用

**⚠️ 条件执行**：仅当第二步半判定"是否生成 middleware/ 文档"为**是**时执行此步骤。

**如果是纯前端项目且无后端服务依赖，跳过此步骤。**

**识别中间件类型：**

| 文件/依赖 | 中间件类型 |
|-----------|-----------|
| express, koa, fastify | Web 框架中间件 |
| cors, helmet, compression | HTTP 中间件 |
| jsonwebtoken, passport | 认证中间件 |
| winston, pino, morgan | 日志中间件 |
| bull, agenda, bullmq | 任务队列 |
| socket.io, ws | WebSocket |
| axios, node-fetch | HTTP 客户端 |
| dotenv, config | 配置管理 |

**Java 项目中间件：**

| 依赖/配置 | 中间件类型 |
|-----------|-----------|
| spring-boot-starter-data-redis | Redis |
| spring-boot-starter-amqp | RabbitMQ |
| spring-kafka | Kafka |
| spring-boot-starter-mail | 邮件服务 |
| spring-boot-starter-websocket | WebSocket |
| @Scheduled, @EnableScheduling | 定时任务 |

## 第七步：分析 API 路由

读取路由/控制器文件，识别所有 API 端点：
- HTTP 方法（GET, POST, PUT, DELETE）
- 路径（/api/users, /chat 等）
- 请求参数和响应格式

## 第八步：生成文档

使用 Write 工具创建以下文档：

**通用文档（所有项目都生成）：**
1. `.ai-context/README.md` - 项目概览
2. `.ai-context/architecture.md` - 系统架构
3. `.ai-context/modules/` - 模块文档
4. `.ai-context/guidelines/` - 编码规范
5. `.ai-context/changelog/` - 变更记录（文件夹结构）
6. `.ai-context/decisions/` - 技术决策

**条件文档（按项目分类生成）：**
7. `.ai-context/api/` - API 文档（仅当有后端服务时生成）
8. `.ai-context/database/` - 数据库设计（仅当第二步半判定为"是"时生成）
9. `.ai-context/middleware/` - 中间件使用（仅当第二步半判定为"是"时生成）

### Changelog 文件夹结构

```
.ai-context/changelog/
├── README.md                              # 总索引
├── {YYYY-MM-DD-HHMMSS}-initial-scan/    # 初始扫描文件夹
│   ├── overview.md                        # 变更概述
│   ├── files.md                           # 文件清单
│   ├── technical.md                       # 技术细节
│   ├── impact.md                          # 影响范围
│   ├── testing.md                         # 测试验证
│   ├── deployment.md                      # 部署信息
│   └── docs/                              # 用户提供的文档（可选，按下方逻辑创建）
│       ├── requirements/                  # 需求文档
│       ├── technical/                     # 技术文档
│       ├── testing/                       # 测试报告
│       ├── design/                        # 设计文档
│       └── other/                         # 其他文档
└── dev-cycles/                            # 开发周期记录（可选）
```

## 第八步半：检测并归类项目已有文档

**目的**：在创建 `initial-scan/docs/` 之前，扫描项目中已有的 .md 文档，询问用户是否归类到 docs/ 子目录。

> ⚠️ 如果用户**拒绝归类**，则**不创建 docs/ 子目录**（保持空状态）。

### 8.5.1 扫描项目已有文档

使用 Glob 工具查找项目下所有 .md 文件（排除 `.ai-context/`、`.git/`、`node_modules/` 等）：

```bash
# 查找项目下所有 .md 文件
find . -type f -name "*.md" \
  -not -path "./.ai-context/*" \
  -not -path "./.git/*" \
  -not -path "./node_modules/*" \
  -not -path "./dist/*" \
  -not -path "./build/*" \
  -not -path "./.claude/*" | sort
```

### 8.5.2 自动归类建议

对每个找到的 .md 文件，根据**文件名关键词**和**内容前 200 字符**进行智能归类：

| 关键词（文件名或内容） | 归类到 |
|------------------------|--------|
| `requirement`、`prd`、`需求`、`用户故事`、`user story` | `docs/requirements/` |
| `technical`、`design`、`架构`、`技术方案`、`api`、`database schema` | `docs/technical/` |
| `test`、`testing`、`测试`、`qa`、`测试报告`、`test report` | `docs/testing/` |
| `design`、`ui`、`mockup`、`prototype`、`figma`、`设计稿` | `docs/design/` |
| `meeting`、`notes`、`会议`、`纪要`、`readme`、`参考`、`info` | `docs/other/` |
| 其他无法识别 | `docs/other/`（默认） |

### 8.5.3 询问用户

**使用 AskUserQuestion 工具询问：**

```
检测到项目下有 N 个 .md 文档，建议归类如下：

📂 requirements/ (X 个)
   - docs/PRD.md
   - docs/user-stories.md

📂 technical/ (Y 个)
   - docs/architecture.md
   - docs/api-design.md

📂 testing/ (Z 个)
   - docs/test-report.md

📂 design/ (A 个)
   - docs/ui-mockup.md

📂 other/ (B 个)
   - README.md
   - docs/meeting-notes.md

是否将这些文档归类到 .ai-context/changelog/{date}-initial-scan/docs/ 下？
```

**用户选项：**

| 选项 | 行为 |
|------|------|
| ✅ 全部归类 | 复制所有文档到对应 docs/ 子目录 |
| 🔧 部分归类 | 用户选择具体哪些要归类 |
| ❌ 不归类 | 不创建 docs/ 子目录 |

### 8.5.4 执行归类（如用户同意）

```bash
# 创建 docs/ 子目录结构
mkdir -p .ai-context/changelog/{date}-initial-scan/docs/{requirements,technical,testing,design,other}

# 按归类复制文件
cp docs/PRD.md .ai-context/changelog/{date}-initial-scan/docs/requirements/
cp docs/architecture.md .ai-context/changelog/{date}-initial-scan/docs/technical/
cp docs/test-report.md .ai-context/changelog/{date}-initial-scan/docs/testing/
cp docs/ui-mockup.md .ai-context/changelog/{date}-initial-scan/docs/design/
cp README.md .ai-context/changelog/{date}-initial-scan/docs/other/
```

### 8.5.5 跳过归类（如用户拒绝）

- **不创建** `.ai-context/changelog/{date}-initial-scan/docs/` 目录
- 在 `overview.md` 中注明"用户已有文档但未归类"
- 提示用户：未来可用 `/docs-archive` 时手动归类

## 第九步：处理 CLAUDE.md 和 AGENTS.md

**检查项目根目录是否已存在 CLAUDE.md 或 AGENTS.md：**

**情况 A：文件已存在**
- 在现有文件末尾追加工作流引导信息
- 不覆盖原有内容

**情况 B：文件不存在**
- 根据项目实际情况生成完整的 CLAUDE.md 和 AGENTS.md

## 第十步：输出扫描摘要

扫描完成后，**根据实际生成情况动态输出摘要**：

```
✅ 文档生成完成！

项目分类：{纯前端/纯后端/全栈/库/桌面移动}

已生成的文档：
- .ai-context/README.md - 项目概览
- .ai-context/architecture.md - 系统架构
- .ai-context/modules/{模块1}.md - {模块1}模块文档
- .ai-context/modules/{模块2}.md - {模块2}模块文档
- .ai-context/guidelines/coding-style.md - 编码规范
- .ai-context/changelog/README.md - 变更索引
- .ai-context/changelog/{日期}-initial-scan/ - 初始扫描记录
- CLAUDE.md - 工作流规则（新建/已更新）
- AGENTS.md - AI Agent 行为规则（新建/已更新）
- .ai-context/decisions/{决策}.md - 技术决策
{以下文档仅在条件满足时显示}
- .ai-context/api/{API1}.md - {API1}接口文档  ← 仅当有后端服务时
- .ai-context/database/README.md - 数据库设计  ← 仅当涉及数据库时
- .ai-context/middleware/README.md - 中间件使用  ← 仅当涉及中间件时

文档质量说明：
- 所有文档基于 AI 对代码的理解生成
- 包含真实的业务逻辑分析
- 根据项目分类自动跳过不相关的文档（如纯前端项目不生成数据库文档）

使用方法：
- 开发前：/docs-prepare <任务描述>
- 开发后：/docs-archive
```
