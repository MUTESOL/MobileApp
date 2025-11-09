# GitBook Setup Guide

This guide will help you set up and publish your StackSave documentation as a GitBook.

## What is GitBook?

GitBook is a modern documentation platform that turns your Markdown files into a beautiful, searchable documentation website.

## Documentation Structure

Your documentation is now organized in the `/docs` folder with the following structure:

```
docs/
├── SUMMARY.md                    # Table of contents
├── README.md                     # Documentation home page
├── introduction/                 # What is StackSave
│   ├── what-is-stacksave.md
│   └── key-features.md
├── getting-started/              # Getting started guides
│   ├── installation.md
│   ├── quick-start.md
│   ├── connecting-wallet.md
│   └── first-goal.md
├── features/                     # Feature documentation (to be created)
├── architecture/                 # Architecture docs
│   └── project-structure.md
├── web3/                        # Web3 integration
│   └── wallet-connect.md
├── api/                         # API reference
│   └── wallet-service.md
├── development/                 # Development guides (to be created)
├── contributing/                # Contribution guidelines
│   └── how-to-contribute.md
└── resources/                   # Additional resources
    └── faq.md
```

## Option 1: GitBook.com (Recommended - Easiest)

### Step 1: Create GitBook Account

1. Go to [GitBook.com](https://www.gitbook.com)
2. Sign up for a free account
3. Choose "Personal" plan (free for public docs)

### Step 2: Import Repository

1. Click "New Space" or "Import"
2. Select "GitHub" as the source
3. Authorize GitBook to access your repository
4. Select your StackSave repository
5. Choose the branch (e.g., `main`)
6. Set documentation root to `/docs`

### Step 3: Configure

GitBook will automatically detect:
- `SUMMARY.md` as table of contents
- `README.md` as homepage
- All linked markdown files

### Step 4: Publish

1. Review your documentation
2. Click "Publish" to make it live
3. Get your public URL: `https://yourname.gitbook.io/stacksave`

### Step 5: Auto-Sync (Optional)

Enable GitHub integration for automatic updates:
1. Go to Space Settings
2. Enable "GitHub Sync"
3. Every push to your repo updates the docs!

## Option 2: GitBook CLI (Self-Hosted)

### Step 1: Install GitBook CLI

```bash
# Install Node.js first (if not installed)
# Download from https://nodejs.org

# Install GitBook CLI globally
npm install -g gitbook-cli
```

### Step 2: Initialize GitBook

```bash
# Navigate to your project
cd stacksave

# Install GitBook and plugins
gitbook install
```

This will install plugins defined in `book.json`:
- `search-plus` - Enhanced search
- `copy-code-button` - Copy code blocks
- `github` - GitHub link
- `edit-link` - Edit page links
- `back-to-top-button` - Scroll to top
- `prism` - Code syntax highlighting

### Step 3: Preview Locally

```bash
# Serve documentation locally
gitbook serve

# Opens at http://localhost:4000
```

Your browser will show the documentation. Changes auto-reload!

### Step 4: Build for Production

```bash
# Build static HTML
gitbook build

# Output in _book/ folder
```

### Step 5: Deploy

Deploy the `_book/` folder to any static hosting:

**GitHub Pages**:
```bash
# Build
gitbook build

# Copy to gh-pages branch
git checkout -b gh-pages
cp -r _book/* .
git add .
git commit -m "docs: publish GitBook"
git push origin gh-pages

# Enable GitHub Pages in repo settings
```

**Netlify**:
1. Connect your GitHub repo
2. Set build command: `gitbook build`
3. Set publish directory: `_book`
4. Deploy!

**Vercel**:
1. Import your repository
2. Framework: Other
3. Build command: `gitbook build`
4. Output directory: `_book`
5. Deploy!

## Configuration Files

### `.gitbook.yaml`

Points GitBook.com to your documentation:

```yaml
root: ./docs/
summary: SUMMARY.md
readme: ../README.md
```

### `book.json`

Configures GitBook CLI with plugins and settings.

Key sections:
- `root`: Documentation folder
- `plugins`: Enabled plugins
- `pluginsConfig`: Plugin settings

## Customization

### Theme Colors

Create `docs/styles/website.css`:

```css
/* Primary color */
.book-summary {
  background: #00D09E;
}

/* Link color */
.book-summary .chapter > a {
  color: #fff;
}

/* Active chapter */
.book-summary .chapter.active > a {
  background: rgba(255,255,255,0.2);
}
```

### Logo

Add your logo to `docs/assets/` and reference in `book.json`:

```json
{
  "pluginsConfig": {
    "theme-default": {
      "logo": "./assets/logo.png"
    }
  }
}
```

## Adding More Documentation

### Create New Pages

1. Create a new `.md` file in appropriate folder:
   ```bash
   # Example: Create features overview
   touch docs/features/overview.md
   ```

2. Add content to the file

3. Link it in `SUMMARY.md`:
   ```markdown
   * [Features Overview](features/overview.md)
   ```

### Organize Sections

Edit `docs/SUMMARY.md` to add/remove/reorder sections:

```markdown
# Table of contents

## New Section

* [Page 1](section/page1.md)
* [Page 2](section/page2.md)
  * [Sub-page](section/page2-sub.md)
```

## Tips & Best Practices

### Writing Good Documentation

1. **Start with why**: Explain the purpose before the how
2. **Use examples**: Code examples are very helpful
3. **Add screenshots**: Visual aids improve understanding
4. **Keep it updated**: Review and update regularly
5. **Test links**: Ensure all links work

### Markdown Best Practices

```markdown
# Use proper heading hierarchy

## Don't skip levels

### Code blocks with language

```dart
final example = 'syntax highlighted';
```

**Bold** for emphasis, *italic* for terms

> Blockquotes for important notes

- Bulleted lists
- Are easier to scan

1. Numbered lists
2. For sequential steps
```

### Search Optimization

- Use descriptive headings
- Include keywords naturally
- Link related pages
- Add table of contents for long pages

## Maintenance

### Regular Updates

When you update code, update docs:
1. Change code → Update relevant doc page
2. Add feature → Add feature documentation
3. Fix bug → Update troubleshooting if needed

### Version Documentation

For major versions, consider versioning docs:
1. Tag releases: `v1.0.0`, `v2.0.0`
2. Branch docs: `docs-v1`, `docs-v2`
3. Use GitBook spaces for each version

## Troubleshooting

### "gitbook: command not found"

```bash
# Reinstall globally
npm install -g gitbook-cli

# Or use npx
npx gitbook-cli install
npx gitbook-cli serve
```

### Plugin Installation Fails

```bash
# Clear cache
rm -rf ~/.gitbook

# Reinstall
gitbook install
```

### Build Errors

```bash
# Clean build
rm -rf _book node_modules
gitbook install
gitbook build
```

### Links Not Working

- Use relative paths: `../section/page.md`
- Not absolute paths: `/section/page.md`
- Check file paths are correct
- Ensure files referenced in SUMMARY.md exist

## Next Steps

1. **Review content**: Read through all created docs
2. **Fill in gaps**: Create missing documentation pages
3. **Add examples**: Include more code examples
4. **Add screenshots**: Capture app UI for guides
5. **Publish**: Choose GitBook.com or self-host
6. **Share**: Add docs link to README
7. **Maintain**: Keep docs updated with code changes

## Resources

- [GitBook Documentation](https://docs.gitbook.com)
- [GitBook Plugins](https://plugins.gitbook.com)
- [Markdown Guide](https://www.markdownguide.org)
- [GitBook GitHub](https://github.com/GitbookIO/gitbook)

## Questions?

- Check [GitBook Docs](https://docs.gitbook.com)
- Ask in [GitBook Community](https://github.com/GitbookIO/gitbook/discussions)
- Open an issue in your repository

---

**Happy documenting! 📚**
