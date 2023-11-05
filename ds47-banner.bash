#! /bin/bash

# changelog.sh
# manipulates git changelog to display banner art in

### CONSTANTS #####

# Seconds in a week
WEEK="604800"
# Seconds in a day
DAY="86400"

# Calculates upper-right corner on graph
BASE_DATE=$(date --date="12:00 last sunday" +%s)
# Coordinates
declare -a COORDS=(
"73" "74" "75" "76"
"80" "83"
"84" "85" "86" "87" "88" "89" "90"

"100" "101" "102" "104"
"107" "109" "111"
"114" "116" "117" "118"

"128" "129" "130" "131" "132"
      "136"
      "143" "144" "145" "146"
      "150" 
      "157" "158" "159" "160"
 
"169" "171" "172" "173" "174"

"183"
"189" "190" "191" "192" "193" "194" "195"
"197"

"210" "211" "212" "213" "214" "215" "216"
"220"
"227" "228" "229" "230"

"238" "239" "240" "241"
"248"
"253" "254" "255" "256" "257" "258"
"262"

"266"
"273"
"280"
"287" "288" "289" "290" "291" "292" "293"
)
# Number of commits walked back
SIZE=${#COORDS[@]}

### DEFAULT ARGS AND CLI PARSING ########
# Number of commits to apply
CYCLES=2
CLEAR_ONLY=0
### COMMAND LINE ARGS ##
while [[ $# -gt 0 ]]; do
  case $1 in
    -c|--commits)
      CYCLES=$(($2))
      shift
      shift
      ;;
    --clear_only)
      CLEAR_ONLY=1
      shift
      ;;
    *)
      shift
      ;;
  esac
done

### FUNCTIONS #####

# undo prior changelog
# INPUTS:
#   @$1 - Num_COMMITS   Specifies number of commits to undo
function undo {
  echo 'Clearing old changelog'
  git reset --hard "HEAD~$1"
}

# Modify apply a time/date change and push
# INPUTS:
#   @$1 - Date    The day that is beind updated
#                 Used to touch README file to add commits
function update {
  NUM=$1
  for i in $(seq $CYCLES); do
    echo "Updating to date: $NUM"
    let "NUM = $NUM + 1"
    echo "NUM: $NUM"
    if [ -e launched ]; then
      git rm launched
    else
      touch launched --date="@$NUM"
      git add launched
    fi 
    git commit -m 'A banner-drawing update' --date="@$NUM"
  done
}



### MAIN EXECUTION ###############

#If the script has run once before, delete previous occurence
if [ -e .git ]; then
  undo $( echo "$SIZE * $CYCLES" | bc )
fi
# If the script was only run to clear, stop here
if [ $CLEAR_ONLY -eq 1 ]; then
  exit 0
fi

echo $BASE_DATE
#Set date back in time (to upper left)
let "BASE_DATE = $BASE_DATE - ( 52*$WEEK)"

# Update for each element in the COORDS structure
for a in ${COORDS[*]}; do
  update $( echo "$BASE_DATE+($a * $DAY)"|bc )
done

# Finish by pushing to github
# Force is necessary to delete items
git push origin main --force
