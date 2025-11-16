#!/bin/bash

# ============================================
# Diagnostic Script for markdown-preview.nvim
# ============================================

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
echo "  markdown-preview.nvim Diagnostics"
echo "======================================"
echo ""

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Check 1: Node.js
print_info "Checking Node.js..."
if command -v node >/dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    print_success "Node.js $NODE_VERSION"
else
    print_error "Node.js not found"
    exit 1
fi

# Check 2: Critical files
print_info "Checking critical files..."
FILES=(
    "app/server.js"
    "app/index.js"
    "app/out/index.html"
    "app/_static/shadcn-typography.css"
    "app/pages/index.jsx"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        print_success "$file exists"
    else
        print_error "$file missing"
    fi
done

# Check 3: Dependencies
print_info "Checking dependencies..."
if [ -d "node_modules" ]; then
    print_success "Root node_modules exists"
else
    print_warning "Root node_modules missing"
fi

if [ -d "app/node_modules" ]; then
    print_success "App node_modules exists"
else
    print_warning "App node_modules missing"
fi

# Check 4: markdown-it-mark
print_info "Checking markdown-it-mark..."
if [ -d "node_modules/markdown-it-mark" ]; then
    print_success "markdown-it-mark in root"
elif [ -d "app/node_modules/markdown-it-mark" ]; then
    print_success "markdown-it-mark in app"
else
    print_error "markdown-it-mark not found"
fi

# Check 5: Built files
print_info "Checking build artifacts..."
if [ -f "app/out/index.html" ]; then
    print_success "Next.js export complete"
    # Check if shadcn CSS is referenced
    if grep -q "shadcn-typography.css" "app/out/index.html"; then
        print_success "shadcn CSS referenced in HTML"
    else
        print_warning "shadcn CSS NOT referenced in HTML"
    fi
else
    print_error "Next.js export missing"
fi

# Check 6: TypeScript build
print_info "Checking TypeScript build..."
if [ -f "app/lib/app/index.js" ]; then
    print_success "TypeScript compiled"
else
    print_warning "TypeScript output missing"
fi

# Check 7: Test server manually
print_info "Testing server startup..."
timeout 3s node app/server.js --help 2>&1 > /dev/null
if [ $? -eq 124 ] || [ $? -eq 0 ]; then
    print_success "Server script runs"
else
    print_error "Server script failed"
fi

echo ""
echo "======================================"
print_info "Manual Test Commands:"
echo "======================================"
echo ""
echo "1. Test server manually:"
echo "   cd $SCRIPT_DIR"
echo "   node app/server.js"
echo ""
echo "2. In Neovim, check:"
echo "   :echo exists(':MarkdownPreview')"
echo "   :messages"
echo "   :echo g:mkdp_filetypes"
echo ""
echo "3. Check for stuck processes:"
echo "   ps aux | grep markdown"
echo "   pkill -9 node  # if needed"
echo ""
echo "4. Check plugin path:"
echo "   :echo stdpath('data') . '/lazy/markdown-preview.nvim'"
echo ""
