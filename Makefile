.PHONY: apply apply-local

install:
	git pull
	ansible-playbook ansible/main.yml

install-local:
	git pull
	ansible-playbook ansible/main.yml --limit "$$(hostname -s)"

#For machines without passwordless ssh
#ansible-playbook ansible/main.yml --limit machine_name_or_ip --ask-pass
