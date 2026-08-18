.PHONY: help setup lint syntax audit plan apply rgw-audit rgw-plan terraform

help:
	@echo "mango node-management targets"
	@echo "  setup   Install the local Ansible/lint toolchain"
	@echo "  lint    Run repository lint checks"
	@echo "  syntax  Validate Ansible syntax without connecting"
	@echo "  audit   Run read-only live drift and health checks"
	@echo "  plan    Preview node configuration with --check --diff"
	@echo "  apply   Apply after review; requires CONFIRM=mango"
	@echo "  rgw-audit              Read-only Ceph RGW readiness audit"
	@echo "  rgw-plan PHASE=<name>  Preview one gated RGW phase"

setup:
	@./bin/tooling.sh

lint:
	@yamllint .
	@cd ansible && ansible-lint .
	@pre-commit run shellcheck --all-files --show-diff-on-failure
	@git diff --check

syntax:
	@./bin/ansible.sh syntax

audit:
	@./bin/ansible.sh audit

plan:
	@./bin/ansible.sh check

apply:
	@if [ "$(CONFIRM)" != "mango" ]; then \
		echo "Refusing apply: rerun with CONFIRM=mango after reviewing 'make plan'."; \
		exit 2; \
	fi
	@CONFIRM=mango ./bin/ansible.sh apply

rgw-audit:
	@./bin/ansible.sh rgw-audit

rgw-plan:
	@if [ -z "$(PHASE)" ]; then \
		echo "Set PHASE to repository, package, pools, or daemon."; \
		exit 2; \
	fi
	@RGW_PHASE="$(PHASE)" ./bin/ansible.sh rgw-check

terraform:
	@./bin/terraform.sh
