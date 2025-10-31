# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

if Rails.env.development?
  Master.find_or_initialize_by(name: 'Master Dev', email: 'master.dev@eventos.com') do |admin|
    admin.password              = 'master#321'
    admin.password_confirmation = 'master#321'
    admin.save
  end

  # Create Company Demo
  company = Company.find_or_create_by(name: 'Empresa XPTO') do |comp|
    comp.email     = Faker::Internet.email(domain: 'gmail.com')
    comp.phone     = Faker::Number.number(digits: 10)
    comp.cellphone = Faker::Number.number(digits: 10)
    comp.site      = Faker::Internet.url(host: "example.com")
  end

  # Create Admin Demo
  company.admins.find_or_initialize_by(company_id: company.id, name: 'Demo User', email: 'admin.demo@teste.com') do |admin|
    admin.password              = 'admin#321'
    admin.password_confirmation = 'admin#321'
    admin.save
  end

  cliente = company.clients.find_or_create_by(company_id: company.id, name: 'Demo User', email: 'client.demo@teste.com') do |client|
    client.name                  = 'Client test'
    client.email                 = 'client.demo@teste.com'
    client.cpf                   = CPF.generate
    client.phone                 = Faker::PhoneNumber.phone_number
    client.password              = 'client#321'
    client.password_confirmation = 'client#321'
    client.build_address(
      street: Faker::Address.street_name,
      neighborhood: Faker::Address.community,
      number: rand(1..999),
      city: Faker::Address.city,
      state: Faker::Address.state,
      zip_code: Faker::Address.zip_code,
      complement: 'Casa Teste'
    )
  end

  5.times do |_t|
    company.events.find_or_create_by!(name: Faker::Name.name) do |event|
      event.description = Faker::Lorem.paragraph_by_chars
      event.date_start  = Faker::Date.between(from: 2.months.ago, to: Date.today)
      event.time_start  = Time.now.noon + 2.hours
      event.time_end    = event.time_start + 6.hours
      event.categories << Faker::Job.field 
      event.build_address(
        street: Faker::Address.street_name,
        neighborhood: Faker::Address.community,
        number: rand(1..999),
        city: Faker::Address.city,
        state: Faker::Address.state,
        zip_code: Faker::Address.zip_code,
        complement: 'Casa Teste'
      )

      ticket = event.tickets.build(
        name: 'Padrão',
        quantity: rand(300..1000),
        price: rand(50..1000)
      )

      rand(50..80).times.map do |_t|
        Payment.build({
          company_id: company.id,
          paymentable: ticket,
          user_account_id: cliente.id,
          due_date: Date.today + 10.days,
          price: ticket.price,
          quantity: 1
        })
      end

      event.save
    end
  end
end

if Rails.env.production?
  company = Company.find_or_create_by(name: 'Empresa Demo', email: 'empresa.demo@gmail.com')
  company.build_admin_base(name: 'Empresa Demo', email: 'empresa.demo@gmail.com') do |admin|
    admin.password              = 'admin#321'
    admin.password_confirmation = 'admin#321'
    admin.save
  end

  Master.find_or_initialize_by(name: 'Master User', email: 'master.demo@eventos.com') do |admin|
    admin.password              = 'master#321'
    admin.password_confirmation = 'master#321'
    admin.save
  end
end
