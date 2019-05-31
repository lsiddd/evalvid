#!/bin/bash

here=$(pwd)
video=$4

if [ "$video" == "container" ]
then
    video_st="st_container_cif_h264_300_20.st"
    video_yuv="container_cif_h264_300_20"

elif [ $video == "highway" ]
then
    video_st="st_highway_cif.st"
    video_yuv="highway_cif"

elif [ $video == "highway600" ]
then
    video_st="st_highway_600_cif"
    video_yuv="highway_600_cif"

elif [ $video == "akiyo" ]
then
    video_st="st_akiyo_cif_h264_300_18"
    video_yuv="akiyo_cif_h264_300_20"

elif [ $video == "masha" ]
then
    video_st="st_masha360p"
    video_yuv="masha360p_ref.mp4"

elif [ $video == "despacito" ]
then
    video_st="st_despacito"
    video_yuv="despacito_ref.mp4"

elif [ $video == "babyshark" ]
then
    video_st="st_baby_shark"
    video_yuv="baby_shark_ref.mp4"

else
    exit 1
fi

for i in $1; do
	for k in $(seq 1 $2); do
		cp $here/$i/simul$k/rd* $here/$i/simul$k/sd* "$here"
		for y in $(seq 0 $3); do
			 $here/etmp4 -F -0 sd_a01_$y rd_a01_$y "$here/traces/$video_st" "$here/reference_videos/$video_yuv.mp4" Video$y
			 ffmpeg -i Video$y.mp4 Video$y.yuv
			 wine $here/msu_metric.exe -f $video_yuv.yuv IYUV -yw 352 -yh 288 -f Video$y.yuv -sc 1 -cod . -metr ssim_precise -cc YYUV
			 wine $here/msu_metric.exe -f $video_yuv.yuv IYUV -yw 352 -yh 288 -f Video$y.yuv -sc 1 -cod . -metr vqm -cc YYUV
			 mv *csv $i/simul$k/
		done
		rm  rd* sd* Video* loss* rate* delay*

	done
done
