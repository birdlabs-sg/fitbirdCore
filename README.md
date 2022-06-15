# expressBackend

## Note:
[Until docker-compose is implemented]
To start dev environment,
`npm run dev`

To start prod environtment (NOT WORKING YET, BECAUSE ENV FILE IS NOT IN THE IMAGE BUILT, require docker-compose),
enter the following command in the root directory
`docker build . -t <tagname>`
Once built,
`docker run <container tagname>`

For production CI/CD has been setted up to look for changes in "master" branch


## Note:
- All secrets must to be kept on GCP secrets manager without the quotation marks. (Plain text)
- private key must remove the last EOL


## Helpers for docker dev:

# Unix

To delete all containers including its volumes use,
`docker rm -vf $(docker ps -aq)`

To delete all the images,
`docker rmi -f $(docker images -aq)`

Remember, you should remove all the containers before removing all the images from which those containers were created.

# Windows - Powershell

`docker images -a -q | % { docker image rm $_ -f }`

# Windows - Command Line

`for /F %i in ('docker images -a -q') do docker rmi -f %i`