def source_paths
  [__dir__]
end

gem "blacklight"

gem_group :development, :test do
  gem "standard"
  gem "rspec-rails"
end

rakefile("default.rake") do
  <<-TASK
    task(:default).clear.enhance %i[environment standard spec]
  TASK
end

copy_file "blacklight/README2.md", "README2.md"
copy_file "blacklight/.dockerignore", ".dockerignore"
copy_file "blacklight/docker-compose.yml", "docker-compose.yml"
copy_file "blacklight/Dockerfile", "Dockerfile"
copy_file "blacklight/solr/.dockerignore", "solr/.dockerignore"
copy_file "blacklight/solr/Dockerfile", "solr/Dockerfile"

after_bundle do
  run "bundle binstubs standard"
  run "bundle binstubs rspec-core"
  run "mkdir data; touch data/.keep"
  application do
<<-'RUBY'
    config.generators do |g|
      g.integration_tool :rspec
      g.test_framework :rspec
    end
RUBY
  end
  inject_into_file "config/database.yml", after: "default: &default\n" do
<<-'YAML'
  host: db
  username: postgres
  password: postgres
YAML
  end
  generate "rspec:install"
  generate :scaffold, "user name:string"
  generate "blacklight:install"
  run "rm config/blacklight.yml"
  copy_file "blacklight/config/blacklight.yml", "config/blacklight.yml"
  run "bin/rake standard:fix_unsafely"
  git add: "."
end
