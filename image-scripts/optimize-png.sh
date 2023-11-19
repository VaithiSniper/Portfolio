#!/bin/bash

# directory containing images
input_dir="/imgs/"

if [[ -z "$input_dir" ]]; then
  echo "Please specify an input directory."
  exit 1
fi

# for each png in the input directory
for img in $( find $input_dir -type f -iname "*.png" );
do
  echo "---------------- Optimizing $img ----------------"
  image=${img%%.*}
  mogrify -resize 48x48 $img
  optipng $img -out /optimized${image}.png
  echo "Verifying resize for /optimized${image}.png"
  identify /optimized${image}.png
done