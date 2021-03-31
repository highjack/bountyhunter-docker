export docker_name="bountyhunter"
docker build . -t "$docker_name"
docker run -h "$docker_name" -ti "$docker_name"
