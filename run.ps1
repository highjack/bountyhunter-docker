$NAME="bountyhunter"
docker build . -t $NAME
docker run -h $NAME -ti $NAME
