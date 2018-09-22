IMAGENAME=$1
vCnt=`docker ps -a | grep -c ${IMAGENAME}`

if [[ vCnt -gt 0 ]]; then
	echo "Stopping container ${IMAGENAME}..."
	docker ps | grep ${IMAGENAME} | awk '{print $1 }' | xargs -I {} docker stop {}
	echo "Removing container ${IMAGENAME}..."
	docker rm -f $(docker ps -a  | grep ${IMAGENAME} | awk '{print $1 }')
	#docker ps -a | awk '{ print $1,$2 }' | grep ${IMAGENAME} | awk '{print $1 }' | xargs -I {} docker rm {}
else
	echo "Nao existe container a ser removido."
fi

