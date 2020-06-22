# VP9 best settings for converting gif animated drawing to video

The goal of this page is to list results I captured when finding the VP9 best settings for converting a gif animated drawing to a video.

> Note The input images have been captured thanks to the **Python Turtle Country Flags :snake: :turtle:** from [here](https://github.com/coolcornucopia/python-turtle-country-flags).


## If you want my advice directly without wasting time reading more
1. Forget the gif format, use instead the webm vp9 video format.
2. The best command that is perfect in most cases:
``` bash
ffmpeg -framerate my_fps_value -pattern_type glob -i '*.png' -c:v libvpx-vp9 output.webm`
```
3. The best command for the best quality (file size bigger than 2. but still really smaller than gif):
``` bash
# ffmpeg vp9 encode lossless 2-pass
ffmpeg -framerate my_fps_value -y -i '*.png' -pass 1 -c:v libvpx-vp9 -lossless 1 -f webm /dev/null
ffmpeg -framerate my_fps_value    -i '*.png' -pass 2 -c:v libvpx-vp9 -lossless 1 output.webm
```
4. The best command for the smallest file size (quality is less good than 2. and 3. but acceptable) :
``` bash
# ffmpeg vp9 encode crf 10
ffmpeg -framerate my_fps_value -pattern_type glob -i '*.png' -c:v libvpx-vp9 -quality good -speed 0 -crf 10 output.webm`
```

> **Note about related html code** (the goal is to be as close as possible to a gif animation)
``` html
<video autoplay loop muted playsinline>
  <source src="your_file.webm" type="video/webm">
</video>
```


> **Note about input files ffmpeg syntax**: Hereafter examples that may help you using the ffmpeg syntax ([ffmpeg related documentation](https://ffmpeg.org/ffmpeg-formats.html#image2-1)):
``` bash
export fps=20

ffmpeg -framerate $fps -i your_files_%04d.png output.webm  # The printf way
ffmpeg -framerate $fps -pattern_type glob -i '*.png' output.webm  # The wildcad way
```
> I added this above note because it took me times to understand the ffmpeg syntax and there are still *odd* things that still does not work on my side like. For instance, you can not do `export myfile="'*.png'"` and use `$myfile` instead of `*.png` because you will have an `No such file or directory` error message :-(


## Actual detailed results
```
2288891 Gif ImageMagik default parameters 1m47,816s
 816729 Gif ImageMagik -layers Optimize 0m53,377s
 931165 Using https://ezgif.com/ with "Lossy GIF" & compression level @ max (200%), 
    (ezgif uses gifsicle)
  294570 ffmpeg default parameters (ie vp9 default) 0m23,546s
  294570 ffmpeg vp9 default parameters 0m23,546s
   ffmpeg vp9 quality good speed 0 
   ffmpeg vp9 lossless
   ffmpeg vp9 quality good speed 0 2-pass
   ffmpeg vp9 lossless 2-pass
```

Few comments:
* /!\ measure times with the same setup (charging laptop...)
* /!\ If it works in my case, it does not necessarily mean that it will work in all your cases, even if I sincerely think that my advice remains valid in many cases.


## Related documentations

Video
* **ffmpeg**: [VP9](https://trac.ffmpeg.org/wiki/Encode/VP9)
* **VP9** on Google developers: [basics](https://developers.google.com/media/vp9/the-basics), [bitrate-modes](https://developers.google.com/media/vp9/bitrate-modes) & [vod settings](https://developers.google.com/media/vp9/settings/vod/)

Gif
* **ImageMagick** and its convert tool: https://imagemagick.org/script/convert.php
* **ezgif** online gif converter: https://ezgif.com/, based on gifsicle & lossygif tools.
* **gifsicle** gif optimizer tool: https://www.lcdf.org/gifsicle/ and the related [gifsicle man page](https://www.lcdf.org/gifsicle/man.html)
* **lossygif**: https://kornel.ski/lossygif


## How to use the scripts

``` bash
./encode_test.sh -h

./encode_test.sh 2>&1 | tee `date +"%F_%Hh%Mm%Ss"`.log
```


## How to update input files

Simply update the content the `input` directory with your png files.
> Note You can also use `-i dirname` parameter to use to prefered directory.

You can update the `input.7z` file with the `input` directory content thanks to following commands:
```
rm input.7z
7z a input.7z input
```

## Wrapup
We may have better results using different vp9 encoder parameters.

## TODO
Improve this text, add emoticons, green and red color texts...

## Comments, questions?
If you have comments or questions, send me a email at coolcornucopia@outlook.com.

--

Peace :smile:

coolcornucopia
