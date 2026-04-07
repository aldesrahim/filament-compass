# Publishing Filament Compass

## Step 1: Create GitHub Repository

Go to https://github.com/new and create a new repository:
- Name: `filament-compass`
- Description: `Comprehensive documentation for Filament v5, designed for LLMs and Laravel Boost integration`
- Public or Private (your choice)
- **Do NOT** initialize with README

## Step 2: Push to GitHub

```bash
# In this directory

# Add remote (replace aldesrahim)
git remote add origin https://github.com/aldesrahim/filament-compass.git

# Push to GitHub
git push -u origin main
```

## Step 3: Update URLs

Update `aldesrahim` in these files:
- `README.md`
- `install.sh`
- `setup-boost.sh`

```bash
sed -i 's/aldesrahim/your-actual-username/g' README.md install.sh setup-boost.sh

git add .
git commit -m "Update repository URLs"
git push
```

---

## For Users: Installing Into Existing Projects

### Option 1: One-Line Install (Easiest)

```bash
cd /path/to/existing/project
curl -s https://raw.githubusercontent.com/aldesrahim/filament-compass/main/install.sh | bash
```

### Option 2: Git Submodule (Recommended for Teams)

```bash
cd /path/to/existing/project

# 1. Add as submodule
git submodule add https://github.com/aldesrahim/filament-compass.git filament-compass

# 2. Create .ai/ at PROJECT ROOT
mkdir -p .ai/guidelines/filament
mkdir -p .ai/skills/filament-compass

# 3. Create symlinks (from project root)
ln -s ../../../filament-compass/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-compass/SKILL.md .ai/skills/filament-compass/SKILL.md

# 4. Commit
git add .gitmodules filament-compass .ai/
git commit -m "Add Filament Compass"
```

**To update:**
```bash
git submodule update --remote filament-compass
```

---

## Directory Structure After Installation

```
existing-project/                      # USER'S PROJECT ROOT
├── .ai/                               # Created at project root
│   ├── guidelines/
│   │   └── filament/
│   │       └── core.md → ../../../filament-compass/GUIDELINES.md
│   └── skills/
│       └── filament-compass/
│           └── SKILL.md → ../../../filament-compass/SKILL.md
│
├── filament-compass/                # Submodule or downloaded folder
│   ├── COMPASS.md
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
mkdir -p .ai/skills/filament-compass

# Create symlinks from .ai/ to filament-compass/
ln -s ../../../filament-compass/GUIDELINES.md .ai/guidelines/filament/core.md
ln -s ../../../filament-compass/SKILL.md .ai/skills/filament-compass/SKILL.md
```

**NOT:**
```bash
# ❌ Don't run from inside filament-compass/
cd filament-compass

# ❌ Don't run from inside .ai/
cd .ai/guidelines/filament
```

---

## Repository Contents

When users clone/add this repo, they get:

```
filament-compass/              # The repo they clone
├── COMPASS.md
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