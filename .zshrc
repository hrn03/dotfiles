# original zsh command
if [ -d ~/.zsh_custom ]; then
    for f in ~/.zsh_custom/*.zsh; do
        source "$f"
    done
fi
peeking_cat

# ==============================
# Powerlevel10k Instant Prompt
# ==============================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==============================
# Oh-my-zsh Setup
# ==============================
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"

# Standard Oh-my-zsh plugins
plugins=(git z colored-man-pages)

# Load Oh-my-zsh engine
source "$ZSH/oh-my-zsh.sh"

# ==============================
# Environment Variables & Path
# ==============================
export PATH="/opt/local/bin:/opt/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/Applications/kitty.app/Contents/MacOS:$PATH"
export PATH="$HOME/.local/lib/npm/bin:$PATH"
export JAVA_HOME=/opt/local/Library/Java/JavaVirtualMachines/openjdk11-zulu/Contents/Home

# Custom word characters for ^W
export WORDCHARS='*?_-.[]~=&;!#$%^()<'

# ==============================
# Zsh Options & Completion Settings
# ==============================
autoload run-help
autoload -U compinit && compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# Colorize completion menu
zstyle ':completion:*default' menu select=1
zstyle ':completion:*' list-colors di=36 ln=35 ex=31 '=*.c=33' '=*.py=33'
# Ignore specific file extensions
fignore=(.o .aux .log .bbl .blg .lof .dvi .fls .fdb_latexmk .synctex.gz .lot .toc .out .a\~)

# Shell options
setopt IGNORE_EOF        # Prevent logout on Ctrl-D
setopt CORRECT_ALL       # Enable command auto-correction
SPROMPT="correct> %R -> %r [nyae]? "
setopt AUTO_CD           # Change directory without 'cd' command
setopt AUTO_PUSHD        # Automatically push directories to stack
setopt HIST_IGNORE_DUPS  # Do not record duplicate commands
setopt HIST_REDUCE_BLANKS
setopt HIST_NO_STORE     # Do not store 'history' command
setopt NUMERIC_GLOB_SORT # Sort filenames numerically
setopt PUSHD_IGNORE_DUPS # Prevent duplicate directories in stack
setopt NO_CLOBBER        # Prevent file overwriting

# ==============================
# Keybindings
# ==============================
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
bindkey '^ ' autosuggest-accept

# ==============================
# Functions
# ==============================
# Move files to Trash
del() {
    mv $* ~/.Trash
}

# backup my nvim config
# backup my neovim config. you can restore the config by using restore-nvim.zsh
backup-nvim() {
  local timestamp=$(date "+%Y-%m-%d-%H%M")
  echo "Backup following directories"
  echo "  ~/.config/nvim      => ~/.config/nvim.${timestamp}"
  echo "  ~/.local/share/nvim => ~/.local/share/nvim.${timestamp}"
  echo "  ~/.local/state/nvim => ~/.local/state/nvim.${timestamp}"
  echo "  ~/.cache/nvim       => ~/.cache/nvim.${timestamp}"
 
  # required
  mv ~/.config/nvim ~/.config/nvim.${timestamp}
 
  # optional but recommended
  mv ~/.local/share/nvim ~/.local/share/nvim.${timestamp}
  mv ~/.local/state/nvim ~/.local/state/nvim.${timestamp}
  mv ~/.cache/nvim ~/.cache/nvim.${timestamp}
}

# restore my nvim config which is created by backupnvim function
restore-nvim() {
    local backup_array=(${(f)"$(command ls -ld ~/.config/nvim.* | sort -nr | sed -e 's/.*nvim/nvim/')"})

    if [ $#backup_array = 0 ]; then
        echo "No backup directory found"
        return 1
    fi
    for ((i = 1; i <= $#backup_array; i++)) print -r -- "[$i] $backup_array[i]"

        # select backup directory
        echo ""
        echo -n "Select index: "
        re='^[0-9]+$'
        read index
        if ! [[ $index =~ $re ]] ; then
            echo "Error: Not a number"
            return 1;
        fi

  echo ""
  echo "Restore following directories"
  echo ""
  echo "  $backup_config      => ~/.config/nvim"
  echo "  $backup_share => ~/.local/share/nvim"
  echo "  $backup_state => ~/.local/state/nvim"
  echo "  $backup_cache       => ~/.cache/nvim"
  echo ""
  echo "This operation will overwrite the above directories."
  echo -n "Proceed? [y/N] "

  read yesno
  # execute
  if [ $yesno = "y" -o $yesno = "Y" ]; then
    if [ -d ~/.config//nvim ]; then
      rm -rf ~/.config/nvim
    fi
    if [ -d ~/.local/share/nvim ]; then
      rm -rf ~/.local/share/nvim
    fi
    if [ -d ~/.local/state/nvim ]; then
      rm -rf ~/.local/state/nvim
    fi
    if [ -d ~/.cache//nvim ]; then
      rm -rf ~/.cache/nvim
    fi
    mv $backup_config ~/.config/nvim
    mv $backup_share  ~/.local/share/nvim
    mv $backup_state  ~/.local/state/nvim
    mv $backup_cache  ~/.cache/nvim
  fi
  }

# ==============================
# Aliases
# ==============================
alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"

alias emacs="/Applications/MacPorts/Emacs.app/Contents/MacOS/emacs -nw"
alias ez="emacs ~/.zshrc"
alias sz="source ~/.zshrc"
alias nz="nvim ~/.zshrc"

alias gcc="gcc -Wall -O0"
alias sv="source ~/venvs/util310/bin/activate"
alias gitlog='git log --oneline --graph --decorate '

if [[ $TERM == 'xterm-kitty' ]]; then
  alias ssh='kitten ssh'
fi

if [[ $(command -v eza) ]]; then
  alias ls='eza --icons --git --group-directories-first'
  alias ll='eza -al --icons --git --group-directories-first'
  alias lt='eza -T --icons --git --group-directories-first'
fi

if [[ $(command -v bat) ]]; then
  alias cat='bat --paging=never'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

if [[ $(command -v fzf) ]]; then
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat --style=numbers --color=always --line-range :500 {}"'
fi

# ==============================
# THEME & PLUGINS
# ==============================
P10K_THEME="${ZSH_CUSTOM}/themes/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f "$P10K_THEME" ]] && source "$P10K_THEME"
AUTOSUGGEST_PATH="${ZSH_CUSTOM}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
SYNTAX_PATH="${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$AUTOSUGGEST_PATH" ]] && source "$AUTOSUGGEST_PATH"
[[ -f "$SYNTAX_PATH" ]] && source "$SYNTAX_PATH"
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# SSH Fallback Prompt
if [ -n "$SSH_CONNECTION" ] && [[ ! -f "$P10K_THEME" ]]; then
  PROMPT="%F{#A58CDC}%T %n [%f%F{#A9CEEC}%1d%f%F{#A58CDC}]%f@%m > " 
fi
