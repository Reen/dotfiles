# ~/.bash_profile URZ-Version 1.0 22.02.2002
###########################################################################
# Hinweise zur Benutzung dieser Datei finden Sie unter
# http://www.tu-chemnitz.de/urz/system/shells/startup/
###########################################################################
# Eigene Ergänzungen hier einfügen:

CLASSPATH=.:/afs/tu-chemnitz.de/home/urz/r/rhab/PUBLIC/cs1
export CLASSPATH

###########################################################################
# Ab hier nichts mehr ändern
###########################################################################
if [ -z "$urz_remshell" ]; then
  if [ -f ~/.bashrc ]; then
	. ~/.bashrc
  fi
fi

PATH=/afs/tu-chemnitz.de/home/urz/r/rhab/PRIVAT/opt/bin:$PATH

#if [[ `hostname` = frog* ]]; then
#	echo "Welcome on `hostname`"
#	if [ -f /cluster2/rhab/.bashrc ]; then
#		. /cluster2/rhab/.bashrc
#	fi
#fi
