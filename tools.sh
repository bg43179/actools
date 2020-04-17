#========================================================================
#Script Name  :
#Description  :
#Args         :
#Author       : Yahn-Chung (Andrew) Chen
#Email        : bg43179@gmail.com
#Reference    :
#========================================================================


# ====== Color Constant ======
# Reset
NC='\033[0m'             # Text Reset=
# Bold
BIYellow='\033[1;93m'    # Yellow
BIBlue='\033[1;94m'      # Blue
# ============================

function f
{
  while [ "$1" != "" ]; do
    # annotate the different lines for comparision
    # switch : with .*: to deal with color,
    # replace \n with | to concat lines for regex matching
    # truncate the last character |
    regex="$(git-diff-lines | awk '{gsub(/[:]/, ".*:")} { print $1":[0-9]+"};' | tr '\n' '|' | sed 's/.$//')"
    case "$1" in
    -c )
      echo -e "----${BIBlue} commited files start ${NC}------"
      git diff --name-only --relative master... | grep '\.rb$'
      git diff --name-only --relative master... | grep '\.rb$' | xargs rubocop --color | grep -E $regex
      echo -e "----${BIBlue} commited files end ${NC}------"
      shift ;;
    -u )
      echo -e "----${BIBlue} uncommited files found ${NC}------"
      git status -suall | awk '{print $2}'
      git status -suall | awk '{print $2}' | grep '\.rb$' | xargs rubocop --color | grep -E $regex
      echo -e "----${BIBlue} uncommited Files End ${NC}------"
      shift;;
    * )
      echo -e "----${BIBlue} commited files start ${NC}------"
      git diff --name-only --relative master... | grep '\.rb$'
      git diff --name-only --relative master... | grep '\.rb$' | xargs rubocop --color | grep -E $regex
      echo -e "----${BIBlue} commited files end ${NC}------"

      echo -e "----${BIBlue} uncommited files found ${NC}------"
      git status -suall | awk '{print $2}'
      git status -suall | awk '{print $2}' | grep '\.rb$' | xargs rubocop --color | grep -E $regex
      echo -e "----${BIBlue} uncommited Files End ${NC}------"
      shift ;;
    esac
  done
}

# annotate lines for git diff
function diff-lines() {
  local path=
  local line=
  while read; do
    esc=$'\033'
    if [[ $REPLY =~ ---\ (a/)?.* ]]; then
        continue
    elif [[ $REPLY =~ \+\+\+\ (b/)?([^[:blank:]$esc]+).* ]]; then
        path=${BASH_REMATCH[2]}
    elif [[ $REPLY =~ @@\ -[0-9]+(,[0-9]+)?\ \+([0-9]+)(,[0-9]+)?\ @@.* ]]; then
        line=${BASH_REMATCH[2]}
    elif [[ $REPLY =~ ^($esc\[[0-9;]+m)*([\ +-]) ]]; then
        echo "$path:$line:$REPLY"
        if [[ ${BASH_REMATCH[2]} != - ]]; then
            ((line++))
        fi
    fi
  done
}

# git diff for untracked files
function git-diff-untracked() {
  git ls-files --others --exclude-standard | while read -r i; do git diff --color -- /dev/null "$i"; done
}

# the files and lines different from master
function git-diff-lines() {
  # staged, untracked, commited
  declare -a arr=("git diff HEAD" "git-diff-untracked" "git diff --relative master...")

  for cond in "${arr[@]}"
  do
    ${cond} | diff-lines | grep '\.rb' | cut -f1,2 -d':'
  done
}

function debug() {
  regex="$(git-diff-lines | awk '{gsub(/[:]/, ".*")} { print $1":[0-9]+"};' | tr '\n' '|' | sed 's/.$//')"
  echo $regex
}

#========================================================================
#Script Name  : tall
#Description  : run test launcher for commited, staged and untracked changes
#Args         :
#Author       : Yahn-Chung (Andrew) Chen
#Email        : bg43179@gmail.com
#Reference    :
#========================================================================


function tall() # Run test launcher for both uncommited and commited tests
{
  echo -e "----${BIBlue} Uncommited File Start ${NC}------"
  git status -suall --porcelain | awk '{print $2}' | grep '_test\.rb$' | xargs test_launcher
  echo -e "----${BIBlue} Uncommited File End ${NC}------"

  echo -e "----${BIBlue} Commited File Start ${NC}------"
  git diff --name-only --relative master... | grep 'test\.rb$' | xargs test_launcher
  echo -e "----${BIBlue} Commited File End ${NC}------"
}
