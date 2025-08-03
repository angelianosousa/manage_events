# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Company Demo
company = Company.find_or_create_by(name: 'Empresa XPTO')

# Create Admin Demo
Admin.find_or_initialize_by(company_id: company.id, name: 'Demo User', email: 'admin.demo@teste.com') do |admin|
  admin.password              = 'adminteste#321'
  admin.password_confirmation = 'adminteste#321'
  admin.save
end

cliente = Client.find_or_initialize_by(company_id: company.id, name: 'Demo User', email: 'client.demo@teste.com') do |client|
  client.password              = 'clientteste#321'
  client.password_confirmation = 'clientteste#321'
  client.save
end

5.times do |_t|
  Event.find_or_create_by(company_id: company.id, name: Faker::Name.name) do |event|
    event.description   = Faker::Lorem.paragraph_by_chars
    event.category_name = Faker::Job.field
    event.date_start    = Faker::Date.between(from: 2.months.ago, to: Date.today)
    event.date_end      = Faker::Date.between(from: 1.months.ago, to: Date.today)
    event.time_start    = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :short)
    event.time_end      = Faker::Time.between(from: DateTime.now - 1, to: DateTime.now, format: :short)
    event.build_address(place_name: Faker::Address.community, address_name: Faker::Address.full_address)

    ticket = event.tickets.build(
      name: 'Padrão',
      quantity: rand(300..1000),
      price: rand(50..1000)
    )

    payments = rand(50..200).times.map do |_t|
      {
        company_id: company.id,
        user_account_id: cliente.id,
        due_date: Date.today + 10.days,
        price: ticket.price
      }
    end

    ticket.ticket_payments.build(payments)
    event.save
  end
end
