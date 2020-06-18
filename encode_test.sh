#!/bin/bash

# Most boring part with the bash parameter parsing...
usage() {
  echo "$(basename "$0") [-h] [-i dirname] -- script for testing vp9 best settings...

where:
    -h          : show this help text
    -i dirname  : use dirname as input directory"
1>&2; exit 1;
}

if [ -d "input" ]; then
  input="input"
else
  input=""
fi

while getopts ':hi:' option; do
  case "$option" in
    h) usage
       ;;
    i) input=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       usage
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       usage
       ;;
  esac
done
shift $((OPTIND - 1))

## Show commands
set -x

# List tool versions
convert --version
inkscape --version
ffmpeg -version

# List system basic information
uname -a
lscpu

# Unzip the input files if input var is "" (means no input directory)
if [ -z ${input} ]; then
  echo "Un7zip the input files in input default directory."
  7z x input.7z
else
  echo "Use \"${input}\" as input directory."
fi

export fps=20

# Create the gif animation
#time convert -loop 0 -delay 1x$fps ${input}.png output/output.gif

# 

# List output results
ls -al output
