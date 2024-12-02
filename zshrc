# Enable Powerlevel10k instant prompt. This should stay near the top for best performance.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Add Homebrew binary path to the $PATH variable.
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$PATH:/Users/debopriyadebroy/Developer/flutter/bin/"

# Set JAVA_HOME to the specific Java version and update $PATH to include Java binaries.
export JAVA_HOME=$(/usr/libexec/java_home -v 22.0.1)
export PATH=$JAVA_HOME/bin:$PATH

# Set the path to Oh-My-Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Load Powerlevel10k theme.
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment to make completion case-sensitive (off by default).
# CASE_SENSITIVE="true"

# Uncomment to make completion hyphen-insensitive (e.g., my-app and my_app treated the same).
# HYPHEN_INSENSITIVE="true"

# Uncomment to disable automatic updates for Oh-My-Zsh.
# zstyle ':omz:update' mode disabled

# Uncomment to enable automatic updates for Oh-My-Zsh without asking.
# zstyle ':omz:update' mode auto

# Uncomment to set auto-update frequency (in days). Default is 13 days.
# zstyle ':omz:update' frequency 13

# Uncomment if pasting URLs or text causes issues in the terminal.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment to disable colored output for the `ls` command.
# DISABLE_LS_COLORS="true"

# Uncomment to prevent the terminal title from being auto-set.
# DISABLE_AUTO_TITLE="true"

# Uncomment to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment to display red dots (or another custom string) while waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment to disable checking the status of untracked files in Git repositories.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment to set custom time format for the history command output.
# HIST_STAMPS="mm/dd/yyyy"

# Define Oh-My-Zsh plugins to load. Zsh-Autosuggestions and Zsh-Syntax-Highlighting are included.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting vscode)

# Source the Oh-My-Zsh configuration.
source $ZSH/oh-my-zsh.sh

# Node Version Manager (NVM) configuration for Node.js.
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads NVM.
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads NVM bash completion.

# Powerlevel10k prompt configuration.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(zoxide init zsh)"

# Aliases for `lsd` (a modern replacement for `ls`).
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias cd='z'


#Aliases and functions for docker
function dnames-fn {
	for ID in `docker ps | awk '{print $1}' | grep -v 'CONTAINER'`
	do
    	docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}

function dip-fn {
    echo "IP addresses of all named running containers"

    for DOC in `dnames-fn`
    do
        IP=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$DOC"`
        OUT+=$DOC'\t'$IP'\n'
    done
    echo -e $OUT | column -t
    unset OUT
}

function dex-fn {
	docker exec -it $1 ${2:-bash}
}

function di-fn {
	docker inspect $1
}

function dl-fn {
	docker logs -f $1
}

function drun-fn {
	docker run -it $1 $2
}

function dcr-fn {
	docker compose run $@
}

function dsr-fn {
	docker stop $1;docker rm $1
}

function drmc-fn {
       docker rm $(docker ps --all -q -f status=exited)
}

function drmid-fn {
       imgs=$(docker images -q -f dangling=true)
       [ ! -z "$imgs" ] && docker rmi "$imgs" || echo "no dangling images."
}

# in order to do things like dex $(dlab label) sh
function dlab {
       docker ps --filter="label=$1" --format="{{.ID}}"
}

function dc-fn {
        docker compose $*
}

function d-aws-cli-fn {
    docker run \
           -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
           -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
           -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
           amazon/aws-cli:latest $1 $2 $3
}

alias daws=d-aws-cli-fn
alias dc=dc-fn
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcr=dcr-fn
alias dex=dex-fn
alias di=di-fn
alias dim="docker images"
alias dip=dip-fn
alias dl=dl-fn
alias dnames=dnames-fn
alias dps="docker ps"
alias dpsa="docker ps -a"
alias drmc=drmc-fn
alias drmid=drmid-fn
alias drun=drun-fn
alias dsp="docker system prune --all"
alias dsr=dsr-fn

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
alias path='echo -e ${PATH//:/\\n}'         # Echo all executable Paths
alias zshc='open ~/.zshrc'
