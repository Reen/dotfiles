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

if [ -d /opt/gnuplot/bin ]; then
	PATH=/opt/gnuplot/bin:$PATH
fi

if [ -d /opt/parallel/bin ]; then
	PATH=/opt/parallel/bin:$PATH
fi

if [ -d /usr/local/cuda ]; then
	PATH=/usr/local/cuda/bin:$PATH
fi

if [ -d /usr/local/texlive/2013/bin/x86_64-linux ]; then
	PATH=/usr/local/texlive/2013/bin/x86_64-linux:$PATH
	INFOPATH=/usr/local/texlive/2013/texmf-dist/doc/info:$INFOPATH
	MANPATH=/usr/local/texlive/2013/texmf-dist/doc/man:$MANPATH
fi

# check if I have my own usr/bin
if [ -d $HOME/usr/bin ]; then
	PATH=$HOME/usr/bin:$PATH
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
export HISTCONTROL=erasedups:ignorespace
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

# make ls commands colorful
export CLICOLOR='yes'
# some aliases for ls
if [[ -x /sw/bin/gls ]]; then
	alias ls='/sw/bin/gls --color=always --group-directories-first'
fi
if [[ $platform == 'linux' ]]; then
	alias ls='ls --color=auto  --group-directories-first'
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
