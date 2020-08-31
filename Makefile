cluster:
	k3d cluster create alpha \
	    -p 80:80@loadbalancer \
	    -p 443:443@loadbalancer \
	    -p 30000-32767:30000-32767@server[0] \
	    -v /etc/machine-id:/etc/machine-id:ro \
	    -v /var/log/journal:/var/log/journal:ro \
	    -v /var/run/docker.sock:/var/run/docker.sock \
	    --agents 3

taint:
	kubectl taint nodes k3d-labs-server-0 key=value:NoSchedule
jenkins:
	git clone https://github.com/saloyiana/level-2-project.git
	cd level-2-project/jenkins/
	. jenkins
	kubectl create rolebinding jenkins --clusterrole=admin --serviceaccount=jenkins:jenkins --namespace=app
