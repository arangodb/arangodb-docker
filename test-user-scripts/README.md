ArangoDB Docker Selftest container
==================================
This container is intended to demonstrate & test the derivate mechanism of the ArangoDB Docker Container.

It will utilize the 3 different ways of running users scripts in the `/docker-entrypoint-initdb.d` directory:

 - a javascript file
 - a shellscript
 - restoring data into arangodb
 
 It copies verify.js into the container, which can revalidate whether all of the 3 actions above were executed successfully.
