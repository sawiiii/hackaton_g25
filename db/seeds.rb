# db/seeds.rb

# Clear existing data
Application.destroy_all
Position.destroy_all
ProjectMembership.destroy_all
Project.destroy_all
Person.destroy_all

# Create sample users
people = [
  { name: "John Doe", auth0_id: "yMQEbIbdtBTkPYxONcxbaTmSSuEfMKIF@clients" },
  { name: "Jane Smith", auth0_id: "auth0_654321" },
  { name: "Alice Johnson", auth0_id: "auth0_987654" },
  { name: "Bob Brown", auth0_id: "auth0_456789" }
]

# Tripling users
3.times do |i|
  people << { name: "Test User #{i + 1}", auth0_id: "auth0_test_#{i + 1}" }
end

people_records = people.map { |person| Person.create!(person) }

# Create sample projects for each user
projects = {}
3.times do
  people_records.each_with_index do |owner, i|
    projects["Project #{('A'..'Z').to_a.sample}-#{i + 1}"] = owner
  end
end

project_records = projects.map do |name, owner|
  Project.create!(name: name, description: "Description for #{name}", owner: owner)
end

# Create sample positions for each project
positions = []
project_records.each_with_index do |project, i|
  6.times do |j| # Tripling positions
    positions << Position.create!(
      name: "Position #{j + 1} for #{project.name}",
      project: project,
      vacancies: rand(2..5) # Random vacancies for variety
    )
  end
end

# Create applications, ensuring project owners don't apply to their own projects
positions.each do |position|
  eligible_applicants = people_records.reject { |person| person == position.project.owner }

  # Create pending applications for each position
  rand(2..4).times do
    applicant = eligible_applicants.sample
    Application.create!(
      motivation: "I am motivated to apply for #{position.name}",
      position: position,
      person: applicant,
      status: "pending" # Explicitly setting to pending
    )
  end
end

# Accept/reject only a subset of applications, leaving others as pending
positions.each do |position|
  position.applications.where(status: "pending").each do |application|
    if rand < 0.5 && position.applications.where(status: "accepted").count < position.vacancies
      application.update!(status: "accepted")
      position.project.members << application.person
    elsif rand < 0.3
      application.update!(status: "rejected")
    end
  end
end

# Ensure every person is a member of at least one project
people_records.each do |person|
  unless person.member_projects.any?
    project_to_join = project_records.reject { |proj| proj.owner == person }.sample
    position = project_to_join.positions.sample
    Application.create!(
      motivation: "I am eager to contribute to #{project_to_join.name}",
      position: position,
      person: person,
      status: "pending" # Pending membership applications
    )
  end
end

# Ensure every person owns at least one project
people_records.each do |person|
  unless project_records.any? { |proj| proj.owner == person }
    project = project_records.sample
    project.update!(owner: person)
  end
end

puts "Seeds created successfully"