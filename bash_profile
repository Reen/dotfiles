if [ -f /usr/local/server/intel/Composer/composerxe-2011.1.107/bin/compilervars.sh ]; then
        source /usr/local/server/intel/Composer/composerxe-2011.1.107/bin/compilervars.sh intel64
fi

if [ -f /usr/local/server/intel/impi_3.2.2/bin64/mpivars.sh ]; then
        source /usr/local/server/intel/impi_3.2.2/bin64/mpivars.sh
fi

if [ -f ~/.bashrc ]; then
      . ~/.bashrc
fi
. ~/.profile
