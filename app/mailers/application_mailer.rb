class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('DEFAULT_MAIL', 'no-replay@geventos.com')

  layout 'mailer'
end
