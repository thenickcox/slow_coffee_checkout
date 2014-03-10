require 'sinatra'
require 'stripe'
require 'haml'
require 'logger'
require 'money'
require 'sinatra/asset_pipeline'
require 'dotenv'
require 'mandrill'

require_relative 'lib/notifier'
require_relative 'application_helper'

class App < Sinatra::Base
  register Sinatra::AssetPipeline
  Dotenv.load

  helpers do
    include ApplicationHelper
  end

  set :publishable_key, ENV['PUBLISHABLE_KEY']
  set :secret_key, ENV['SECRET_KEY']

  enable :logging, :dump_errors, :raise_errors
  logger = Logger.new('log/app.log')

  Stripe.api_key = settings.secret_key

  get '/' do
    haml :index
  end

  post '/charge' do
    @currency = format_currency

    customer = Stripe::Customer.create(create_customer(params))
    charge_params = create_charge(params)
    charge_params[:customer] = customer.id
    charge = Stripe::Charge.create(charge_params)

    deliver_confirmation_email(params)

    haml :charge
  end

end

