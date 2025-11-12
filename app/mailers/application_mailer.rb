class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('DEFAULT_MAIL', 'no-replay@geventos.com')

  layout 'mailer'

  def sendgrid_api_send(to:, subject:, html_content:)
    from     = SendGrid::Email.new(email: 'no-reply@geventos.com')
    to_email = SendGrid::Email.new(email: to)
    content  = SendGrid::Content.new(type: 'text/html', value: html_content)
    mail     = SendGrid::Mail.new(from, subject, to_email, content)

    sg = SendGrid::API.new(api_key: ENV['SENDGRID_API_KEY'])
    sg.client.mail._('send').post(request_body: mail.to_json)
  end
end
