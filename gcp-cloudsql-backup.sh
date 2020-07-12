#/bin/bash
>/opt/GCP-cloud-sql-metrics/cloudsql-metrics.txt

gcloud projects list| grep -v "NAME" | cut -d " " -f1 > project-list.txt
d=`date +%F| sed 's/-//g'`;
d1=2;
diff=`expr $d - $d1`;
echo $diff;
echo $d;
while read line

	do

#	echo "################# Project $line ######################"

	 for i in `gcloud sql instances list --project $line | grep -v "NAME" | cut -d " " -f1` 
		do	
		t=` gcloud sql instances list --project $line | grep -v "NAME" | cut -d " " -f1 | wc -l`
		echo $t
	#	gcloud sql instances list --project $line | grep -v "NAME" | cut -d " " -f1 > instance-list.txt
	#	echo "----------Instance Name $i -------------"
		v2=0;
	#if [ $t != 0 ] then
#		 v=`gcloud sql backups list --instance=$i --project $line |grep -v ID | awk '{ print $2 echo" "$4 }';`
		 v1=`gcloud sql backups list --instance=$i --project $line |grep -v ID | head -1 | awk '{ print $4 }';`
	         v2=`gcloud sql backups list --instance=$i --project $line |grep -v ID | awk '{ print $2}' | head -1 | cut -d ":" -f1| sed 's/-//g'| cut -d "T" -f1;`
#		 #v1= `echo $line $i $var| sed 's/SUCESSFUL/1/g'`
		P=`echo "$line" | sed 's/-/_/g'`;
		Instance=`echo "$i" | sed 's/-/_/g'`;
		echo $P
		echo "Project=$line Instance=$i $v2"
		echo "v2 value is $v2"
#		echo "$v4"
		s=`echo "SUCCESSFUL"`
		echo $s
		
		if [ -z "$v2" ]; then
		echo "cloudsql_no_backup{cloudsql_instance=\"$Instance\",Project = \"$P\"}" 1 >> /opt/GCP-cloud-sql-metrics/cloudsql-metrics.txt 
		elif [ $v1 == $s ]; then
		echo "cloudsql_backup_status{cloudsql_instance=\"$Instance\",Project = \"$P\"}" 0 >> /opt/GCP-cloud-sql-metrics/cloudsql-metrics.txt
		elif [ $v2 -gt $diff ]; then
		echo "cloudsql_backup_status{cloudsql_instance=\"$Instance\",Project = \"$P\"}" 0 >> /opt/GCP-cloud-sql-metrics/cloudsql-metrics.txt
#backup is done ok value 0 will be pushed
		else 
		echo "cloudsql_backup_status{cloudsql_instance=\"$Instance\",Project = \"$P\"}" 1 >> /opt/GCP-cloud-sql-metrics/cloudsql-metrics.txt
		fi
		>/opt/GCP-cloud-sql-metrics/cloudsql-metrics-final.txt
		cp -rp /opt/GCP-cloud-sql-metrics/cloudsql-metrics.txt /opt/GCP-cloud-sql-metrics/cloudsql-metrics-final.txt
 
#		v3=`echo $v | grep SUCCESSFUL` | sed 's/SUCCESSFUL/1/g'`
#		else 
#	else
#		continue;
#	fi
	done;
done <project-list.txt


