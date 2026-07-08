.PHONY: apply apply-local

apply:
	git pull
	ansible-playbook site.yml

apply-local:
	git pull
	ansible-playbook site.yml --limit "$$(hostname -s)"
