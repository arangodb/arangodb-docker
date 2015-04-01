volumes:
  /data    	database files
  /apps    	application directory
  /apps-dev	application directory for development
  /logs    	log directory

start in development mode:
  docker run -e development=1 arangodb

pipe the log file to standard out:
  docker run -e verbose=1 arangodb

fire up a bash after starting the server:
  docker run -e console=1 -it arangodb

show all options:
  docker run -e help=1 arangodb
