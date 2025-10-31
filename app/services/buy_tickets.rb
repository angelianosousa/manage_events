class BuyTickets < ApplicationService

  def initialize(event, params)
    @event   = event
    @params  = params
    @company = @event.company
    @ticket  = @event.tickets.find @params[:payment][:ticket_id]
    @client  = find_client
  end

  def call
    ActiveRecord::Base.transaction do
      create_client unless @client.present?

      build_payment

      send_to_asaas unless @payment.ticket.free_ticket?

      @payment
    end
  end

  def build_payment
    @payment = Payment.build(
      company_id: @company.id,
      user_account_id: @client.id,
      paymentable: @ticket,
      price: @ticket.price,
      quantity: @params[:payment][:ticket_quantity]
    )

    return @payment if @client.errors.none?

    @client.errors.full_messages.each do |message|
      @payment.errors.add :base, message
    end

    @payment
  end

  def create_client
    @client = @company.clients.build(
      name: @params[:client][:name],
      email: @params[:client][:email],
      cpf: @params[:client][:cpf],
      phone: @params[:client][:phone]
    )

    @client.build_address(
      street: @params[:address][:street],
      neighborhood: @params[:address][:neighborhood],
      number: @params[:address][:number],
      city: @params[:address][:city],
      state: @params[:address][:state],
      zip_code: @params[:address][:zip_code],
      complement: @params[:address][:complement]
    )

    @client.save
  end

  def find_client
    @company.clients.find_by(email: @params[:client][:email])
  end

  def send_to_asaas
    AsaasGateway.call(@payment)
  end
end
