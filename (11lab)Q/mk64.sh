#!/bin/bash
  nasm -felf64 "$1.asm"  
  if [ $? -eq 0 ]
   then
    ld "$1.o" -o "$1"
  fi
  if [ $? -eq 0 ]
   then
    ./"$1"
  fi
