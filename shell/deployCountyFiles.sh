#!/usr/bin/bash
#
# deployCountyFiles
# 
# deploy Product and Pricing County files to dev, stage, pilot and prod.
#


usage () {
	echo "Usage: `basename $0` dev|stage|pilot|prod"
	exit $1
}

deploy () {
	# deploy here
	for IP in ${SERVER[@]}; do
		ssh Administrator@$IP "net stop 'World Wide Web Publishing Service'"
		ssh Administrator@$IP "net stop 'GHR Product Download Service'"
		ssh Administrator@$IP "net stop 'GHR Distribution Download Service'"
		# deploy code
		scp $HOME/pricing-service/GHRCodeDrops/Counties/* $IP:/home/Administrator/ghr/Counties/ 
		ssh Administrator@$IP "net start 'GHR Distribution Download Service'"
		ssh Administrator@$IP "net start 'GHR Product Download Service'"
		ssh Administrator@$IP "net start 'World Wide Web Publishing Service'"
	 done
}

dev () {
	echo "dev deploy"
	SERVER[0]="10.174.17.132";
	SERVER[1]="10.174.17.133";
	deploy;

}

stage () {
	echo "stage deploy"
	SERVER[0]="10.200.205.174";
	SERVER[1]="10.200.205.175";
	deploy;
}

pilot () {
	echo "pilot deploy"
	SERVER[0]="10.200.205.180";
	SERVER[1]="10.200.205.151";
	SERVER[2]="10.200.205.152";
	SERVER[3]="10.200.205.153";
	deploy;
}


prod () {
	echo "prod deploy"
	SERVER[0]="10.200.205.149";
	SERVER[1]="10.200.205.150";
	SERVER[2]="10.200.205.178";
	SERVER[3]="10.200.205.179";
	deploy;
}


# Get latest county files from cvs
cd $HOME/pricing-service/GHRCodeDrops/Counties/
cvs up


case $1 in
	"dev"	) dev;;
	"stage"	) stage;;
	"pilot"	) pilot;;
	"prod"	) prod;;
	* 	) usage;;
esac
