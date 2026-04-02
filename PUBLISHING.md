# Publishing Filament Blueprint

## Step 1: Create GitHub Repository

Go to https://github.com/new and create a new repository:
- Name: `filament-blueprint`
- Description: `Comprehensive documentation for Filament v5, designed for LLMs and Laravel Boost integration`
- Public or Private (your choice)
- **Do NOT** initialize with README (we already have one)

## Step 2: Push to GitHub

```bash
# In the filament-blueprint-clone directory

# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/filament-blueprint.git

# Push to GitHub
git push -u origin main
```

## Step 3: Update URLs

After pushing, update these files with your actual GitHub username:

1. `install.sh` - Line with `REPO_URL`
2. `filament-blueprint/README.md` - All `YOUR_USERNAME` placeholders
3. Badge URLs in `filament-blueprint/README.md`

```bash
# Quick find and replace
sed -i 's/YOUR_USERNAME/your-actual-username/g' install.sh
sed -i 's/YOUR_USERNAME/your-actual-username/g' filament-blueprint/README.md

git add .
git commit -m "Update repository URLs"
git push
```

---

## For Users Installing Into Existing Projects

### Option 1: Git Submodule (Recommended for teams)

```bash
cd /path/to/existing/project

git submodule add https://github.com/YOUR_USERNAME/filament-blueprint.git filament-blueprint

# Create symlinks
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development
ln -s ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md

# Commit
git add .gitmodules filament-blueprint .ai/
git commit -m "Add Filament Blueprint"
```

### Option 2: One-Line Install

```bash
cd /path/to/existing/project
curl -s https://raw.githubusercontent.com/YOUR_USERNAME/filament-blueprint/main/install.sh | bash
```

### Option 3: Git Clone (Not recommended for existing projects)

```bash
# This creates a nested git repo, which can cause issues
git clone https://github.com/YOUR_USERNAME/filament-blueprint.git
```

**Better to use submodule or the install script instead.**

---

## Directory Structure After Integration

```
existing-project/
├── .ai/                           # Laravel Boost
│   ├── guidelines/filament/core.md → filament-blueprint/GUIDELINES.md
│   └── skills/filament-development/SKILL.md → filament-blueprint/SKILL.md
├── .gitmodules                     # If using submodule
├── filament-blueprint/             # Blueprint files
│   └── ... (48 documentation files)
├── app/
├── config/
└── ... (your existing Laravel files)
```