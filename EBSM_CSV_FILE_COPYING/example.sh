#!/bin/bash

dirOptBash="/home/$USER/logmover/bash"
dirHome="/home/$USER/logs"
dir4days=$dirHome"/4archiveDays"
dir5months=$dirHome"/5archiveMonths"
fD="date +%Y-%m-%d"
fT="date +%T"
[[ $2 -gt 0 ]] && x=$2 || x=2
LAST_X_MONTHS=`date +%Y-%m -d "$x months ago"`
currDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
suffixes=("" a b c d e f g h i j k l m n o p q r s t u v w x y z)

clear_logs_function(){
  count=1
  while [ -n "$1" ]
  do
    if [ -d "$dir4days/$1/$2/" ]
	  then
      cd $dir4days/$1/$2/
		  ls -alh
      suffIndex=0
		  fdName="$2_$1_$LAST_X_MONTHS${suffixes[0]}.tar"
		  while [ -f $dir5months/$1/$2/$fdName ]
		  do
		    let "suffIndex++"
		    echo "!!! $fdName exists"
		    fdName="$2_$1_$LAST_X_MONTHS${suffixes[$suffIndex]}.tar"
		  done
		  if [ -z "$(ls -A $2_$1_$LAST_X_MONTHS*)" ]; then
		    echo "no files exist $dir4days/$1/$2/$2_$1_$LAST_X_MONTHS*"
		  else
		    tar -cvf $fdName $2_$1_$LAST_X_MONTHS*
		    ls -alh *.tar
		    mv $fdName $dir5months/$1/$2/
		    ls -alh $dir5months/$1/$2/
		    rm -rf $2_$1_$LAST_X_MONTHS-*
		    ls -alh
		  fi
	  else
		  echo "--------------------------------------------------------------------------------------"
		  echo "Folder $dir4days/$1/$2/ does not exist"
		  echo "--------------------------------------------------------------------------------------"
	  fi
    count=$(($count + 2 ))
    shift
    shift
  done
}

echo "`$fD` `$fT` script started for $LAST_X_MONTHS month"
clear_logs_function $(cat $dirOptBash/$1)

echo "`$fD` `$fT` logmover-daymonth.sh triggered"
$dirOptBash/logmover-daymonth.sh $USER

cd $currDir
echo "`$fD` `$fT` script ended"