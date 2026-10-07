HELM ?= helm
SNAPSHOT_DIR ?= tests/snapshots
RELEASE ?= ccf

# Snapshots render with pinned image tags so that ccf-bump changing appVersion
# or ui.image.tag does not change them. The default tags are checked separately.
APP_SNAPSHOT_ARGS := --set api.image.tag=snapshot --set ui.image.tag=snapshot
AGENT_SNAPSHOT_ARGS := --set image.tag=snapshot

# app_version(chart dir): the chart's appVersion, without quotes.
app_version = $(shell awk '/^appVersion:/ { gsub(/"/, "", $$2); print $$2 }' $(1)/Chart.yaml)

.PHONY: helm.test
helm.test: helm.test.app helm.test.agent

.PHONY: helm.lint
helm.lint:
	$(HELM) lint charts/*

# mock-app chart
.PHONY: helm.test.app
helm.test.app:
	$(HELM) lint charts/mock-app
	test -n "$(call app_version,charts/mock-app)" # appVersion must be set
	$(HELM) template $(RELEASE) charts/mock-app $(APP_SNAPSHOT_ARGS) | diff -u $(SNAPSHOT_DIR)/mock-app.yaml -
	$(HELM) template $(RELEASE) charts/mock-app \
		| grep -q 'image: "ghcr.io/compliance-framework/mock-api:$(call app_version,charts/mock-app)"'
	$(HELM) template $(RELEASE) charts/mock-app \
		| grep -Eq 'image: "ghcr.io/compliance-framework/mock-ui:[^":]+"'
	@echo "mock-app chart OK"

.PHONY: helm.snapshot.app
helm.snapshot.app:
	$(HELM) template $(RELEASE) charts/mock-app $(APP_SNAPSHOT_ARGS) > $(SNAPSHOT_DIR)/mock-app.yaml

# mock-agent chart
.PHONY: helm.test.agent
helm.test.agent:
	$(HELM) lint charts/mock-agent
	test -n "$(call app_version,charts/mock-agent)" # appVersion must be set
	$(HELM) template $(RELEASE) charts/mock-agent $(AGENT_SNAPSHOT_ARGS) | diff -u $(SNAPSHOT_DIR)/mock-agent.yaml -
	$(HELM) template $(RELEASE) charts/mock-agent \
		| grep -q 'image: "ghcr.io/compliance-framework/mock-agent:$(call app_version,charts/mock-agent)"'
	@echo "mock-agent chart OK"

.PHONY: helm.snapshot.agent
helm.snapshot.agent:
	$(HELM) template $(RELEASE) charts/mock-agent $(AGENT_SNAPSHOT_ARGS) > $(SNAPSHOT_DIR)/mock-agent.yaml
