def source_paths
  [__dir__]
end

gem_group :development, :test do
  gem "standard"
  gem "rspec-rails"
end

rakefile("default.rake") do
  <<-TASK
    task(:default).clear.enhance %i[environment standard spec]
  TASK
end

copy_file "rails/docker-compose.yml", "docker-compose.yml"
copy_file "rails/Dockerfile", "Dockerfile"

after_bundle do
  run "mkdir data"
  rails_command "db:migrate"
  generate "rspec:install"
  run "bin/rake standard:fix_unsafely"
  run "bin/rake spec"
  run "bundle binstubs standard"
  run "bundle binstubs rspec-core"
  run "ls bin"
  git add: "."
end
