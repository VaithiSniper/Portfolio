#!/bin/bash

# Shell script to convert png images to webp

# directory containing images
input_dir="/imgs/"

# webp image quality
quality="90"

if [[ -z "$input_dir" ]]; then
  echo "Please specify an input directory."
  exit 1
elif [[ -z "$quality" ]]; then
  echo "Please specify image quality."
  exit 1
fi

# for each png in the input directory
for img in $( find $input_dir -type f -iname "*.png" );
do
  echo "Converting $img"
  image=${img%%.*}
  cwebp $img -q $quality -o /optimized${image}.webp
done