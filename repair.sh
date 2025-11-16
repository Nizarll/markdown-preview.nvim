#!/bin/bash

# ============================================
# Repair Script for markdown-preview.nvim
# Fixes installation issues
# ============================================

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_success() { echo -e "${GREEN}✓${NC} $1"; }
print_error() { echo -e "${RED}✗${NC} $1"; }
print_info() { echo -e "${BLUE}ℹ${NC} $1"; }
print_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

echo ""
echo "======================================"
echo "  markdown-preview.nvim Repair Tool"
echo "======================================"
echo ""

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

print_info "Working directory: $SCRIPT_DIR"
cd "$SCRIPT_DIR"

# Step 1: Clean old builds
print_info "Cleaning old builds..."
rm -rf app/.next
rm -rf app/out
rm -rf node_modules
rm -rf app/node_modules
print_success "Clean complete"

# Step 2: Install root dependencies
print_info "Installing root dependencies..."
npx --yes yarn install
print_success "Root dependencies installed"

# Step 3: Install app dependencies
print_info "Installing app dependencies..."
cd app
npm install
cd ..
print_success "App dependencies installed"

# Step 4: Build TypeScript
print_info "Building TypeScript..."
npm run build-lib
print_success "TypeScript build complete"

# Step 5: Build Next.js app
print_info "Building Next.js app (this may take a minute)..."
export NODE_OPTIONS="--openssl-legacy-provider"
cd app
npx next build
npx next export
cd ..
print_success "Next.js build complete"

# Step 6: Verify build
print_info "Verifying build..."
if [ -f "app/out/index.html" ]; then
    print_success "Build verification passed"
else
    print_error "Build verification failed - index.html not found"
    exit 1
fi

# Step 7: Check for shadcn CSS
if [ -f "app/_static/shadcn-typography.css" ]; then
    print_success "shadcn typography CSS found"
else
    print_warning "shadcn typography CSS not found"
fi

echo ""
echo "======================================"
print_success "Repair completed successfully!"
echo "======================================"
echo ""
print_info "Next steps:"
echo "  1. Restart Neovim"
echo "  2. Open a markdown file"
echo "  3. Run :MarkdownPreview"
echo ""
print_info "If issues persist, check:"
echo "  - :messages in Neovim for errors"
echo "  - ps aux | grep markdown-preview for running processes"
echo "  - killall -9 node (if needed to kill stuck processes)"
echo ""
