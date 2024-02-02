namespace :doc do
  desc "generate yardoc docs in doc/app/index.html"
  task :app do
    `yard doc -o doc/app`
    puts "see doc/app/index.html"
  end

  desc "annotate models"
  task :annotate do
    run = ->(cmd) {
      print "Running `#{cmd}` "
      `#{cmd} 2>&1`
      puts $?.success? ? Rainbow("[OK]").green : Rainbow("[FAILED]").red
    }
    if Rails.env.development?
      run.call("annotate --models --position bottom")
      # run.call("annotate --routes --position bottom")
    end
  end
end
