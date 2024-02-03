namespace :db do
  task :migrate do
    # This appends, it does not redefine.
    # Always run doc:annotate after db:migrate
    Rake::Task["doc:annotate"].invoke
  end
end
