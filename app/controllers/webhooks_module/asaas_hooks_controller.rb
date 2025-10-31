class WebhooksModule::AsaasHooksController < ApplicationController
  skip_before_action :verify_authenticity_token  # o Asaas não envia CSRF token

  def checkout_status
    payload = JSON.parse(request.body.read)

    event_type    = payload['event']
    checkout_data = payload['checkout']
    payment       = Payment.find_by(source_id: checkout_data['id'])

    unless payment.present?
      Rails.logger.error("Erro ao parsear JSON do webhook: #{e.message}")

      return head :not_found
    end

    # Processa conforme o evento
    case event_type
    when 'CHECKOUT_PAID'
      payment.paid! if payment.present?
    when 'CHECKOUT_EXPIRED'
      payment.expired! if payment.present?
    when 'CHECKOUT_CANCELED'
      payment.cancelled! if payment.present?
    else
      Rails.logger.info("Evento desconhecido: #{event_type}")
    end

    # Retorna 200 para confirmar que o webhook foi recebido
    head :ok
  rescue JSON::ParserError => e
    Rails.logger.error("Erro ao parsear JSON do webhook: #{e.message}")
    head :bad_request
  end
end
