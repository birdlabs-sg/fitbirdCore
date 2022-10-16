# expressBackend

## Note:

[To inspect/manipulate database]
`npx prisma studio`

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

## Setting up editor:

Set autoformatter:

- press `Control + Shift + P` or `Command + Shift + P (Mac)`
- setting > Preferences: Open User Settings
  (This will apply autoformatter on all files. If only want for that project use workspace)

Note:

- .vscode folder contains configurations to IGNORE dist folders so that it won't appear in the explorer.

Plugins:

- Prettier
- Prisma

## Connecting to production database

You will have to use the cloud sql auth proxy (https://cloud.google.com/sql/docs/mysql/connect-admin-proxy)
`./cloud_sql_proxy -instances=fitbird-353419:asia-southeast1:fitbird-production-db-sg=tcp:3306 &`

To remove node module quick:

# MACOS

cd <directoryToDeleteFrom>
`find . -name 'node_modules' -type d -prune -print -exec rm -rf '{}' \;`

# WINDOWS

cd <directoryToDeleteFrom>
`FOR /d /r . %d in (node_modules) DO @IF EXIST "%d" rm -rf "%d"`

# POWERSHELL

`Get-ChildItem -Path "." -Include "node_modules" -Recurse -Directory | Remove-Item -Recurse -Force`
