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
	git pull && \
	cd ansible && ansible-playbook main.yml \
		--limit "$$host" \
		--user "$$ssh_user" \
		--ask-pass \
		--ask-become-pass \
		--extra-vars "tailscale_auth_key=$$tailscale_auth_key"

finalize:
	./scripts/finalize-setup

# Vars
#  --user and --ask-pass provides ssh user/password, needed if you don't have key-based ssh set up
#  --ask-become-pass provices sudo password, needed if you don't have it in secrets.yml
