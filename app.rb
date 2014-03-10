require 'sinatra'
require 'stripe'
require 'haml'
require 'logger'
require 'money'
require 'sinatra/asset_pipeline'
require 'dotenv'
require 'mandrill'

require_relative 'lib/notifier'

class App < Sinatra::Base
  register Sinatra::AssetPipeline
  Dotenv.load

  set :publishable_key, ENV['PUBLISHABLE_KEY']
  set :secret_key, ENV['SECRET_KEY']

  enable :logging, :dump_errors, :raise_errors

  logger = Logger.new('log/app.log')

  Stripe.api_key = settings.secret_key

  get '/' do
    haml :index
  end

  post '/charge' do
    # Amount in cents
    @amount = params[:amount]
    @currency = Money.new(@amount).format

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :card  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :amount      => @amount,
      :description => 'Slow Coffee',
      :currency    => 'usd',
      :customer    => customer.id
    )

    Notifier.new.deliver(email: params[:stripeEmail], name: params[:stripeShippingName])
    haml :charge
  end
end

App.run!
