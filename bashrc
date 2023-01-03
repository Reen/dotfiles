# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# load global bashrc if exists
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
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
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
export PROMPT_COMMAND="$PROMPT_COMMAND;history -a"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# make ls commands colorful
export CLICOLOR='yes'
# some aliases for ls
alias ls='ls --color=auto  --group-directories-first'
alias ll='ls -lah'
alias la='ls -a'
alias l='ls -la'
alias gzcat='gzip -cd'

if [[ -e ~/.bash_completion ]]; then
	BASH_COMPLETION="$HOME/.bash_completion"
	. ~/.bash_completion
fi

