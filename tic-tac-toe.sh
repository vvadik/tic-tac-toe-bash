#!/usr/bin/bash

player_1="x"
player_2="o"

turn=1
game_on=true

#invisible 9 chars U+2003
moves=(                   )

show_help(){
  echo ""
  echo "Аргументы запуска"
  echo "x - компьютер играет за крестики и ходит первым"
  echo "o - компьютер играет за нолики и ходит вторым"
  echo "pvp - игра для 2х друзей"
  echo ""
  echo "Чтобы сходить введи порядковый номер клетки"
  echo ""
  echo " 1 | 2 | 3 "
  echo "-----------"
  echo " 4 | 5 | 6 "
  echo "-----------"
  echo " 7 | 8 | 9 "
  echo "==========="
}

print_board () {
  clear
  echo " ${moves[0]} | ${moves[1]} | ${moves[2]} "
  echo "-----------"
  echo " ${moves[3]} | ${moves[4]} | ${moves[5]} "
  echo "-----------"
  echo " ${moves[6]} | ${moves[7]} | ${moves[8]} "
  echo "==========="
}

process_game(){
  if [[ "$comp" == "pvp" ]]; then 
    pvp
  else
    computer_vc_man
  fi
}

computer_vc_man(){
  if [[ "$comp" == "x" ]]; then
    if [[ $((turn % 2)) == 0 ]]
    then
      echo -n "PICK A SQUARE: "
      read square

      make_move $square $player_2 computer_vc_man
    else
      make_move $(( RANDOM % 10 )) $player_1 computer_vc_man
    fi
  else
    if [[ $((turn % 2)) == 1 ]]
    then
      echo -n "PICK A SQUARE: "
      read square

      make_move $square $player_1 computer_vc_man
    else
      make_move $(( RANDOM % 10 )) $player_2 computer_vc_man
    fi
  fi
}

pvp(){
  if [[ $((turn % 2)) == 0 ]]
  then
    play=$player_2
    echo -n "PLAYER 2 PICK A SQUARE: "
  else
    play=$player_1
    echo -n "PLAYER 1 PICK A SQUARE: "
  fi

  read square

  make_move $square $play pvp
}

make_move(){
  square=$1
  space=${moves[($square -1)]} 

  if [[ ! $square =~ ^-?[1-9]+$ ]] || [[ "$space" != " " ]]
  then 
    echo "Not a valid square."
    $3
  else
    moves[($square -1)]=$2
    ((turn=turn+1))
  fi
}

check_match() {
  if [[ $game_on == false ]]; then return; fi

  if [[ "${moves[$1]}" == "${moves[$2]}" ]] && \
     [[ "${moves[$2]}" == "${moves[$3]}" ]] && \
     [[ "${moves[$1]}" != " " ]]; then
    game_on=false
  fi

  if [[ $game_on == false ]]; then
    if [[ ${moves[$1]} == 'x' ]];then
      echo "X wins!"
      return
    else
      echo "O wins!"
      return
    fi
  fi
}

check_winner(){
  check_match 0 1 2
  check_match 3 4 5
  check_match 6 7 8
  check_match 0 4 8
  check_match 2 4 6
  check_match 0 3 6
  check_match 1 4 7
  check_match 2 5 8
  if [[ $turn -gt 9 ]] && [[ $game_on == true ]]; then 
    game_on=false
    echo "Its a draw!"
    return
  fi
}


if [[ "$1" == "-h" ]]; then
    show_help
    exit 0
fi

if [[ "$1" != "x" ]] && [[ "$1" != "o" ]] && [[ "$1" != "pvp" ]]; then
  echo "Invalid args"
  show_help
  exit 1
fi

comp=$1

print_board
while $game_on
do
  process_game
  print_board
  check_winner
done
