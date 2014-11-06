# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, "#{path}/log/whenever.log"

job_type :runner, "cd :path && ruby script/rails runner -e :environment ':task' :output"

every 1.day, at: "3:00 AM" do
  command "sudo rm -R '#{path}/tmp/uploads/'"
  command "sudo rm -R '#{path}/public/blog/wp-content/uploads/'"
  rake "db:sessions:clear"
  rake "db:remove_admin_searches"
  runner "FeedEntry.update_from_feed('http://www.bemcasados.art.br/blog/feed/rss2/')"
end

every 1.day, at: "11:30 PM" do
  rake "db:select_review_of_the_day"
  rake "db:update_user_merits_type"
end

#every 1.month do
#  rake "db:remove_old_searches"
#end