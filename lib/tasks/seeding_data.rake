namespace :seeding_data do
  task :category_trainers => :environment do
    categories = ["penceramah", "fasilitator"]
    categories.each do |category|
      a = CategoryTrainer.new(:name => category)
      if a.save
        puts "#{category} created"
      end
    end
  end
end