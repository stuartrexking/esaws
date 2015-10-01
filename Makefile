all: get
	terraform apply

get:
   	terraform get
    
show:
	terraform show --module-depth=-1
    
destroy:
	terraform destroy --force