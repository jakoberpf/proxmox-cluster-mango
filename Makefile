.PHONY: help setup lint syntax audit plan apply rgw-audit rgw-plan csi-plan sdn-plan proxy-plan terraform

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
	@echo "  csi-plan               Preview the gated Ceph CSI play"
	@echo "  sdn-plan               Preview the gated SDN host play"
	@echo "  proxy-plan             Preview the gated reverse proxy play"

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

proxy-plan:
	@./bin/ansible.sh proxy-check

csi-plan:
	@./bin/ansible.sh csi-check

sdn-plan:
	@./bin/ansible.sh sdn-check

terraform:
	@./bin/terraform.sh
