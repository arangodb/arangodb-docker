volumes:
  /var/lib/arangodb    		database files
  /var/lib/arangodb-apps	application directory
  /var/log/arangodb		log directory

run an upgrade:
  docker run arangodb standalone --upgrade

pipe the log file to standard out:
  docker run arangodb standalone --verbose

fire up a bash after starting the server:
  docker run -it arangodb standalone --console

disable authentication
  docker run arangodb standalone --disable-authentication

disable initialisation on first boot
  docker run arangodb standalone --disable-initialize

show all options:
  docker run arangodb help
