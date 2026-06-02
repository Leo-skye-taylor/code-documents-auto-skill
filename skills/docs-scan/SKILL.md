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

1. `.ai-context/README.md` - 项目概览
2. `.ai-context/architecture.md` - 系统架构
3. `.ai-context/modules/` - 模块文档
4. `.ai-context/api/` - API 文档
5. `.ai-context/guidelines/` - 编码规范
6. `.ai-context/changelog/` - 变更记录（文件夹结构）
7. `.ai-context/decisions/` - 技术决策
8. `.ai-context/database/` - 数据库设计
9. `.ai-context/middleware/` - 中间件使用

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
│   └── docs/                              # 用户提供的文档（可选）
│       ├── requirements/                  # 需求文档
│       ├── technical/                     # 技术文档
│       ├── testing/                       # 测试报告
│       ├── design/                        # 设计文档
│       └── other/                         # 其他文档
└── dev-cycles/                            # 开发周期记录（可选）
```

## 第九步：处理 CLAUDE.md 和 AGENTS.md

**检查项目根目录是否已存在 CLAUDE.md 或 AGENTS.md：**

**情况 A：文件已存在**
- 在现有文件末尾追加工作流引导信息
- 不覆盖原有内容

**情况 B：文件不存在**
- 根据项目实际情况生成完整的 CLAUDE.md 和 AGENTS.md

## 第十步：输出扫描摘要

扫描完成后，输出：

```
✅ 文档生成完成！

已生成的文档：
- .ai-context/README.md - 项目概览
- .ai-context/architecture.md - 系统架构
- .ai-context/modules/{模块1}.md - {模块1}模块文档
- .ai-context/modules/{模块2}.md - {模块2}模块文档
- .ai-context/api/{API1}.md - {API1}接口文档
- .ai-context/database/README.md - 数据库设计
- .ai-context/middleware/README.md - 中间件使用
- .ai-context/guidelines/coding-style.md - 编码规范
- .ai-context/changelog/README.md - 变更索引
- .ai-context/changelog/{日期}-initial-scan/ - 初始扫描记录
- CLAUDE.md - 工作流规则（新建/已更新）
- AGENTS.md - AI Agent 行为规则（新建/已更新）

文档质量说明：
- 所有文档基于 AI 对代码的理解生成
- 包含真实的业务逻辑分析
- 包含完整的接口文档
- 包含详细的数据库设计和中间件使用说明

使用方法：
- 开发前：/code-documents-auto <任务描述>
- 开发后：/code-documents-auto 归档
```
