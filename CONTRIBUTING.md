# Contributing Guide

[English](#english) | [中文](#中文)

---

## English

Thank you for your interest in contributing to Code Documents Auto Skill! 🎉

### How to Contribute

#### 🐛 Report Bugs

1. Check [existing issues](https://github.com/trainMini/code-documents-auto-skill/issues) first
2. Create a new issue with:
   - Clear title
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment info (OS, Claude Code version)

#### 💡 Suggest Features

1. Open a [discussion](https://github.com/trainMini/code-documents-auto-skill/discussions)
2. Describe the feature and use case
3. Wait for feedback before implementing

#### 🔧 Submit Code

1. **Fork** the repository
2. **Clone** your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/code-documents-auto-skill.git
   cd code-documents-auto-skill
   ```
3. **Create** a branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Make** your changes
5. **Test** thoroughly
6. **Commit** with clear message:
   ```bash
   git commit -m "feat: add new feature description"
   ```
7. **Push** to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
8. **Open** a Pull Request

### Code Standards

#### Shell Scripts

- Use `#!/bin/bash` shebang
- Add comments for complex logic
- Use `set -e` for error handling (where appropriate)
- Quote variables: `"$variable"`
- Use shellcheck for validation

#### Commit Messages

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance

**Examples:**
```
feat(skill): add new command support
fix(archive): correct changelog filename
docs(readme): update installation guide
```

### Testing

Before submitting:

1. Verify workflow works end-to-end
2. Check for syntax errors:
   ```bash
   shellcheck scripts/*.sh
   ```

### Pull Request Guidelines

- Keep PRs focused (one feature/fix per PR)
- Write clear PR description
- Reference related issues
- Ensure all checks pass
- Request review from maintainers

### Questions?

Open an [issue](https://github.com/trainMini/code-documents-auto-skill/issues) or start a [discussion](https://github.com/trainMini/code-documents-auto-skill/discussions).

---

## 中文

感谢你对 Code Documents Auto Skill 的贡献兴趣！🎉

### 如何贡献

#### 🐛 报告 Bug

1. 先查看[已有 Issues](https://github.com/trainMini/code-documents-auto-skill/issues)
2. 创建新 Issue，包含：
   - 清晰的标题
   - 复现步骤
   - 期望行为 vs 实际行为
   - 环境信息（操作系统、Claude Code 版本）

#### 💡 建议功能

1. 开启[讨论](https://github.com/trainMini/code-documents-auto-skill/discussions)
2. 描述功能和使用场景
3. 等待反馈后再实现

#### 🔧 提交代码

1. **Fork** 仓库
2. **克隆**你的 Fork：
   ```bash
   git clone https://github.com/你的用户名/code-documents-auto-skill.git
   cd code-documents-auto-skill
   ```
3. **创建**分支：
   ```bash
   git checkout -b feature/你的功能名
   ```
4. **修改**代码
5. **测试**确保正常
6. **提交**清晰的 commit 信息：
   ```bash
   git commit -m "feat: 添加新功能描述"
   ```
7. **推送**到你的 Fork：
   ```bash
   git push origin feature/你的功能名
   ```
8. **发起** Pull Request

### 代码规范

#### Shell 脚本

- 使用 `#!/bin/bash` shebang
- 复杂逻辑添加注释
- 适当使用 `set -e` 处理错误
- 变量加引号：`"$variable"`
- 使用 shellcheck 验证

#### Commit 信息

遵循 [Conventional Commits](https://www.conventionalcommits.org/)：

```
<类型>(<范围>): <描述>

[可选正文]

[可选脚注]
```

**类型：**
- `feat`：新功能
- `fix`：修复 Bug
- `docs`：文档
- `style`：格式调整
- `refactor`：代码重构
- `test`：添加测试
- `chore`：维护

**示例：**
```
feat(skill): 添加新命令支持
fix(archive): 修复 changelog 文件名
docs(readme): 更新安装指南
```

### 测试

提交前：

1. 验证端到端工作流
2. 检查语法错误：
   ```bash
   shellcheck scripts/*.sh
   ```

### Pull Request 指南

- 保持 PR 聚焦（一个 PR 一个功能/修复）
- 写清楚 PR 描述
- 引用相关 Issue
- 确保所有检查通过
- 请求维护者审查

### 有问题？

创建 [Issue](https://github.com/trainMini/code-documents-auto-skill/issues) 或开启[讨论](https://github.com/trainMini/code-documents-auto-skill/discussions)。

---

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

参与贡献即表示你的贡献将使用 MIT 许可证。
