#! /bin/bash

# changelog.sh
# manipulates git changelog to display banner art in

### DEFAULT ARGS ########
# Number of commits to apply
CYCLES=2

### COMMAND LINE ARGS ##
while [[ $# -gt 0 ]]; do
  case $1 in
    -c|--commits)
      CYCLES=$(($2))
      shift
      shift
      ;;
    *)
      shift
      ;;
  esac
done

### CONSTANTS #####

# Seconds in a week
WEEK="604800"
# Seconds in a day
DAY="86400"

# Calculates upper-right corner on graph
BASE_DATE=$(date --date="12:00 last sunday" +%s)
# Coordinates
declare -a COORDS=(
"72" "73" "74"
"78" "82"
"84" "88" "90"
"91" "92" "93" "94" "95" "96" "97"
"98" "102" "104"
"106" "110"
"114" "115" "116"

"141" "142"
"147" "150"
"154" "158"
"161" "162" "166"
"169" "170" "174"
"175" "176" "180"
"182" "186"
"189" "192"
"197" "198"

"221" "222"
"227" "229" "230"
"232" "233" "236" "237"
"238" "244"
"245" "246" "248" "251"
"252" "254" "255" "258"
"259" "260" "265"
"266" "271" "272"
"274" "275" "278" "279"
"283" "284" "285"
)
# Number of commits walked back
SIZE=${#COORDS[@]}


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
if [ -e "launched" ]; then
  undo $( echo "$SIZE * $CYCLES" | bc )
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
git push origin master --force
