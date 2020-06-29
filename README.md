<p align="center">
  <img src="source/images/logo_dark.svg" width="200" />
</p>

# MetaShip Documentation

Fork from [slatedocs/slate](https://github.com/slatedocs/slate)

# Run

1. Build the docker image for slate: `docker build . -t slate`
1. To start a container for slate, run: `docker run -d --rm --name slate -p 4567:4567 -v $(pwd)/build:/srv/slate/build -v $(pwd)/source:/srv/slate/source slate` and you will be able to access your site at http://localhost:4567.
1. To build your sources while the container is running, run: `docker exec -it slate /bin/bash -c "bundle exec middleman build"`
1. To stop the slate container, run: `docker stop slate`