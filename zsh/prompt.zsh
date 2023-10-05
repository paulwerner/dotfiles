autoload colors && colors

if (( $+commands[git] ))
then
    git="$commands[git]"
else
    git="/usr/bin/git"
fi

git_branch() {
    echo $($git rev-parse --abbrev-ref HEAD)
}

git_dirty() {
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ "$st" =~ ^nothing ]]
    then
      echo "on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo "on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
 echo "${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo ""
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%} "
  fi
}

user_info() {
  echo "%{$fg[green]%}%n@%m%{$reset_color%}"
}

directory_name(){
  echo "%{$fg_bold[cyan]%}%1/%{$reset_color%}"
}

export PROMPT=$'$(user_info) $(directory_name) $(git_dirty)$(need_push) %# %b%f%k'

precmd() {
  title "zsh" "%m" "%55<...<%~"
  print
}