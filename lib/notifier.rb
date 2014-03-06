require 'rubygems'
require 'bundler/setup'
require 'mandrill'

class Notifier
  def deliver(opts = {})

    m = Mandrill::API.new
    message = {
     subject: 'Slow Coffee Thanks You!',
     from_name: 'Nick at Slow Coffee',
     text: 'Thank you so much for your order',
     to: [
       {
         email: opts[:email],
         name: opts[:name]
       }
     ],
     from_email: 'nick@slowcoffee.co'
    }
    sending = m.messages.send message
    puts sending
  end
end
