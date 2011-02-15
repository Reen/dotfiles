# ~/.bashrc URZ-Version 1.0 22.02.2002
###########################################################################
# Hinweise zur Benutzung dieser Datei finden Sie unter
# http://www.tu-chemnitz.de/urz/system/shells/startup/
###########################################################################
# Eigene Ergänzungen nur am Ende der Datei! 
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
###########################################################################
# Eigene Ergänzungen hier einfügen:
PATH=$HOME/usr/bin:$PATH
#if [ -z "$PS1" ]; then
	#source /afs/tu-chemnitz.de/global/capp/intel-11.1/cc_setup.sh
	#source /afs/tu-chemnitz.de/global/capp/intel-11.1/fc_setup.sh 
	#source /afs/tu-chemnitz.de/global/capp/pgi-6.1/setup.sh
#fi

#if [ -f /usr/local/server/intel/Composer/composerxe-2011.1.107/bin/compilervars.sh ]; then
#	source /usr/local/server/intel/Composer/composerxe-2011.1.107/bin/compilervars.sh intel64
#fi

if [[ `hostname` = frog* ]]; then
#       echo "Welcome on `hostname`"
        if [ -f /cluster2/rhab/.bashrc ]; then
                . /cluster2/rhab/.bashrc
        fi
fi
export PROMPT_COMMAND='PS1="\[\033[0;33m\][\!]\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\u.\h: \`if [[ `pwd|wc -c|tr -d " "` > 18 ]]; then echo "\\W"; else echo "\\w"; fi\`]\$\[\033[0m\] "; echo -ne "\033]0;`hostname -s`:`pwd`\007"'
export LESS="-erX"
export HISTCONTROL=erasedups
export HISTFILESIZE=1000000000
export HISTSIZE=1000000
#export PYTHONPATH="/afs/tu-chemnitz.de/home/urz/r/rhab/lib/python:/afs/tu-chemnitz.de/home/urz/r/rhab/lib64/python"
shopt -s cdspell # This will correct minor spelling errors in a cd command.
shopt -s histappend

mostUsed () {
        history|awk '{print $4}'|sort|uniq -c|sort -rn|head
}

alias ll='ls -lah'
alias la='ls -a'
alias l='ls -la'
alias gzcat='gzip -cd'

tar_bz2_rm () {
	if [ "$1" != "" ]; then
		FOLDER_IN=`echo $1 |sed -e 's/\/$//'`;
		FILE_OUT="$FOLDER_IN.tar.bz2";
		FOLDER_IN="$FOLDER_IN/";
		echo "Compressing $FOLDER_IN into $FILE_OUT";
		echo "tar cjf $FILE_OUT $FOLDER_IN";
		tar -cjf "$FILE_OUT" "$FOLDER_IN";
		echo "Removing $FOLDER_IN";
		rm -rf $FOLDER_IN
		echo "Done.";
    fi
}
if [ -e ~/usr/autojump/autojump.bash ]; then
    source ~/usr/autojump/autojump.bash
fi

