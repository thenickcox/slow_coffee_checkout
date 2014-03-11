module ApplicationHelper

  def create_customer(params)
    customer = Hash.new
    customer[:email] = params[:stripeEmail]
    customer[:card]  = params[:stripeToken]
    customer
  end

  def format_currency(params)
    Money.new(params[:amount]).format
  end

  def create_charge(params)
    charge = Hash.new
    charge[:amount] = params[:amount]
    charge[:description] = 'Slow Coffee'
    charge[:currency] = 'usd'
    charge
  end

  def deliver_confirmation_email(params)
    Notifier.new.deliver(email: get_email(params), name: get_first_name(params), amount: @currency)
  end

  def get_first_name(params)
    params[:stripeShippingName].split(' ').first
  end

  def get_email(params)
    params[:stripeEmail]
  end
end

