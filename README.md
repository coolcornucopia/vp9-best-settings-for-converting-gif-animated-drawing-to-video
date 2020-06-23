# VP9 best settings for converting gif animated drawing to video

The goal of this page is to list results I captured while looking for the VP9 video encoder best settings for converting a gif animated drawing to a video. As gif is a *lossless* image format, the goal here is not to get the smallest video file, but more the best compromise between the quality (prio 1), the file size (prio 2) and the encoding time (prio 3).

> **Note** The input images have been captured thanks to the **Python Turtle Country Flags :snake: :turtle:** from [here](https://github.com/coolcornucopia/python-turtle-country-flags).


## Quick outcomes without wasting time reading more :smile:

0. :medal_sports: **Forget gif format, use instead webm vp9 video format**.
1. :1st_place_medal: Best command that is **perfect in most cases :heavy_check_mark:**:
``` bash
ffmpeg -framerate my_fps_value -pattern_type glob -i '*.png' -c:v libvpx-vp9 output.webm
```
2. :2nd_place_medal: Best command for **the best quality :rainbow:** (file size close to 2. but slower encoding in 2-pass):
``` bash
# ffmpeg vp9 encode lossless speed 0 2-pass
ffmpeg -framerate my_fps_value -y -i '*.png' -pass 1 -c:v libvpx-vp9 -lossless 1 -speed 0 -f webm /dev/null
ffmpeg -framerate my_fps_value    -i '*.png' -pass 2 -c:v libvpx-vp9 -lossless 1 -speed 0 output.webm
```
3. :3rd_place_medal: Best command for **the smallest file size :muscle:** (quality is less good than 2. and 3. but acceptable) :
``` bash
# ffmpeg vp9 encode quality good speed 0 crf 10
ffmpeg -framerate my_fps_value -pattern_type glob -i '*.png' -c:v libvpx-vp9 -quality good -speed 0 -crf 10 output.webm
```


> **Note** HTML code for using a video as a gif animation image:
``` html
<video autoplay loop muted playsinline title="your alternate text">
  <source src="your_file.webm" type="video/webm">
</video>
```


> **Note** ffmpeg input file syntax: Hereafter examples that may help you using the ffmpeg syntax ([ffmpeg related documentation](https://ffmpeg.org/ffmpeg-formats.html#image2-1)):
``` bash
export fps=20
ffmpeg -framerate $fps -i your_files_%04d.png output.webm  # The printf way
ffmpeg -framerate $fps -pattern_type glob -i '*.png' output.webm  # The wildcad way
```
> **Note** I added this above note because it took me times to understand the ffmpeg syntax and there are still *odd* things that still does not work on my side like. For instance, you can not do `export myfile="'*.png'"` and use `$myfile` instead of `*.png` because you will have an `No such file or directory` error message :-(


## Visual results

|     |     |
| :-: | :-: |
| ![gifsicle_o3_colors_256.gif (730,476 bytes)](output/gifsicle_o3_colors_256.gif?raw=true "gifsicle_o3_colors_256.gif (730,476 bytes)")<br>**Big gif file**<br>gifsicle_o3_colors_256.gif (730,476 bytes) | <video autoplay loop muted playsinline title="ffmpeg_vp9_default.webm (294,570 bytes)"><source src="output/ffmpeg_vp9_default.webm" type="video/webm"></video><br>**perfect in most cases :heavy_check_mark:**<br>ffmpeg_vp9_default.webm (294,570 bytes) |
| <video autoplay loop muted playsinline title="ffmpeg_vp9_lossless_speed_0_2_pass.webm (297,484 bytes)"><source src="output/ffmpeg_vp9_lossless_speed_0_2_pass.webm" type="video/webm"></video><br>**the best quality :rainbow:**<br>ffmpeg_vp9_lossless_speed_0_2_pass.webm (297,484 bytes) | <video autoplay loop muted playsinline title="ffmpeg_vp9_quality_good_speed_0_cfr_10.webm (180,735 bytes)"><source src="output/ffmpeg_vp9_quality_good_speed_0_cfr_10.webm" type="video/webm"></video><br>**the smallest file size :muscle:**<br>ffmpeg_vp9_quality_good_speed_0_cfr_10.webm (180,735 bytes) |


## Detailed results

| **Type** | **Size**  | **%** | **Quality** | **Filename**                                                | **sec** | **%** |
| :------: | --------: | ----: | :---------: | ----------------------------------------------------------- | ------: | ----: |
| gif      | 2,288,891 | 213%  | Perfect     | imagemagick\_default.gif                                    | 103,5   | 442%  |
| gif      | 816,729   | 12%   | Perfect     | imagemagick\_layers\_optimize.gif                           | 42,9    | 125%  |
| gif      | 931,165   | 27%   | Perfect     | ezgif_lossy_200pc.gif [ezgif online optimizer (lossy 200%)](https://ezgif.com/) | na      | na    |
| gif      | 1,923,835 | 163%  | Perfect     | gifsicle\_o1.gif                                            | 1,1     | \-94% |
| gif      | 1,099,891 | 51%   | Perfect     | gifsicle\_o2.gif                                            | 1,3     | \-93% |
| gif      | 1,058,821 | 45%   | Perfect     | gifsicle\_o3.gif                                            | 1,6     | \-92% |
| gif      | 730,476   | **100%**  | Perfect | gifsicle\_o3\_colors\_256.gif                               | 1,8     | \-90% |
| gif      | 1,865,002 | 155%  | Bad         | ffmpeg\_default.gif                                         | 2,3     | \-88% |
| vp9      | 294,570   | \-60% | Good        | ffmpeg\_default.webm                                        | 19,1    | **100%**  |
| vp9      | 290,069   | \-60% | Good        | ffmpeg\_default\_2\_pass.webm                               | 43,1    | 126%  |
| **vp9** | **294,570** | **\-60%:heavy_check_mark:** | **Good:heavy_check_mark:** | **ffmpeg\_vp9\_default.webm** | **19,1** | **0%** |
| vp9      | 290,069   | \-60% | Good        | ffmpeg\_vp9\_default\_2\_pass.webm                          | 43,1    | 126%  |
| vp9      | 440,770   | \-40% | Perfect     | ffmpeg\_vp9\_lossless.webm                                  | 31,7    | 66%   |
| vp9      | 315,926   | \-57% | Perfect     | ffmpeg\_vp9\_lossless\_2\_pass.webm                         | 41,9    | 119%  |
| vp9      | 342,858   | \-53% | Perfect     | ffmpeg\_vp9\_lossless\_speed\_0.webm                        | 42,2    | 121%  |
| **vp9**  | **297,484** | **\-59%** | **Perfect:rainbow:** | **ffmpeg\_vp9\_lossless\_speed\_0\_2\_pass.webm** | **55,5** | **191%** |
| vp9      | 289,051   | \-60% | Good        | ffmpeg\_vp9\_quality\_good\_speed\_0.webm                   | 27,7    | 45%   |
| vp9      | 286,179   | \-61% | Good        | ffmpeg\_vp9\_quality\_good\_speed\_0\_2\_pass.webm          | 60,2    | 215%  |
| vp9      | 393,069   | \-46% | Medium      | ffmpeg\_vp9\_quality\_good\_speed\_5.webm                   | 14,2    | \-26% |
| vp9      | 343,217   | \-53% | Medium      | ffmpeg\_vp9\_quality\_good\_speed\_5\_2\_pass.webm          | 32,2    | 68%   |
| vp9      | 289,051   | \-60% | Good        | ffmpeg\_vp9\_quality\_good\_speed\_0\_cfr\_0.webm           | 27,8    | 45%   |
| vp9      | 234,628   | \-68% | Good        | ffmpeg\_vp9\_quality\_good\_speed\_0\_cfr\_0\_2\_pass.webm  | 38,5    | 101%  |
| **vp9** | **180,735** | **\-75%:muscle:** | **Medium** | **ffmpeg\_vp9\_quality\_good\_speed\_0\_cfr\_10.webm** | **24,3** | **27%** |
| vp9      | 211,367   | \-71% | Medium      | ffmpeg\_vp9\_quality\_good\_speed\_0\_cfr\_10\_2\_pass.webm | 37,5    | 96%   |
| vp9      | 91,638    | \-87% | Low         | ffmpeg\_vp9\_quality\_good\_speed\_0\_cfr\_63.webm          | 23,2    | 21%   |
| vp9      | 85,450    | \-88% | Low         | ffmpeg\_vp9\_quality\_good\_speed\_0\_cfr\_63\_2\_pass.webm | 32,5    | 70%   |

> **Note** All results are in [results.ods](https://github.com/coolcornucopia/vp9-best-settings-for-converting-gif-animated-drawing-to-video/blob/master/results.ods) file.


**Few comments**
* vp9 `-quality best` is not recommended in the vp9 documentation, `-quality realtime` is for steaming, here only `-quality good` is usefull then.
* ffmpeg by default uses vp9 on my linux configuration. If you have a doubt, please add `-c:v libvpx-vp9`.
* we may play more with `-speed x` too but not really necessary here as the animation is very simple and short. Moreover, gif images are lossless so better to use `-speed 0` to get the best quality.
* gifsicle works only on gif file as input.
* [ezgif.com online gif optimizer](https://ezgif.com/) has been evaluated too but results are lower than `gifsicle -O3`.

**Warnings**
* :warning: ffmpeg gif output is not correct! Maybe I should try the latest ffmpeg version...
* :warning: Measured times depend on my hw configuration, your results will differ probably.
* :warning: If it works in my case, it does not necessarily mean that it will work in all your cases, even if I sincerely think that my advices remain valid in many cases, anyway, hope it helps :smile:.


## Related documentations

Video
* **ffmpeg**: [VP9](https://trac.ffmpeg.org/wiki/Encode/VP9)
* **VP9** on Google developers: [basics](https://developers.google.com/media/vp9/the-basics), [bitrate-modes](https://developers.google.com/media/vp9/bitrate-modes) & [vod settings](https://developers.google.com/media/vp9/settings/vod/)

Gif
* **ImageMagick** and its `convert` tool: https://imagemagick.org/script/convert.php
* **ezgif** online gif converter: https://ezgif.com/, based on gifsicle & lossygif tools.
* **gifsicle** gif optimizer tool: https://www.lcdf.org/gifsicle/ and the related [gifsicle man page](https://www.lcdf.org/gifsicle/man.html)
* **lossygif**: https://kornel.ski/lossygif


## How to use the scripts
The [encode_test.sh script](https://github.com/coolcornucopia/vp9-best-settings-for-converting-gif-animated-drawing-to-video/blob/master/encode_test.sh) contains all the different commands, that may help you if you are looking for details.

``` bash
./encode_test.sh -h
./encode_test.sh 2>&1 | tee `date +"%F_%Hh%Mm%Ss"`.log
```


## How to update input files

Simply update the content of the `input` directory with your png files.
> Note You can also use `-i dirname` parameter to use to preferred directory.

You can update the `input.7z` file with the `input` directory content thanks to following commands:
``` bash
rm input.7z
7z a input.7z input
```

## Wrap up
We may have better results using different vp9 encoder parameters...


## Comments:exclamation: Questions:question:
If you have comments or questions, send me a email at coolcornucopia@outlook.com :email:.

--

Peace :smile:

coolcornucopia
