.PHONY: apply apply-local

apply:
	git pull
	ansible-playbook main.yml

apply-local:
	git pull
	ansible-playbook main.yml --limit "$$(hostname -s)" --connection local
