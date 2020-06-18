# VP9 best settings for converting gif animated drawing to video

The input images have been captured thanks to the **Python Turtle Country Flags :snake: :turtle:** from [here](https://github.com/coolcornucopia/python-turtle-country-flags).
## Actual results

## Related documentations

* ffmpeg: [VP9](https://trac.ffmpeg.org/wiki/Encode/VP9)
* Google developers vp9: [basics](https://developers.google.com/media/vp9/the-basics) & [bitrate-modes](https://developers.google.com/media/vp9/bitrate-modes)

## How to use the scripts
```
./encode_test.sh -h

./encode_test.sh > `date +"%F_%Hh%Mm%Ss"`.log 2>&1
```


## How to update input files
Simply update the content the `input` directory with your png files.
> Note You can also use `-i dirname` parameter to use to prefered directory.

You can update the `input.7z` file with the `input` directory content thanks to following commands:
```
rm input.7z
7z a input.7z input
```
