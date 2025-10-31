class SubsMailer < ApplicationMailer

  def subs_confirm
    @payment = params[:payment]
    @event   = @payment.ticket.event
    @client  = @payment.client

    mail(to: @client.email, subject: "Evento: #{@event.name} - Inscrição Registrada!")
  end

  def subs_success
    @payment = params[:payment]
    @event   = @payment.ticket.event
    @client  = @payment.client

    mail(to: @client.email, subject: "Evento: #{@event.name} - Inscrição Confirmada!!")
  end

  def subs_cancel
    @payment        = params[:payment]
    @event          = @payment.ticket.event
    @client         = @payment.client
    @url_all_events = Rails.application.routes.url_helpers.company_all_events_path(company_id: @payment.company_id)

    mail(to: @client.email, subject: "Evento: #{@event.name} - Inscrição Cancelada!!")
  end

end
