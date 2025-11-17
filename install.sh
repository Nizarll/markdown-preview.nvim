#!/bin/bash

# ============================================
# Installation Script for shadcn UI Typography
# markdown-preview.nvim Enhanced Edition
# ============================================

set -e

REPO_URL="https://github.com/Nizarll/markdown-preview.nvim.git"
BRANCH="claude/add-typography-styles-016w9t32Pbc8mUsNNv5EaL1T"
PLUGIN_NAME="markdown-preview.nvim"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
  echo -e "${GREEN}✓${NC} $1"
}

print_error() {
  echo -e "${RED}✗${NC} $1"
}

print_info() {
  echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}⚠${NC} $1"
}

# Detect package manager
detect_package_manager() {
  if command -v vim >/dev/null 2>&1 || command -v nvim >/dev/null 2>&1; then
    print_info "Neovim/Vim detected"
  else
    print_error "Neither Vim nor Neovim found. Please install Neovim or Vim first."
    exit 1
  fi

  if command -v node >/dev/null 2>&1; then
    print_success "Node.js found: $(node --version)"
  else
    print_error "Node.js not found. Please install Node.js first."
    exit 1
  fi

  if command -v npm >/dev/null 2>&1; then
    print_success "npm found: $(npm --version)"
  else
    print_error "npm not found. Please install npm first."
    exit 1
  fi
}

# Detect plugin manager and installation path
detect_plugin_path() {
  local vim_plugin_paths=(
    "$HOME/.local/share/nvim/lazy/$PLUGIN_NAME"
  )

  for path in "${vim_plugin_paths[@]}"; do
    if [ -d "$path" ]; then
      echo "$path"
      return 0
    fi
  done

  return 1
}

# Main installation
main() {
  echo ""
  echo "======================================"
  echo "  markdown-preview.nvim Installer"
  echo "  shadcn UI Typography Edition"
  echo "======================================"
  echo ""

  # Step 1: Detect package manager
  print_info "Checking system requirements..."
  detect_package_manager

  # Step 2: Find existing plugin installation
  print_info "Looking for existing markdown-preview.nvim installation..."
  PLUGIN_PATH=$(detect_plugin_path)

  if [ -z "$PLUGIN_PATH" ]; then
    print_warning "No existing installation found in standard plugin directories."
    echo ""
    echo "Please choose an installation method:"
    echo "  1) Install to vim-plug directory (~/.vim/plugged/)"
    echo "  2) Install to Packer directory (~/.local/share/nvim/site/pack/packer/start/)"
    echo "  3) Install to lazy.nvim directory (~/.local/share/nvim/lazy/)"
    echo "  4) Specify custom directory"
    echo ""
    read -p "Enter choice [1-4]: " choice
    PLUGIN_PATH="$HOME/.local/share/nvim/lazy/$PLUGIN_NAME"

    case $choice in
    1)
      PLUGIN_PATH="$HOME/.vim/plugged/$PLUGIN_NAME"
      ;;
    2)
      PLUGIN_PATH="$HOME/.local/share/nvim/site/pack/packer/start/$PLUGIN_NAME"
      ;;
    3)
      PLUGIN_PATH="$HOME/.local/share/nvim/lazy/$PLUGIN_NAME"
      ;;
    4)
      read -p "Enter custom directory path: " custom_path
      PLUGIN_PATH="$custom_path/$PLUGIN_NAME"
      ;;
    *)
      print_error "Invalid choice. Exiting."
      exit 1
      ;;
    esac
  else
    print_success "Found existing installation at: $PLUGIN_PATH"
    echo ""
    read -p "Replace existing installation? [y/N]: " replace
    if [[ ! "$replace" =~ ^[Yy]$ ]]; then
      print_info "Installation cancelled."
      exit 0
    fi
  fi

  # Step 3: Backup existing installation
  if [ -d "$PLUGIN_PATH" ]; then
    BACKUP_PATH="${PLUGIN_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
    print_info "Backing up existing installation to: $BACKUP_PATH"
    mv "$PLUGIN_PATH" "$BACKUP_PATH"
    print_success "Backup created"
  fi

  # Step 4: Create parent directory if needed
  PARENT_DIR=$(dirname "$PLUGIN_PATH")
  if [ ! -d "$PARENT_DIR" ]; then
    print_info "Creating directory: $PARENT_DIR"
    mkdir -p "$PARENT_DIR"
  fi

  # Step 5: Clone the repository
  print_info "Cloning repository from $REPO_URL..."
  git clone --branch "$BRANCH" --single-branch "$REPO_URL" "$PLUGIN_PATH"
  print_success "Repository cloned"

  # Step 6: Install dependencies
  print_info "Installing dependencies..."
  cd "$PLUGIN_PATH"

  # Install root dependencies
  print_info "Installing root dependencies..."
  npx --yes yarn install

  # Install app dependencies
  print_info "Installing app dependencies..."
  cd app
  npm install
  cd ..

  print_success "Dependencies installed"

  # Step 7: Build the project
  print_info "Building the project (this may take a while)..."
  export NODE_OPTIONS="--openssl-legacy-provider"
  npm run build-lib
  cd app
  npx next build
  npx next export
  cd ..
  print_success "Build completed"

  # Step 8: Done!
  echo ""
  echo "======================================"
  print_success "Installation completed successfully!"
  echo "======================================"
  echo ""
  print_info "Plugin installed at: $PLUGIN_PATH"
  echo ""
  print_info "Features included:"
  echo "  • shadcn UI Typography styles"
  echo "  • New York color theme"
  echo "  • Dark/Light theme support"
  echo "  • Text highlighting support (use ==text== syntax)"
  echo "  • Inter font family"
  echo ""
  print_info "To use the plugin in Neovim, add to your config:"
  echo ""
  echo "  :MarkdownPreview      - Start preview"
  echo "  :MarkdownPreviewStop  - Stop preview"
  echo ""
  print_warning "Note: You may need to restart Neovim for changes to take effect."
  echo ""
}

# Run main function
main "$@"
