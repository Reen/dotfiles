# Test for an interactive shell. There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]]; then
	# Shell is non-interactive. Be done now
	return
fi
# Platform detection
platform='unknown'
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
	platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
	platform='mac'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
	platform='freebsd'
fi

# load global bashrc if exists
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
# check if I have my own usr/bin
if [ -d $HOME/usr/bin ]; then
	PATH=$HOME/usr/bin:$PATH
fi
# on TUC maschines, load intel and pgi compilers
if [[ $platform == 'linux' && -e /afs/tu-chemnitz.de/global/capp/intel-11.1 && -z "$PS1" ]]; then
	source /afs/tu-chemnitz.de/global/capp/intel-11.1/cc_setup.sh
	source /afs/tu-chemnitz.de/global/capp/intel-11.1/fc_setup.sh
	source /afs/tu-chemnitz.de/global/capp/pgi-6.1/setup.sh
fi
# on frogs load extra bashrc if exists
if [[ `hostname` = frog* ]]; then
#	echo "Welcome on `hostname`"
	if [ -f /cluster/rhab/.bashrc ]; then
		. /cluster/rhab/.bashrc
	fi
fi

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (git:\1)/'
}

#adjust promt to use git if we have it
if [[ -x git ]]; then
	export PROMPT_COMMAND='PS1="\[\033[0;33m\][\!]\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\u.mb: \`if [[ `pwd|wc -c|tr -d " "` > 18 ]]; then echo "\\W"; else echo "\\w"; fi\`\$(parse_git_branch)]\$\[\033[0m\] "; echo -ne "\033]0;`/bin/hostname -s`:`pwd`\007"'
else
	export PROMPT_COMMAND='PS1="\[\033[0;33m\][\!]\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`[\u.\h: \`if [[ `pwd|wc -c|tr -d " "` > 18 ]]; then echo "\\W"; else echo "\\w"; fi\`]\$\[\033[0m\] "; echo -ne "\033]0;`hostname -s`:`pwd`\007"'
fi

# common variables
export EDITOR=vim
export LESS="-erX"
export HISTCONTROL=erasedups
export HISTFILESIZE=1000000000
export HISTSIZE=1000000
# colorize grep
if echo hello|grep --color=auto l >/dev/null 2>&1; then
	export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
fi
shopt -s cdspell # This will correct minor spelling errors in a cd command.
shopt -s histappend
export PROMPT_COMMAND="$PROMPT_COMMAND;history -a"

mostUsed () {
	history|awk '{print $2}'|sort|uniq -c|sort -rn|head
}

frog () {
	if [ "$1" == "status" ]
	then
		for ((n=1; n < 12; n++))
		do
			name=`printf "frog%02d" "$n"`
			ssh -i ~/frog_rsa -fCT "rhab@${name}.physik.tu-chemnitz.de" "echo ${name}" '`uptime`'
		done
	else
		ssh `printf "rhab@frog%02d.physik.tu-chemnitz.de" "$1"`
	fi
}

# make ls commands colorful
export CLICOLOR='yes'
# some aliases for ls
if [[ -x /sw/bin/gls ]]; then
	alias ls='/sw/bin/gls --color=always --group-directories-first'
fi
if [[ $platform == 'linux' ]]; then
	alias ls='ls --color=auto'
fi
alias ll='ls -lah'
alias la='ls -a'
alias l='ls -la'
alias gzcat='gzip -cd'

if [[ -e ~/.bash_completion ]]; then
	BASH_COMPLETION="$HOME/.bash_completion"
	. ~/.bash_completion
fi

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

