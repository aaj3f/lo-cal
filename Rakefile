ENV["SINATRA_ENV"] ||= "development"

require_relative './config/environment'
require 'sinatra/activerecord/rake'

desc "Updates Events table in database by scraping several websites"
task :scrape do
  EventsScraper.new.call
end

desc "Finds Events with dates before today and removes from database"
task :clear_old_events do
  puts "There were #{Event.all.size} events."
  Event.all.select {|event| Date.parse(event.date_and_time.strftime("%y-%m-%d")) < Date.today}.each {|event| event.destroy}
  puts "But only #{Event.all.size} of them were current. Old events destroyed."
end
