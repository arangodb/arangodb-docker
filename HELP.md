volumes:
  /data    	database files
  /apps    	application directory
  /apps-dev	application directory for development
  /logs    	log directory

pipe the log file to standard out:
  docker run arangodb standalone --verbose

disable authentication
  docker run arangodb standalone --disable-authentication

fire up a bash after starting the server:
  docker run -it arangodb standalone --console

show all options:
  docker run arangodb help
