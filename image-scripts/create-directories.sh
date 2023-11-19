#!/bin/bash

# Shell script to create directories for output images

for dir in $( find /imgs -type d );
do
  echo "Creating dir $dir"
  mkdir -p /optimized/${dir}
done

