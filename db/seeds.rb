# db/seeds.rb

# Clear existing data
Application.destroy_all
Position.destroy_all
Project.destroy_all
Person.destroy_all

# Create sample users
person1 = Person.create!(name: "John Doe", auth0_id: "auth0_123456")
person2 = Person.create!(name: "Jane Smith", auth0_id: "auth0_654321")

# Create sample projects
project1 = Project.create!(name: "Project Alpha", description: "Description for Project Alpha", owner: person1)
project2 = Project.create!(name: "Project Beta", description: "Description for Project Beta", owner: person1)
project3 = Project.create!(name: "Project Gamma", description: "Description for Project Gamma", owner: person2)
project4 = Project.create!(name: "Project Delta", description: "Description for Project Delta", owner: person2)

# Create sample positions
position1 = Position.create!(name: "Developer", project: project1, vacancies: 2)
position2 = Position.create!(name: "Designer", project: project1, vacancies: 2)
position3 = Position.create!(name: "Manager", project: project2, vacancies: 2)
position4 = Position.create!(name: "Tester", project: project3, vacancies: 2)
position5 = Position.create!(name: "Analyst", project: project4, vacancies: 2)
position6 = Position.create!(name: "Architect", project: project1, vacancies: 2)
position7 = Position.create!(name: "Product Owner", project: project2, vacancies: 2)
position8 = Position.create!(name: "Scrum Master", project: project3, vacancies: 2)
position9 = Position.create!(name: "DevOps Engineer", project: project4, vacancies: 2)
position10 = Position.create!(name: "QA Engineer", project: project1, vacancies: 2)

# Create sample applications
Application.create!(motivation: "I am very motivated to join this project.", position: position1, person: person1, status: :pending)
Application.create!(motivation: "I am very motivated to join this project.", position: position1, person: person2, status: :pending)
Application.create!(motivation: "I have the skills required for this position.", position: position2, person: person2, status: :pending)
Application.create!(motivation: "I am excited about this opportunity.", position: position3, person: person1, status: :pending)
Application.create!(motivation: "I believe I can contribute significantly.", position: position4, person: person2, status: :pending)
Application.create!(motivation: "I am passionate about this field.", position: position5, person: person1, status: :pending)
Application.create!(motivation: "I am eager to work as an Architect.", position: position6, person: person2, status: :pending)
Application.create!(motivation: "I have experience as a Product Owner.", position: position7, person: person1, status: :pending)
Application.create!(motivation: "I am skilled in Scrum methodologies.", position: position8, person: person2, status: :pending)
Application.create!(motivation: "I have a strong background in DevOps.", position: position9, person: person1, status: :pending)
Application.create!(motivation: "I am proficient in QA processes.", position: position10, person: person2, status: :pending)

puts "Seeds created successfully"
