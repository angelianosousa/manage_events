class SubsMailerPreview < ActionMailer::Preview
  def subs_confirm
    @payment = Payment.last
    @event   = @payment.ticket.event
    @client  = @payment.client

    SubsMailer.with(payment: @payment).subs_confirm
  end

  def subs_success
    @payment = Payment.last
    @event   = @payment.ticket.event
    @client  = @payment.client

    SubsMailer.with(payment: @payment).subs_success
  end

  def subs_cancel
    @payment        = Payment.cancelled.last
    @event          = @payment.ticket.event
    @client         = @payment.client
    @url_all_events = Rails.application.routes.url_helpers.company_all_events_path(company_id: @payment.company_id)

    SubsMailer.with(payment: @payment).subs_cancel
  end
end
