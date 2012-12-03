class Notifier < ActionMailer::Base
  # default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.gmail_message.subject
  #
  def gmail_message(user,token)
    @token = token
    subject         'Restablecer Contrasena'
    recipients      user.email 
    from            'cnavarro@pernix-solutions.com'
    sent_on         Time.now
  end
end
