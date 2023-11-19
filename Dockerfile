# Some ARGs for the Build and Deployment
ARG arch_build=amd64
ARG arch_server=arm64/v8


# ------------------------------- Minify the static assets, modify HTML files to use webp extension ------------------------------- 
FROM --platform=linux/${arch_build} tdewolff/minify:latest as minify
# Make directories for static assets
RUN mkdir /home/html/
RUN mkdir /home/css/
RUN mkdir /home/js/
# Copy JS assets
WORKDIR /home/js/
COPY script.js .
# Copy CSS assets
WORKDIR /home/css/
COPY styles.css .
# Copy HTML assets
WORKDIR /home/html/
COPY index.html .
COPY about.html .
COPY experience.html .
COPY skills.html .
COPY events.html .
# Minify the JS, CSS, and HTML files
WORKDIR /home/js/
RUN minify -o script.js script.js
WORKDIR /home/css/
RUN minify -o styles.css styles.css
WORKDIR /home/html/
RUN minify -o index.html index.html
RUN minify -o about.html about.html
RUN minify -o experience.html experience.html
RUN minify -o skills.html skills.html
RUN minify -o events.html events.html
# RUN sed -i 's/.png/.webp/g' *
# ------------------------------- Minify the static assets ------------------------------- 


# ------------------------------- Optimize images ------------------------------- 
FROM --platform=linux/${arch_build}  dpokidov/imagemagick:latest as image-optimize
RUN apt-get update
RUN apt-get install imagemagick webp optipng -y
# Copy the image scripts into the container
COPY ./image-scripts/ /home
# Give permissions to the scripts
# RUN chmod +x /home/convert-to-webp.sh
RUN chmod +x /home/create-directories.sh
RUN chmod +x /home/optimize-png.sh
# Copy the images into the container
WORKDIR /imgs
COPY ./images .
# Create the directories for the optimized images
RUN /home/create-directories.sh
# Convert the images to webp
# RUN /home/convert-to-webp.sh
RUN /home/optimize-png.sh
# ------------------------------- Optimize images ------------------------------- 


# ------------------------------- Setup webserver ------------------------------- 
FROM --platform=linux/${arch_server}  nginx:latest as final
# Copy static assets
COPY --from=image-optimize /optimized/imgs /usr/share/nginx/html/images
# Copy the CSS, and JS files into the container
WORKDIR /usr/share/nginx/html
COPY --from=minify /home/js/script.js .
COPY --from=minify /home/css/styles.css .
# Copy the HTML files into the container
COPY --from=minify /home/html/index.html .
COPY --from=minify /home/html/about.html .
COPY --from=minify /home/html/experience.html .
COPY --from=minify /home/html/skills.html .
COPY --from=minify /home/html/events.html .
# Expose port 80 for the web server (already exposed by default but for clarity)
EXPOSE 80
# Set the default command to start the web server
CMD ["nginx", "-g", "daemon off;"]
# ------------------------------- Setup webserver -------------------------------