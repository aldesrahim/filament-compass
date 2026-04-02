# Publishing Filament Blueprint

## Step 1: Create GitHub Repository

Go to https://github.com/new and create a new repository:
- Name: `filament-blueprint`
- Description: `Comprehensive documentation for Filament v5, designed for LLMs and Laravel Boost integration`
- Public or Private (your choice)
- **Do NOT** initialize with README

## Step 2: Push to GitHub

```bash
# In this directory

# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/filament-blueprint.git

# Push to GitHub
git push -u origin main
```

## Step 3: Update URLs

Update `YOUR_USERNAME` in these files:
- `README.md`
- `install.sh`
- `setup-boost.sh`

```bash
sed -i 's/YOUR_USERNAME/your-actual-username/g' README.md install.sh setup-boost.sh

git add .
git commit -m "Update repository URLs"
git push
```

---

## For Users: Installing Into Existing Projects

### Option 1: One-Line Install (Easiest)

```bash
cd /path/to/existing/project
curl -s https://raw.githubusercontent.com/YOUR_USERNAME/filament-blueprint/main/install.sh | bash
```

### Option 2: Git Submodule (Recommended for Teams)

```bash
cd /path/to/existing/project

# 1. Add as submodule
git submodule add https://github.com/YOUR_USERNAME/filament-blueprint.git filament-blueprint

# 2. Create .ai/ at PROJECT ROOT
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development

# 3. Create symlinks (from project root)
ln -s ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md

# 4. Commit
git add .gitmodules filament-blueprint .ai/
git commit -m "Add Filament Blueprint"
```

**To update:**
```bash
git submodule update --remote filament-blueprint
```

---

## Directory Structure After Installation

```
existing-project/                      # USER'S PROJECT ROOT
├── .ai/                               # Created at project root
│   ├── guidelines/
│   │   └── filament/
│   │       └── core.md → ../../../filament-blueprint/GUIDELINES.md
│   └── skills/
│       └── filament-development/
│           └── SKILL.md → ../../../filament-blueprint/SKILL.md
│
├── filament-blueprint/                # Submodule or downloaded folder
│   ├── BLUEPRINT.md
│   ├── SKILL.md
│   ├── GUIDELINES.md
│   ├── architecture/
│   ├── packages/
│   ├── patterns/
│   ├── testing/
│   ├── recipes/
│   └── reference/
│
├── .gitmodules                        # (if using submodule)
├── app/                               # User's Laravel app
├── config/
├── routes/
└── ...
```

---

## Where to Run Commands

**Always run commands from the USER'S PROJECT ROOT:**

```bash
cd /path/to/existing/project   # Project root (where artisan is)

# Create .ai/
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-development

# Create symlinks from .ai/ to filament-blueprint/
ln -s ../../../filament-blueprint/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-blueprint/SKILL.md .ai/skills/filament-development/SKILL.md
```

**NOT:**
```bash
# ❌ Don't run from inside filament-blueprint/
cd filament-blueprint

# ❌ Don't run from inside .ai/
cd .ai/guidelines/filament
```

---

## Repository Contents

When users clone/add this repo, they get:

```
filament-blueprint/              # The repo they clone
├── BLUEPRINT.md
├── SKILL.md
├── GUIDELINES.md
├── README.md
├── PLAN.md
├── architecture/
├── packages/
├── patterns/
├── testing/
├── recipes/
├── reference/
├── install.sh
├── setup-boost.sh
└── .gitignore
```

**Note:** The `.ai/` directory is NOT in the repo. Users create it at their project root.