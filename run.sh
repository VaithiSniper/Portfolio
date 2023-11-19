# -------------------------------- To remove old artifacts (containers, build-folders) --------------------------------
gum spin --spinner dot --title "Removing exisitng artifacts 💥" -- docker rm -f vaithee-portfolio image-optimize & rm optimized/* -rf || true
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 30 --margin "1 2" --padding "2 4" \
	'Removed artifacts' '💥'
# -------------------------------- To remove old artifacts (containers, build-folders) --------------------------------


# -------------------------------- To build portfolio and push to Dockerhub --------------------------------
gum spin --spinner dot --title "Building portfolio ⚒️" -- docker build -t vaithisniper/vaithee-portfolio:latest -f Dockerfile_Site .
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 30 --margin "1 2" --padding "2 4" \
	'Portfolio built!' '⚒️'
# -------------------------------- -------------------------------- -------------------------------- --------------------------------
gum spin --spinner dot --title "Pushing to DockerHub 🐳" -- docker push vaithisniper/vaithee-portfolio:latest
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 30 --margin "1 2" --padding "2 4" \
	'Pushed to DockerHub' '🐳'
# -------------------------------- To build portfolio and push to Dockerhub --------------------------------


# -------------------------------- To optimize images and add to repo --------------------------------
gum spin --spinner dot --title "Optimizing images ⚡" -- docker build -t vaithisniper/image-optimize:latest -f Dockerfile_Images .
# -------------------------------- -------------------------------- -------------------------------- --------------------------------
echo "Container ID: $(docker run -d --name image-optimize vaithisniper/image-optimize:latest)"
echo "Copy Status:"
docker cp image-optimize:/usr/share/nginx/html/imgs ./optimized/
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 30 --margin "1 2" --padding "2 4" \
	'Optimized images' '⚡'
# -------------------------------- To optimize images and add to repo --------------------------------


# -------------------------------- Commit and push to remote --------------------------------
git add .
git commit -m "Updated images" | grep -i "changed" || true
git push origin master 1> /dev/null 
gum style \
	--foreground 212 --border-foreground 212 --border double \
	--align center --width 30 --margin "1 2" --padding "2 4" \
	'Pushed to Github' '🚀🚀🚀'
# -------------------------------- Commit and push to remote --------------------------------