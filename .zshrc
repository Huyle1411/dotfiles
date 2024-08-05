# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

bindkey '^ ' autosuggest-accept

# My configuration for competitive programming
alias hl="python3 /home/huyle/scripts/programming_tools.py"

build() {
    build.sh "$1" 2
}

gdbrun() {
    filename=$(basename -- "$1")
    filename="${filename%.*}"
    build.sh "$1" 2 && gdb "$filename"
}

run_opt() {
    /home/huyle/scripts/run_solution.sh "$1" "$2"
}

run() {
    run_opt "$1" 2
}

runsp() {
    /home/huyle/scripts/test_solution.sh "$1"
}

ulimit -s unlimited

# global path
export PATH=$PATH:~/scripts/
export PATH=$PATH:~/rofi-bluetooth/
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.config/emacs/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:/usr/local/ssl/bin
export PATH="$PATH:/opt/nvim-linux64/bin"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}
alias luamake=/home/huyle/lua-language-server/3rd/luamake/luamake

