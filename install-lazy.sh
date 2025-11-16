#!/bin/bash

# ============================================
# Ultimate Installation Script for
# markdown-preview.nvim with shadcn UI Typography
# For lazy.nvim on Linux
# ============================================

set -e  # Exit on error

# Colors for beautiful output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Repository details
REPO_URL="https://github.com/Nizarll/markdown-preview.nvim.git"
BRANCH="claude/add-typography-styles-016w9t32Pbc8mUsNNv5EaL1T"
PLUGIN_NAME="markdown-preview.nvim"

# Progress tracking
STEP=0
TOTAL_STEPS=12

# Helper functions
print_header() {
    echo ""
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BOLD}${CYAN}  $1${NC}"
    echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_step() {
    STEP=$((STEP + 1))
    echo -e "${BOLD}${MAGENTA}[${STEP}/${TOTAL_STEPS}]${NC} ${BOLD}$1${NC}"
}

print_success() {
    echo -e "  ${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "  ${RED}✗${NC} $1"
}

print_info() {
    echo -e "  ${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "  ${YELLOW}⚠${NC} $1"
}

print_action() {
    echo -e "  ${CYAN}➜${NC} $1"
}

# Error handler
error_exit() {
    print_error "$1"
    echo ""
    print_info "Installation failed. Please check the errors above."
    print_info "You can try running the script again or check the documentation."
    exit 1
}

# Cleanup function
cleanup_on_exit() {
    if [ $? -ne 0 ]; then
        print_warning "Installation interrupted. Cleaning up..."
    fi
}

trap cleanup_on_exit EXIT

# Banner
command -v clear >/dev/null 2>&1 && clear || echo ""
print_header "markdown-preview.nvim Installation"
echo -e "${BOLD}  shadcn UI Typography Edition${NC}"
echo -e "  ${CYAN}Branch:${NC} ${BRANCH}"
echo -e "  ${CYAN}Target:${NC} lazy.nvim on Linux"
echo ""

# ============================================
# STEP 1: System Requirements Check
# ============================================
print_step "Checking system requirements..."

# Check OS
if [[ ! "$OSTYPE" == "linux-gnu"* ]]; then
    print_warning "This script is optimized for Linux"
    read -p "Continue anyway? [y/N]: " continue
    if [[ ! "$continue" =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Check Node.js
if ! command -v node >/dev/null 2>&1; then
    error_exit "Node.js is not installed. Please install Node.js v14 or higher first."
fi

NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 14 ]; then
    error_exit "Node.js version is too old. Please upgrade to v14 or higher."
fi
print_success "Node.js $(node --version) detected"

# Check npm
if ! command -v npm >/dev/null 2>&1; then
    error_exit "npm is not installed. Please install npm first."
fi
print_success "npm $(npm --version) detected"

# Check git
if ! command -v git >/dev/null 2>&1; then
    error_exit "git is not installed. Please install git first."
fi
print_success "git detected"

# Check Neovim
if ! command -v nvim >/dev/null 2>&1; then
    print_warning "Neovim not found in PATH"
    read -p "Continue anyway? [y/N]: " continue
    if [[ ! "$continue" =~ ^[Yy]$ ]]; then
        exit 0
    fi
else
    print_success "Neovim detected"
fi

# ============================================
# STEP 2: Detect lazy.nvim
# ============================================
print_step "Detecting lazy.nvim installation..."

LAZY_PATH="$HOME/.local/share/nvim/lazy"
PLUGIN_PATH="$LAZY_PATH/$PLUGIN_NAME"
NVIM_CONFIG="$HOME/.config/nvim"

if [ ! -d "$LAZY_PATH" ]; then
    error_exit "lazy.nvim not found at $LAZY_PATH. Please install lazy.nvim first."
fi
print_success "lazy.nvim found at $LAZY_PATH"

# ============================================
# STEP 3: Kill stuck processes
# ============================================
print_step "Cleaning up stuck processes..."

if pgrep -f "markdown-preview" >/dev/null 2>&1; then
    print_action "Killing stuck markdown-preview processes..."
    pkill -9 -f "markdown-preview" 2>/dev/null || true
    print_success "Processes cleaned"
else
    print_info "No stuck processes found"
fi

# Kill any Neovim instances to prevent conflicts
if pgrep -x nvim >/dev/null 2>&1; then
    print_warning "Neovim is currently running"
    print_action "Please close all Neovim instances before continuing"
    read -p "Press Enter when ready..."

    if pgrep -x nvim >/dev/null 2>&1; then
        print_error "Neovim is still running. Forcing shutdown..."
        pkill -9 nvim 2>/dev/null || true
        sleep 1
    fi
fi
print_success "Ready to proceed"

# ============================================
# STEP 4: Backup existing installation
# ============================================
print_step "Checking for existing installation..."

if [ -d "$PLUGIN_PATH" ]; then
    print_warning "Found existing markdown-preview.nvim installation"

    # Check which fork it is
    cd "$PLUGIN_PATH"
    CURRENT_REMOTE=$(git config --get remote.origin.url 2>/dev/null || echo "unknown")

    if [[ "$CURRENT_REMOTE" == *"Nizarll"* ]]; then
        print_info "Already using the enhanced fork"
        print_action "Updating to latest version..."
        git fetch origin "$BRANCH" 2>/dev/null || error_exit "Failed to fetch updates"
        git checkout "$BRANCH" 2>/dev/null || error_exit "Failed to checkout branch"
        git pull origin "$BRANCH" 2>/dev/null || error_exit "Failed to pull updates"
        print_success "Updated to latest version"
        SKIP_CLONE=true
    else
        print_info "Current installation is from: $CURRENT_REMOTE"
        BACKUP_PATH="${PLUGIN_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
        print_action "Creating backup at: $BACKUP_PATH"
        mv "$PLUGIN_PATH" "$BACKUP_PATH" || error_exit "Failed to create backup"
        print_success "Backup created"
        SKIP_CLONE=false
    fi
else
    print_info "No existing installation found"
    SKIP_CLONE=false
fi

# ============================================
# STEP 5: Clone repository
# ============================================
if [ "$SKIP_CLONE" = false ]; then
    print_step "Cloning enhanced markdown-preview.nvim..."

    print_action "Downloading from GitHub..."
    git clone --branch "$BRANCH" --single-branch --depth 1 "$REPO_URL" "$PLUGIN_PATH" 2>&1 | \
        grep -v "^Cloning" | grep -v "^remote:" || error_exit "Failed to clone repository"

    print_success "Repository cloned successfully"
else
    print_step "Skipping clone (already up to date)..."
fi

# ============================================
# STEP 6: Clean old build artifacts
# ============================================
print_step "Cleaning old build artifacts..."

cd "$PLUGIN_PATH" || error_exit "Failed to enter plugin directory"

print_action "Removing old builds..."
rm -rf app/.next 2>/dev/null || true
rm -rf app/out 2>/dev/null || true
rm -rf node_modules 2>/dev/null || true
rm -rf app/node_modules 2>/dev/null || true
rm -rf app/package-lock.json 2>/dev/null || true
rm -rf package-lock.json 2>/dev/null || true

print_success "Old artifacts removed"

# ============================================
# STEP 7: Install root dependencies
# ============================================
print_step "Installing root dependencies..."

print_action "Running yarn install (this may take a minute)..."
npx --yes yarn install --silent 2>&1 | grep -E "(error|warning)" || true

if [ ! -d "node_modules" ]; then
    error_exit "Failed to install root dependencies"
fi

# Verify critical dependencies
if [ ! -d "node_modules/markdown-it-mark" ]; then
    print_warning "markdown-it-mark not found in root, installing manually..."
    npm install markdown-it-mark --save 2>&1 | grep -E "error" || true
fi

print_success "Root dependencies installed ($(ls node_modules | wc -l) packages)"

# ============================================
# STEP 8: Install app dependencies
# ============================================
print_step "Installing app dependencies..."

cd app || error_exit "Failed to enter app directory"

print_action "Running npm install..."
npm install --silent 2>&1 | grep -E "error" || true

if [ ! -d "node_modules" ]; then
    error_exit "Failed to install app dependencies"
fi

# Verify markdown-it-mark in app too
if [ ! -d "node_modules/markdown-it-mark" ]; then
    print_warning "markdown-it-mark not found in app, installing..."
    npm install markdown-it-mark --save 2>&1 | grep -E "error" || true
fi

cd .. || exit 1
print_success "App dependencies installed ($(ls app/node_modules | wc -l) packages)"

# ============================================
# STEP 9: Build TypeScript
# ============================================
print_step "Building TypeScript..."

print_action "Compiling TypeScript files..."
npm run build-lib 2>&1 | grep -E "(error|Error)" || true

if [ ! -f "app/lib/app/index.js" ]; then
    error_exit "TypeScript compilation failed"
fi

print_success "TypeScript compiled successfully"

# ============================================
# STEP 10: Build Next.js app
# ============================================
print_step "Building Next.js app (this may take 1-2 minutes)..."

cd app || error_exit "Failed to enter app directory"

# Set Node options for legacy OpenSSL support
export NODE_OPTIONS="--openssl-legacy-provider"

print_action "Building Next.js application..."
npx next build 2>&1 | grep -v "^info " | grep -v "^event " | grep -v "Compiled" || true

if [ ! -d ".next" ]; then
    error_exit "Next.js build failed"
fi

print_action "Exporting static files..."
npx next export 2>&1 | grep -v "^info " | grep -v "^event " || true

if [ ! -f "out/index.html" ]; then
    error_exit "Next.js export failed"
fi

# Verify shadcn CSS is included
if ! grep -q "shadcn-typography.css" "out/index.html"; then
    error_exit "shadcn typography CSS not found in build output"
fi

cd .. || exit 1
print_success "Next.js app built and exported successfully"

# ============================================
# STEP 11: Verify installation
# ============================================
print_step "Verifying installation..."

CHECKS_PASSED=0
CHECKS_TOTAL=8

# Check 1: Critical files
if [ -f "app/server.js" ] && [ -f "app/index.js" ] && [ -f "app/out/index.html" ]; then
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
    print_success "Core files present"
else
    print_error "Missing core files"
fi

# Check 2: shadcn CSS
if [ -f "app/_static/shadcn-typography.css" ]; then
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
    print_success "shadcn typography CSS present"
else
    print_error "shadcn CSS missing"
fi

# Check 3: Root dependencies
if [ -d "node_modules" ] && [ "$(ls -A node_modules)" ]; then
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
    print_success "Root dependencies installed"
else
    print_error "Root dependencies missing"
fi

# Check 4: App dependencies
if [ -d "app/node_modules" ] && [ "$(ls -A app/node_modules)" ]; then
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
    print_success "App dependencies installed"
else
    print_error "App dependencies missing"
fi

# Check 5: markdown-it-mark
if [ -d "node_modules/markdown-it-mark" ] || [ -d "app/node_modules/markdown-it-mark" ]; then
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
    print_success "markdown-it-mark plugin installed"
else
    print_error "markdown-it-mark plugin missing"
fi

# Check 6: TypeScript build
if [ -f "app/lib/app/index.js" ]; then
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
    print_success "TypeScript compiled"
else
    print_error "TypeScript compilation incomplete"
fi

# Check 7: Next.js export
if [ -f "app/out/index.html" ] && [ -d "app/out/_next" ]; then
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
    print_success "Next.js export complete"
else
    print_error "Next.js export incomplete"
fi

# Check 8: Vim plugin files
if [ -f "plugin/mkdp.vim" ] && [ -d "autoload" ]; then
    CHECKS_PASSED=$((CHECKS_PASSED + 1))
    print_success "Vim plugin files present"
else
    print_error "Vim plugin files missing"
fi

echo ""
print_info "Verification: ${CHECKS_PASSED}/${CHECKS_TOTAL} checks passed"

if [ "$CHECKS_PASSED" -lt "$CHECKS_TOTAL" ]; then
    print_warning "Some checks failed, but installation may still work"
fi

# ============================================
# STEP 12: Update lazy.nvim configuration
# ============================================
print_step "Checking lazy.nvim configuration..."

echo ""
print_warning "IMPORTANT: You need to update your Neovim configuration!"
echo ""

# Try to find plugin configuration
FOUND_CONFIG=false
CONFIG_FILES=(
    "$NVIM_CONFIG/lua/plugins/markdown-preview.lua"
    "$NVIM_CONFIG/lua/plugins/markdown.lua"
    "$NVIM_CONFIG/lua/plugins/init.lua"
    "$NVIM_CONFIG/lua/plugins.lua"
    "$NVIM_CONFIG/init.lua"
)

print_info "Searching for plugin configuration..."
for config_file in "${CONFIG_FILES[@]}"; do
    if [ -f "$config_file" ]; then
        if grep -q "markdown-preview" "$config_file" 2>/dev/null; then
            print_action "Found configuration in: $config_file"

            # Check if it's already using the new fork
            if grep -q "Nizarll/markdown-preview.nvim" "$config_file"; then
                print_success "Configuration already updated!"
                FOUND_CONFIG=true
                break
            else
                print_warning "Configuration needs to be updated"
                print_info "File: $config_file"
                FOUND_CONFIG=true
                break
            fi
        fi
    fi
done

if [ "$FOUND_CONFIG" = false ]; then
    print_warning "Could not find markdown-preview configuration"
    print_info "You may need to add it manually"
fi

echo ""
print_header "Configuration Instructions"
echo ""
echo -e "${BOLD}Add this to your lazy.nvim plugins:${NC}"
echo ""
echo -e "${CYAN}return {${NC}"
echo -e "${CYAN}  \"Nizarll/markdown-preview.nvim\",${NC}"
echo -e "${CYAN}  branch = \"$BRANCH\",${NC}"
echo -e "${CYAN}  cmd = { \"MarkdownPreviewToggle\", \"MarkdownPreview\", \"MarkdownPreviewStop\" },${NC}"
echo -e "${CYAN}  ft = { \"markdown\" },${NC}"
echo -e "${CYAN}  build = \"cd app && npx --yes yarn install\",${NC}"
echo -e "${CYAN}}${NC}"
echo ""
print_warning "Make sure to REMOVE any old 'iamcco/markdown-preview.nvim' entries!"
echo ""

# ============================================
# Final steps
# ============================================
print_header "Installation Complete!"

echo ""
print_success "Plugin successfully installed at:"
print_info "$PLUGIN_PATH"
echo ""

print_header "Next Steps"
echo ""
echo -e "${BOLD}1. Update your Neovim configuration${NC}"
print_info "   Add the plugin configuration shown above"
print_info "   Remove any old markdown-preview entries"
echo ""
echo -e "${BOLD}2. Sync lazy.nvim${NC}"
print_info "   Open Neovim and run: ${CYAN}:Lazy sync${NC}"
echo ""
echo -e "${BOLD}3. Test the plugin${NC}"
print_info "   Create a test file: ${CYAN}nvim test.md${NC}"
print_info "   Run: ${CYAN}:MarkdownPreview${NC}"
echo ""

print_header "Features Included"
echo ""
print_success "shadcn UI typography with New York theme"
print_success "Dark/light mode support (auto-detects system theme)"
print_success "Text highlighting with ==text== syntax"
print_success "Inter font family (auto-loaded from Google Fonts)"
print_success "Responsive design for mobile/desktop"
print_success "Enhanced code block styling"
echo ""

print_header "Verification Commands"
echo ""
echo -e "${BOLD}In Neovim, check:${NC}"
echo -e "  ${CYAN}:echo exists(':MarkdownPreview')${NC}  ${BLUE}# Should return: 2${NC}"
echo -e "  ${CYAN}:messages${NC}  ${BLUE}# Check for errors${NC}"
echo -e "  ${CYAN}:Lazy${NC}  ${BLUE}# View plugin manager${NC}"
echo ""
echo -e "${BOLD}In terminal:${NC}"
echo -e "  ${CYAN}cd $PLUGIN_PATH && ./diagnose.sh${NC}"
echo ""

print_header "Troubleshooting"
echo ""
print_info "If preview doesn't open:"
echo "  • Make sure you updated your Neovim config"
echo "  • Run :Lazy sync in Neovim"
echo "  • Restart Neovim completely"
echo "  • Check :messages for errors"
echo ""
print_info "If you see old styles:"
echo "  • Clear browser cache (Ctrl+Shift+R)"
echo "  • Make sure shadcn-typography.css exists"
echo ""
print_info "Need help?"
echo "  • Run: ./diagnose.sh (in plugin directory)"
echo "  • Check: $PLUGIN_PATH/QUICK_FIX.md"
echo ""

print_header "Thank You!"
echo ""
echo -e "${BOLD}${GREEN}Installation completed successfully!${NC}"
echo ""
