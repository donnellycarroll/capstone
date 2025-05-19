# desc "Fill the database tables with some sample data"
# task({ sample_data: :environment }) do
# end

# Option A: make `rake sample_data` depend on the namespaced loader
desc "Fill the database tables with some sample data"
task :sample_data => "sample_data:load"
