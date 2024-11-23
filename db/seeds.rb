# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# db/seeds.rb

# Clear existing data
Person.destroy_all
Project.destroy_all

# Create sample users
person1 = Person.create!(name: "John Doe", auth0_id: "auth0_123456")
person2 = Person.create!(name: "Jane Smith", auth0_id: "auth0_654321")

# Create sample projects
Project.create!(name: "Project Alpha", description: "Description for Project Alpha", owner: person1)
Project.create!(name: "Project Beta", description: "Description for Project Beta", owner: person1)
Project.create!(name: "Project Gamma", description: "Description for Project Gamma", owner: person2)
Project.create!(name: "Project Delta", description: "Description for Project Delta", owner: person2)

puts "Seeds created successfully"