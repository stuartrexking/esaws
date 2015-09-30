all:
	terraform apply
    
show:
	terraform show --module-depth=-1
    
destroy:
	terraform destroy --force