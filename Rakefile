ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

desc "Updates Events table in database by scraping several websites"
task :scrape do
  EventsScraper.new.call
end
