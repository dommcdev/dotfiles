.PHONY: install install-local install-fresh finalize

install:
	git pull
	cd ansible && ansible-playbook main.yml

install-local:
	git pull
	cd ansible && ansible-playbook main.yml --limit "$$(hostname -s)"

install-machine:
	@read -rp "Inventory host name: " host; \
	if [ -z "$$host" ]; then printf 'Inventory host is required\n' >&2; exit 1; fi; \
	git pull && \
	cd ansible && ansible-playbook main.yml --limit "$$host"

install-fresh:
	@read -rp "Inventory host name: " host; \
	if [ -z "$$host" ]; then printf 'Inventory host is required\n' >&2; exit 1; fi; \
	read -rp "SSH user: " ssh_user; \
	if [ -z "$$ssh_user" ]; then printf 'SSH user is required\n' >&2; exit 1; fi; \
	read -rsp "Tailscale auth key: " tailscale_auth_key; \
	printf '\n'; \
	if [ -z "$$tailscale_auth_key" ]; then printf 'Tailscale auth key is required\n' >&2; exit 1; fi; \
	git pull && \
	cd ansible && ansible-playbook main.yml \
		--limit "$$host" \
		--user "$$ssh_user" \
		--ask-pass \
		--ask-become-pass \
		--extra-vars "tailscale_auth_key=$$tailscale_auth_key"

finalize:
	./scripts/finalize-setup
