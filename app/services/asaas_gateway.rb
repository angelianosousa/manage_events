class AsaasGateway < ApplicationService
  include Rails.application.routes.url_helpers
  Rails.application.routes.default_url_options[:host] = ENV.fetch('SITE_DOMAIN', 'https://example.asaas.com')

  def initialize(payment)
    @payment      = payment
    @company      = @payment.company
    @client       = @payment.client
    @base_url     = ENV['ASAAS_BASE_URL']
    @access_token = @company.asaas_api_key

    # Conexão Faraday configurada
    @conn = Faraday.new(url: "#{@base_url}/checkouts") do |faraday|
      faraday.request :json # envia payload como JSON
      faraday.response :json, content_type: /\bjson$/ # parse automático do JSON
      faraday.response :logger, Rails.logger, bodies: true if Rails.env.development?
      faraday.adapter Faraday.default_adapter
    end
  end

  def call
    begin
      response = @conn.post do |req|
        req.headers['Access-Token'] = @access_token
        req.headers['Content-Type'] = 'application/json'
        req.body                    = asaas_payload
      end

      if response.success?
        @payment.source_id = response.body['id']
        @payment.link = response.body['link']
      else
        Rails.logger.error("Erro Asaas: #{response.status} - #{response.body['errors'[0]]}")

        raise ActiveRecord::Rollback, 'Erro ao criar checkout no Asaas'
      end
    rescue Faraday::Error => e
      Rails.logger.error("Erro Faraday: #{e.message}")

      raise ActiveRecord::Rollback
    end
  end

  private

  def asaas_payload
    {
      minutesToExpire: 10,
      externalReference: @payment.id,
      items: [{
        externalReference: "#{@payment.ticket.id}.#{@payment.id}",
        description: "Ingresso: #{@payment.ticket.name}",
        imageBase64: encode_image64(@payment.ticket.event&.banner&.image),
        name: @payment.ticket.event.name,
        quantity: @payment.quantity,
        value: @payment.ticket.price.to_f
      }],
      customerData: client_data,
      callback: {
        successUrl: checkout_url('success', @payment),
        expiredUrl: checkout_url('expired', @payment),
        cancelUrl: checkout_url('cancel', @payment)
      },
      billingTypes: %w[PIX CREDIT_CARD],
      chargeTypes: ['DETACHED']
    }
  end

  def encode_image64(attachment)
    file = attachment&.attached? ? attachment.blob.download : File.read('app/assets/images/placeholder.png')

    Base64.strict_encode64(file)
  end

  def checkout_url(type, payment)
    send(
      "company_subs_#{type}_url",
      company_id: payment.company.slug,
      event_name: payment.ticket.event.slug,
      token_pay: payment.token_pay
    )
  end

  def client_data
    {
      name: @client.name,
      cpfCnpj: @client.cpf,
      email: @client.email,
      phone: @client.phone,
      address: @client.address.street,
      addressNumber: @client.address.number,
      complement: @client.address.complement,
      postalCode: @client.address.zip_code,
      province: @client.address.city
    }
  end

end
