# Dotfiles Management Makefile

.PHONY: help install backup status clean

help: ## Show this help message
	@echo "Dotfiles Management Commands:"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""

install: ## Install dotfiles to the current system
	@echo "🚀 Installing dotfiles..."
	@./scripts/install.sh

backup: ## Backup current system dotfiles to this repository
	@echo "📦 Backing up current dotfiles..."
	@./scripts/backup.sh

status: ## Show git status and overview
	@echo "📊 Repository Status:"
	@echo "===================="
	@git status --short
	@echo ""
	@echo "📁 Directory Structure:"
	@echo "======================"
	@find config -type f -name "*.md" -prune -o -type f -print | head -10
	@echo ""

clean: ## Clean up backup and temporary files
	@echo "🧹 Cleaning up..."
	@find . -name "*.backup.*" -type f -exec rm -v {} \;
	@echo "Clean complete!"

# Set default target
.DEFAULT_GOAL := help