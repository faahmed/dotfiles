# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

color_prompt=
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u \w % '
    #PS1='${debian_chroot:+($debian_chroot)}\u@\h \w % '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi



########## Begin my own stuff


set -o vi
# :set nofixendofline
export VISUAL="vim -c 'set wrap linebreak nolist'"
#export VISUAL=vim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# :/usr/local/share:/usr/local/share/:/usr/local/include/:/usr/local/lib/
export PYTHONPATH=$PYTHONPATH:/usr/local/share:/usr/local/include/:/usr/local/lib/

jwtd() {
    if [[ -x $(command -v jq) ]]; then
         jq -R 'split(".") | .[0],.[1] | @base64d | fromjson' <<< "${1}"
         echo "Signature: $(echo "${1}" | awk -F'.' '{print $3}')"
    fi
}


# in its currents state, this works in zsh but not bash
# update: bash doesnt treat a string all as one variable but zsh does
# string interpolation between zsh and bash has important differences
# this is referred to as 'Parameter Expansion' in zsh manual
# fix was adding quotes around $preview
function ack {
	matches=($(ag -H "$1" | grep -v '.*:.*'))
    #extension="${1##*.}"
    #echo $extension
	#matches=($(ag -H "$1" "$2" | grep -v '.*:.*'))
    #batcat -l ${file_name##*.} 
    preview='ag --numbers --color '"\"""$1""\""' {} | head -50'
	#echo $preview
file=`fzf --ansi --preview-window=:wrap --preview "$preview" <<- EOF
$(
for s in "${matches[@]}"
do
echo $s
done
)
EOF`
	[ -z "$file" ] && return 0
	echo "filename is $file"
	history -s "vim $file"
	#print -s "vim $file" <- zsh version
	eval "vim $file"
}

function o {
	file_to_open="$(fzf -i)"
	[ -z "$file_to_open" ] && return 0
	history -s "vim $file_to_open"
	#print -s "vim $file_to_open" <-- this is the zsh version
	eval "vim $file_to_open"
}

# on mac 10.12 or higher, remap the Insert Key to PageUp and the Delete key to Page Down.
## map the right alt key to page up EDIT: changing right alt to spacebar for hp 5131c
## map the right gui key to page down
## the first two rules make it easier to use leopold fc660c
## the second two rules make it easier to page up and down on hhkb
## last one is for remapping right alt key to space bar for packard bell 5131c
#hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000049,"HIDKeyboardModifierMappingDst":0x70000004B},{"HIDKeyboardModifierMappingSr    c":0x70000004C,"HIDKeyboardModifierMappingDst":0x70000004E}, {"HIDKeyboardModifierMappingSrc":0x7000000E6,"HIDKeyboardModifierMappingDst":0x70000002C}, {"HIDKeyboa    rdModifierMappingSrc":0x7000000E7,"HIDKeyboardModifierMappingDst":0x70000004E}]}'

# tmux vertical split
function tvs {
	eval "tmux split-window -h"
}

# tmux horizontal split
function ths {
	eval "tmux split-window -v"
}

# tmux kill pane
function tkp {
	eval "tmux kill-pane"
}


# tmux kill session
function tks {
	eval "tmux kill-session"
}

# tmux list sessions
# last active session will be highlighted if not called from a tmux
function tls {
    current_session=$(tmux display-message -p '#S')
    filter="grep --color=always -e \"^\" -e \"^${current_session}:.*\""
    # its important to treat this as an array here via the extra parens
    #local IFS='\n'
    local IFS=$'\n'
    #readarray sessions < "$(eval "tmux list-sessions | $filter")"
    #sessions=($(eval "tmux list-sessions | $filter"))
session_to_attach=`fzf --ansi <<- EOF
$(
for s in $(eval "tmux list-sessions | $filter")
do
echo $s
done
)
EOF`
    local IFS=':'
    read -a strarr <<< "$session_to_attach"
    echo "chosen session name is ${strarr[0]}"
    if [ -n "${strarr[0]}" ]; then tmux_attach "${strarr[0]}"; else return 0; fi
}

function tmux_attach {
    # 3. Attach if outside of tmux, switch if you're in tmux.
    if [[ -z "$TMUX" ]]; then
      tmux attach -t "$1"
    else
      tmux switch-client -t "$1"
    fi
}

# GIT SHORTCUTS

function gfp {
	eval "git fetch; git pull"
}

function gs {
	eval "git status"
}

function gac {
	# git add and commit
	eval "git add . -u; git commit -m $1"
}

function gb {
	eval "git branch"
}

function cl {
	eval "clear"
}

# tmux new window. Does nothing if not run from a tmux session
function tnw {
    eval "tmux command-prompt -p \"window name:\" \"new-window; rename-window '%%'\""
}



# SOME USEFUL COMMANDS
# check /usr/local/lib/pkgconfig/opencv4.pc etc

# finding out where libraries are

# COMPRESSING LIST OF FILES
# ls /mnt/c/Users/FA/Downloads/pay_statements*/* | zip -j all_pay_statements.zip -@
# ls /mnt/c/Users/FA/Downloads/pay_statements*/* | tar -cvf /mnt/c/Users/FA/Downloads/all_pay_statements.tar -T -

# OVERWRITING THE SYMLINK TO SH (default in WSL Ubuntu was dash)
# sudo ln -sf bash /bin/sh
# "It would be better to run sudo dpkg-reconffigure dash and choose the option to not use dash to provide /bin/sh. If you do it with dpkg, it will update other parts of your system (like the manpages) to match"
