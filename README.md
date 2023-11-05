# scottlimmer.github.io

## Init project (from WSL)
docker run --rm --volume=".:/srv/jekyll:Z" -it jekyll/jekyll jekyll new --skip-bundle --force .

## Run bundle
docker run --rm --volume=".:/srv/jekyll:Z" -it jekyll/jekyll bundle install