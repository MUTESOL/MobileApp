# Reporting Issues

Help us improve StackSave by reporting bugs and suggesting features.

## Before Creating an Issue

### Search Existing Issues

1. Check [existing issues](https://github.com/MUT-TANT/MobileApp/issues)
2. Search [closed issues](https://github.com/MUT-TANT/MobileApp/issues?q=is%3Aissue+is%3Aclosed)
3. Review [discussions](https://github.com/MUT-TANT/MobileApp/discussions)

### Try Latest Version

Ensure you're using the latest version:
```bash
git pull origin main
flutter pub get
flutter run
```

---

## Bug Reports

### Bug Report Template

```markdown
## Bug Description
A clear and concise description of the bug.

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

## Expected Behavior
What you expected to happen.

## Actual Behavior
What actually happened.

## Screenshots
If applicable, add screenshots.

## Environment
- Device: [e.g. iPhone 14 Pro, Pixel 7]
- OS: [e.g. iOS 16.0, Android 13]
- App Version: [e.g. 1.0.0]
- Flutter Version: [e.g. 3.10.0]
- Network: [e.g. Ethereum Mainnet]

## Additional Context
Any other information about the problem.

## Logs
```
Paste relevant logs here
```
```

### Example Bug Report

```markdown
## Bug Description
App crashes when withdrawing from a completed goal.

## Steps to Reproduce
1. Create a savings goal
2. Deposit until goal is 100% complete
3. Tap on the goal
4. Tap "Withdraw"
5. Enter amount and confirm
6. App crashes

## Expected Behavior
Should process withdrawal normally.

## Actual Behavior
App crashes with error: "Null check operator used on a null value"

## Environment
- Device: iPhone 14 Pro
- OS: iOS 16.2
- App Version: 1.0.0
- Network: Ethereum Mainnet

## Logs
```
[ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception:
Null check operator used on a null value
#0 GoalDetailsScreen._processWithdrawal
```
```

---

## Feature Requests

### Feature Request Template

```markdown
## Feature Description
A clear description of the feature you'd like.

## Problem it Solves
Explain the problem this feature would solve.

## Proposed Solution
How do you envision this feature working?

## Alternatives Considered
Other solutions you've thought about.

## Additional Context
Any other context, mockups, or examples.

## Willingness to Contribute
[ ] I can help implement this feature
[ ] I can help test this feature
[ ] I can help document this feature
```

### Example Feature Request

```markdown
## Feature Description
Add support for recurring deposits (auto-save).

## Problem it Solves
Users have to manually deposit each time. Recurring deposits would automate savings and improve user engagement.

## Proposed Solution
1. Add "Schedule Recurring Deposit" option in goal details
2. Let users choose frequency (daily, weekly, monthly)
3. Execute deposits automatically using blockchain automation

## Alternatives Considered
- Push notifications reminding users to deposit
- Integration with salary deposits

## Additional Context
Many traditional savings apps have this feature. It's especially useful for consistent savers.

## Willingness to Contribute
[x] I can help implement this feature
[ ] I can help test this feature
[x] I can help document this feature
```

---

## Security Issues

### DO NOT create public issues for security vulnerabilities!

**Instead**:

1. Email: security@stacksave.io
2. Include:
   - Description of vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

We will respond within 48 hours and work with you to resolve the issue.

---

## Issue Labels

### Bug Labels
- `bug` - Something isn't working
- `critical` - Critical bug, needs immediate attention
- `regression` - Previously working feature is broken

### Feature Labels
- `feature` - New feature request
- `enhancement` - Improvement to existing feature
- `ui/ux` - User interface/experience improvement

### Priority Labels
- `priority: high` - High priority
- `priority: medium` - Medium priority
- `priority: low` - Low priority

### Status Labels
- `needs-info` - More information needed
- `needs-triage` - Needs to be reviewed
- `confirmed` - Bug confirmed
- `wontfix` - Will not be fixed
- `duplicate` - Duplicate of another issue

### Platform Labels
- `android` - Android specific
- `ios` - iOS specific
- `web` - Web specific

---

## Issue Guidelines

### Do's ✅

- **Be specific**: Provide detailed information
- **Be respectful**: Follow the Code of Conduct
- **Be patient**: Maintainers are volunteers
- **Test first**: Try to reproduce on latest version
- **Search first**: Check for existing issues
- **One issue per report**: Don't combine multiple bugs

### Don'ts ❌

- **Don't demand**: Be polite in your requests
- **Don't spam**: Avoid "+1" comments, use reactions instead
- **Don't hijack**: Stay on topic
- **Don't share secrets**: Never post private keys or passwords
- **Don't be vague**: Provide enough detail to reproduce

---

## After Reporting

### What Happens Next

1. **Triage**: Maintainers review and label your issue
2. **Discussion**: Clarifications may be requested
3. **Assignment**: Issue assigned to a developer
4. **Implementation**: Fix or feature is developed
5. **Testing**: Changes are tested
6. **Release**: Included in next release
7. **Closure**: Issue marked as resolved

### Response Times

- **Critical bugs**: Within 24 hours
- **Regular bugs**: Within 1 week
- **Feature requests**: Within 2 weeks
- **Questions**: Within 3 days

---

## Getting Help

Not sure if it's a bug? Try these first:

- **Discussions**: [GitHub Discussions](https://github.com/MUT-TANT/MobileApp/discussions)
- **FAQ**: [Frequently Asked Questions](../resources/faq.md)
- **Troubleshooting**: [Troubleshooting Guide](../resources/troubleshooting.md)

---

## Next Steps

- [How to Contribute](how-to-contribute.md)
- [Pull Request Process](pull-requests.md)
- [Code of Conduct](code-of-conduct.md)
