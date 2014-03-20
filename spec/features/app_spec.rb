require_relative '../spec_helper'

describe 'homepage', type: :feature, js: true do
  it 'shows the buttons' do
    visit '/'
    page.should have_content 'Amount: $14.00'
  end
end

describe 'checkout', type: :feature, js: true do
  it 'checks out correctly' do
    visit '/'
    page.should have_content 'Amount: $20.00'
    page.find('#button-two').click_button 'Pay with Card'
    Capybara.within_frame 'stripe_checkout_app' do
      fill_in 'Email', with: 'iamnicholascox@gmail.com'
      fill_in 'Name',  with: 'Nick Cox'
      fill_in 'Street', with: '7352 11th Ave NW'
      fill_in 'ZIP', with: '98117'
      fill_in 'City', with: 'Seattle'
      click_button 'Payment Info'
      fill_in 'Card number', with: '4242424242424242'
      fill_in 'MM/YY', with: '02/22'
      fill_in 'CVC', with: '222'
      click_button 'Pay'
    end
    page.should have_content 'Thanks'
  end
end
