# script to run the playbook for dummy selenium job on Jenkins Server (localhost)
PATH="$PATH:/usr/local/bin"
ansible-playbook --connection=local --inventory 127.0.0.1, --extra-vars "workspace=${WORKSPACE}" ./ansible/playbooks/pb_run_dummy_selenium_job.yaml