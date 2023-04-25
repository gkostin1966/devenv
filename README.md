# Development Environment
Docker Compose Rails New Application Templates
## devenv
```shell
docker-compose build devenv
docker-compose up -d
docker-compose exec -- devenv rails new --template=templates/blacklight.rb myapp
```
## myapp
```shell
cd myapp
git commit -m "devenv rails new --template=templates/blacklight.rb"
```
`README2.md` Development Quick Start
