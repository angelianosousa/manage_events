class SubsMailer < ApplicationMailer

  def subs_confirm
    @payment = params[:payment]
    @event   = @payment.ticket.event
    @client  = @payment.client

    locals = { :@payment => @payment, :@event => @event, :@client => @client, :@url_all_events => @url_all_events }
    html = render_to_string(template: 'subs_mailer/subs_confirm', layout: 'layouts/mailer', locals: locals)
    sendgrid_api_send(
      to: @client.email,
      subject: "Evento: #{@event.name} - Inscrição Registrada!",
      html_content: html
    )
  end

  def subs_success
    @payment = params[:payment]
    @event   = @payment.ticket.event
    @client  = @payment.client

    locals = { :@payment => @payment, :@event => @event, :@client => @client }
    html = render_to_string(template: 'subs_mailer/subs_success', layout: 'layouts/mailer', locals: locals)
    sendgrid_api_send(
      to: @client.email,
      subject: "Evento: #{@event.name} - Inscrição Confirmada!!",
      html_content: html
    )
  end

  def subs_cancel
    @payment        = params[:payment]
    @event          = @payment.ticket.event
    @client         = @payment.client
    @url_all_events = Rails.application.routes.url_helpers.company_all_events_path(company_id: @payment.company_id)

    locals = { :@payment => @payment, :@event => @event, :@client => @client, :@url_all_events => @url_all_events }
    html = render_to_string(template: 'subs_mailer/subs_cancel', layout: 'layouts/mailer', locals: locals)
    sendgrid_api_send(
      to: @client.email,
      subject: "Evento: #{@event.name} - Inscrição Cancelada!!",
      html_content: html
    )
  end

end
