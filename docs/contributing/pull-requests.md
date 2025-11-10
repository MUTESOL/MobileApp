# Pull Request Process

Guidelines for contributing code to StackSave.

## Before You Start

### 1. Check Existing Work

- Search [open pull requests](https://github.com/MUT-TANT/MobileApp/pulls)
- Review [project roadmap](https://github.com/MUT-TANT/MobileApp/projects)
- Check [issues](https://github.com/MUT-TANT/MobileApp/issues) for planned work

### 2. Discuss Major Changes

For significant features:
1. Open an issue first
2. Discuss approach with maintainers
3. Get approval before coding

---

## Development Workflow

### 1. Fork and Clone

```bash
# Fork repository on GitHub

# Clone your fork
git clone https://github.com/MUT-TANT/MobileApp.git
cd stacksave

# Add upstream remote
git remote add upstream https://github.com/MUT-TANT/MobileApp.git
```

### 2. Create Branch

```bash
# Update main branch
git checkout main
git pull upstream main

# Create feature branch
git checkout -b feature/your-feature-name

# Or for bugfix
git checkout -b fix/bug-description
```

**Branch Naming**:
- `feature/` - New features
- `fix/` - Bug fixes
- `docs/` - Documentation
- `refactor/` - Code refactoring
- `test/` - Adding tests

### 3. Make Changes

Follow our [Code Style Guide](../development/code-style.md):

```bash
# Format code
dart format .

# Run linter
flutter analyze

# Run tests
flutter test
```

### 4. Commit Changes

```bash
# Stage changes
git add .

# Commit with meaningful message
git commit -m "feat(goals): add goal completion animation"
```

**Commit Message Format**:
```
type(scope): subject

body

footer
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Formatting
- `refactor`: Code restructuring
- `test`: Tests
- `chore`: Maintenance

### 5. Push Branch

```bash
git push origin feature/your-feature-name
```

### 6. Create Pull Request

1. Go to your fork on GitHub
2. Click "Pull Request"
3. Fill in the PR template
4. Submit PR

---

## Pull Request Template

```markdown
## Description
Brief description of changes.

## Related Issue
Fixes #123

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Changes Made
- Added goal completion animation
- Updated tests
- Updated documentation

## Screenshots
(If applicable)

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Manual testing completed
- [ ] All tests passing

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests added/updated
- [ ] All tests pass
```

---

## Review Process

### What Reviewers Look For

1. **Code Quality**
   - Follows style guide
   - Well-structured and readable
   - No unnecessary complexity

2. **Functionality**
   - Works as intended
   - No bugs introduced
   - Edge cases handled

3. **Tests**
   - Adequate test coverage
   - Tests are meaningful
   - All tests pass

4. **Documentation**
   - Code is documented
   - User-facing docs updated
   - Breaking changes noted

### Addressing Feedback

```bash
# Make requested changes
git add .
git commit -m "fix: address review feedback"
git push origin feature/your-feature-name
```

PR updates automatically!

---

## Requirements for Merging

### Must Have ✅

- [ ] All tests passing
- [ ] No merge conflicts
- [ ] At least one approval
- [ ] CI/CD checks passing
- [ ] Documentation updated
- [ ] No violations of Code of Conduct

### Nice to Have 🌟

- Multiple approvals
- Performance improvements
- Additional tests
- Examples/demos

---

## After Your PR is Merged

### Cleanup

```bash
# Switch to main
git checkout main

# Pull latest
git pull upstream main

# Delete local branch
git branch -d feature/your-feature-name

# Delete remote branch (optional)
git push origin --delete feature/your-feature-name
```

### Celebrate! 🎉

Your contribution is now part of StackSave!

---

## PR Best Practices

### Do's ✅

1. **Keep PRs Small**
   - Focus on one feature/fix
   - Easier to review
   - Faster to merge

2. **Write Good Descriptions**
   - Explain what and why
   - Reference related issues
   - Include screenshots if UI changes

3. **Test Thoroughly**
   - Add tests for new code
   - Run full test suite
   - Test manually

4. **Be Responsive**
   - Respond to review comments
   - Make requested changes promptly
   - Ask questions if unclear

5. **Keep Updated**
   - Regularly sync with main
   - Resolve conflicts promptly
   - Rebase if needed

### Don'ts ❌

1. **Don't Submit Untested Code**
   - Always run tests
   - Fix failing tests
   - Don't rely on CI for testing

2. **Don't Include Unrelated Changes**
   - Stay focused
   - One concern per PR
   - No formatting-only changes mixed with logic

3. **Don't Take Feedback Personally**
   - Reviews improve code quality
   - Learn from feedback
   - Ask questions

4. **Don't Force Push**
   - Avoid `git push --force`
   - Preserves review history
   - Use `--force-with-lease` if absolutely necessary

5. **Don't Ignore CI Failures**
   - Fix failing checks
   - Don't expect maintainers to fix them

---

## Special Cases

### Documentation PRs

- Don't need tests
- Should include preview if possible
- Check for typos and grammar

### Dependency Updates

- Explain why update is needed
- Note any breaking changes
- Update lockfile
- Test thoroughly

### Breaking Changes

- Clearly mark as breaking
- Update changelog
- Provide migration guide
- Discuss with maintainers first

---

## Getting Help

### Stuck?

- Comment on your PR
- Ask in [Discussions](https://github.com/MUT-TANT/MobileApp/discussions)
- Tag maintainers (use sparingly)

### Need Review?

- Be patient (maintainers are volunteers)
- Politely ping after 1 week
- Ensure all checks are passing

---

## Example Workflow

```bash
# 1. Setup
git clone https://github.com/MUT-TANT/MobileApp.git
cd stacksave
git remote add upstream https://github.com/MUT-TANT/MobileApp.git

# 2. Create branch
git checkout -b feature/add-goal-categories

# 3. Make changes
# ... code ...

# 4. Test
dart format .
flutter analyze
flutter test

# 5. Commit
git add .
git commit -m "feat(goals): add customizable goal categories"

# 6. Push
git push origin feature/add-goal-categories

# 7. Create PR on GitHub

# 8. Address feedback
# ... make changes ...
git add .
git commit -m "fix: address review comments"
git push origin feature/add-goal-categories

# 9. After merge
git checkout main
git pull upstream main
git branch -d feature/add-goal-categories
```

---

## Next Steps

- [How to Contribute](how-to-contribute.md)
- [Code of Conduct](code-of-conduct.md)
- [Code Style Guide](../development/code-style.md)

---

Thank you for contributing to StackSave! 🙏
