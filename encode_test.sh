#!/bin/bash

# Most boring part with the bash parameter parsing...
# TODO update the blabla below (convert *.png to ...)
# TODO -o is not implemented yet has need to deal with the rm -rf output (risk to delete user files)
usage() {
  echo "$(basename "$0") [-h] [-i dirname] -- script for testing vp9 best settings... blablabla

where:
    -h          : show this help text
    -i dirname  : use dirname as input directory (default: 'input/')
    -o dirname  : use dirname as output directory (default: 'output/') - NOT AVAILABLE YET -"
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
  export input="input"
else
  echo "Use \"${input}\" as input directory."
fi

# TODO find a better way to give the fps parameter
export fps=20

# TODO find a better way for the output
export output="$PWD/output"

mkdir -p ${output}

# Create the gif animation with ImageMagick convert
time convert -loop 0 -delay 1x$fps ${input}/*.png ${output}/imagemagick_default.gif
time convert -loop 0 -delay 1x$fps -layers Optimize ${input}/*.png ${output}/imagemagick_layers_optimize.gif

# Create the gif animation with gifsicle
time gifsicle -O1 ${output}/imagemagick_default.gif -o ${output}/gifsicle_o1.gif
time gifsicle -O2 ${output}/imagemagick_default.gif -o ${output}/gifsicle_o2.gif
time gifsicle -O3 ${output}/imagemagick_default.gif -o ${output}/gifsicle_o3.gif
time gifsicle -O3 --colors 256 ${output}/imagemagick_default.gif -o ${output}/gifsicle_o3_colors_256.gif

# Prepare ffmpeg env
# TODO explain the reason of next line
dir=$PWD
cd ${input}
export ffmpeg_params="-y -nostdin -framerate $fps -pattern_type glob"

# Create the gif animation with ffmpeg
time ffmpeg ${ffmpeg_params} -i '*.png' ${output}/ffmpeg_default.gif

# Create webm vp9 with ffmpeg in various configurations (1-pass)
time ffmpeg ${ffmpeg_params} -i '*.png' ${output}/ffmpeg_default.webm
time ffmpeg ${ffmpeg_params} -i '*.png' -c:v libvpx-vp9 ${output}/ffmpeg_vp9_default.webm
time ffmpeg ${ffmpeg_params} -i '*.png' -c:v libvpx-vp9 -lossless 1 ${output}/ffmpeg_vp9_lossless.webm
time ffmpeg ${ffmpeg_params} -i '*.png' -c:v libvpx-vp9 -quality good -speed 0 ${output}/ffmpeg_vp9_quality_good_speed_0.webm
time ffmpeg ${ffmpeg_params} -i '*.png' -c:v libvpx-vp9 -quality good -speed 5 ${output}/ffmpeg_vp9_quality_good_speed_5.webm
time ffmpeg ${ffmpeg_params} -i '*.png' -c:v libvpx-vp9 -quality good -speed 0 -crf 0 ${output}/ffmpeg_vp9_quality_good_speed_0_cfr_0.webm
time ffmpeg ${ffmpeg_params} -i '*.png' -c:v libvpx-vp9 -quality good -speed 0 -crf 10 ${output}/ffmpeg_vp9_quality_good_speed_0_cfr_10.webm
time ffmpeg ${ffmpeg_params} -i '*.png' -c:v libvpx-vp9 -quality good -speed 0 -crf 63 ${output}/ffmpeg_vp9_quality_good_speed_0_cfr_63.webm

# Create webm vp9 with ffmpeg in various configurations (2-pass)
time (ffmpeg ${ffmpeg_params} -i '*.png' -pass 1 -f webm /dev/null && \
ffmpeg ${ffmpeg_params} -i '*.png' -pass 2 ${output}/ffmpeg_default_2_pass.webm)

time (ffmpeg ${ffmpeg_params} -i '*.png' -pass 1 -c:v libvpx-vp9 -f webm /dev/null && \
ffmpeg ${ffmpeg_params} -i '*.png' -pass 2 -c:v libvpx-vp9 ${output}/ffmpeg_vp9_default_2_pass.webm)

time (ffmpeg ${ffmpeg_params} -i '*.png' -pass 1 -c:v libvpx-vp9 -lossless 1 -f webm /dev/null && \
ffmpeg ${ffmpeg_params} -i '*.png' -pass 2 -c:v libvpx-vp9 -lossless 1 ${output}/ffmpeg_vp9_lossless_2_pass.webm)

time (ffmpeg ${ffmpeg_params} -i '*.png' -pass 1 -c:v libvpx-vp9 -quality good -speed 0 -f webm /dev/null && \
ffmpeg ${ffmpeg_params} -i '*.png' -pass 2 -c:v libvpx-vp9 -quality good -speed 0 ${output}/ffmpeg_vp9_quality_good_speed_0_2_pass.webm)

time (ffmpeg ${ffmpeg_params} -i '*.png' -pass 1 -c:v libvpx-vp9 -quality good -speed 5 -f webm /dev/null && \
ffmpeg ${ffmpeg_params} -i '*.png' -pass 2 -c:v libvpx-vp9 -quality good -speed 5 ${output}/ffmpeg_vp9_quality_good_speed_5_2_pass.webm)

time (ffmpeg ${ffmpeg_params} -i '*.png' -pass 1 -c:v libvpx-vp9 -quality good -speed 0 -crf 0 -f webm /dev/null && \
ffmpeg ${ffmpeg_params} -i '*.png' -pass 2 -c:v libvpx-vp9 -quality good -speed 0 -crf 0 ${output}/ffmpeg_vp9_quality_good_speed_0_cfr_0_2_pass.webm)

time (ffmpeg ${ffmpeg_params} -i '*.png' -pass 1 -c:v libvpx-vp9 -quality good -speed 0 -crf 10 -f webm /dev/null && \
ffmpeg ${ffmpeg_params} -i '*.png' -pass 2 -c:v libvpx-vp9 -quality good -speed 0 -crf 10 ${output}/ffmpeg_vp9_quality_good_speed_0_cfr_10_2_pass.webm)

time (ffmpeg ${ffmpeg_params} -i '*.png' -pass 1 -c:v libvpx-vp9 -quality good -speed 0 -crf 63 -f webm /dev/null && \
ffmpeg ${ffmpeg_params} -i '*.png' -pass 2 -c:v libvpx-vp9 -quality good -speed 0 -crf 63 ${output}/ffmpeg_vp9_quality_good_speed_0_cfr_63_2_pass.webm)

cd ${dir}

# List output results
ls -al ${output}
