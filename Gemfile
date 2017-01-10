source 'https://rubygems.org'

gem 'rails', '~> 5.0.1'
gem 'puma', '~> 3.0'
gem 'jbuilder', '~> 2.5'
gem 'pg', '~> 0.18'
gem 'delayed_job_active_record'
gem 'daemons'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'faker'
  gem "factory_girl_rails"
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem "database_cleaner"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
