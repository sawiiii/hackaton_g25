# db/seeds.rb

# Clear existing data
Application.destroy_all
Position.destroy_all
ProjectMembership.destroy_all
ProjectCategory.destroy_all
Project.destroy_all
Person.destroy_all
Category.destroy_all

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

category_records = Category::CATEGORIES.map { |category_name| Category.create!(name: category_name) }

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

# Create sample projects
projects = [
  { name: "E-Learning VR Platform", description: "Una plataforma para simular laboratorios educativos utilizando realidad virtual."  },
  { name: "AI Telemedicine App", description: "Aplicación móvil que utiliza AI para diagnóstico inicial y conexión con médicos en tiempo real."},
  { name: "Renewable Energy Manager", description: "Un sistema para monitorear y optimizar el uso de recursos renovables en empresas y hogares." },
  { name: "Industrial Drone Management", description: "Una herramienta para la planificación y control de drones en tareas industriales." },
  { name: "Gamer Streaming Platform", description: "Una aplicación que combina streaming, interacciones en vivo y gestión de torneos para gamers." },
  { name: "Smart Cities Automation", description: "Un sistema IoT para automatizar servicios públicos como iluminación, tráfico y recolección de basura."},
  { name: "Personal Finance Blockchain App", description: "Una billetera digital con seguimiento de gastos y transferencias seguras en blockchain." },
  { name: "Collaborative Media Production", description: "Una aplicación para edición colaborativa de video y audio en la nube." },
  { name: "Sustainable Fashion Marketplace", description: "Un marketplace dedicado a marcas de moda sostenible con análisis de impacto ambiental." },
  { name: "AI Citizen Security", description: "Un software que utiliza cámaras de seguridad e IA para detectar comportamientos sospechosos."},
  { name: "Personalized Tourism App", description: "Una app que crea itinerarios turísticos personalizados basados en datos en tiempo real." },
  { name: "Startup Project Management", description: "Un sistema que combina gestión de tareas, finanzas y objetivos para startups." },
  { name: "AI Architecture Design", description: "Un programa que ayuda a arquitectos a diseñar estructuras optimizadas con algoritmos."},
  { name: "Supply Chain Management System", description: "Una solución para optimizar cadenas de suministro y transporte." },
  { name: "EdTech Gamified Learning", description: "Una aplicación educativa que utiliza mecánicas de juegos para mejorar el aprendizaje." }
]

project_records = projects.map do |project|
  new_project = Project.create!(name: project[:name], description: project[:description], owner: people_records.sample)

  tags = GenerateLabelsService.new(new_project.description).call

  puts "--> tag: #{tags}"

  tags&.each do |category_name|
    ProjectCategory.create!(project: new_project, category: Category.find_by(name: category_name))
  end
  new_project
end

# Create sample positions for each project
positions = []
project_records.each do |project|
  4.times do |j|
    positions << Position.create!(
      name: "Position #{j + 1} for #{project.name}",
      project: project,
      vacancies: rand(3..5)
    )
  end
end

# Create applications for positions
positions.each do |position|
  max_applications = (position.vacancies / 3.0).ceil
  eligible_applicants = people_records.reject { |person| person == position.project.owner }

  eligible_applicants.sample(max_applications).each do |applicant|
    Application.create!(
      motivation: "I want to work on #{position.name}",
      position: position,
      person: applicant,
      status: rand < 0.5 ? "accepted" : "pending"
    )
  end
end

puts "Seeds created successfully"


people_records = people.map { |person| Person.create!(person) }
#
# # Create categories
# category_records = Category::CATEGORIES.map do |category_name|
#   Category.create!(name: category_name)
# end
#
# # Create sample projects for each user
# projects = {}
# 3.times do
#   people_records.each_with_index do |owner, i|
#     projects["Project #{('A'..'Z').to_a.sample}-#{i + 1}"] = owner
#   end
# end
#
# project_records = projects.map do |name, owner|
#   project = Project.create!(
#     name: name,
#     description: "Description for #{name}",
#     owner: owner
#   )
#   # Assign 2 to 4 random categories to each project
#   categories_for_project = category_records.sample(rand(1..2))
#   categories_for_project.each do |category|
#     ProjectCategory.create!(project: project, category: category)
#   end
#   project
# end
#
# # Create sample positions for each project
# positions = []
# project_records.each do |project|
#   category_names = project.categories.pluck(:name).join(", ")
#   3.times do |j|
#     positions << Position.create!(
#       name: "Position #{j + 1} in #{category_names} for #{project.name}",
#       project: project,
#       vacancies: rand(3..5)
#     )
#   end
# end
#
# # Create applications for positions
# positions.each do |position|
#   max_applications = (position.vacancies / 3.0).ceil
#   eligible_applicants = people_records.reject { |person| person == position.project.owner }
#
#   eligible_applicants.sample(max_applications).each do |applicant|
#     Application.create!(
#       motivation: "I want to work on #{position.name}",
#       position: position,
#       person: applicant,
#       status: rand < 0.5 ? "accepted" : "pending"
#     )
#   end
# end
#
# puts "Seeds created successfully"