require_relative '../spec_helper'

describe 'homepage', type: :feature, js: true do
  it 'shows the buttons' do
    visit '/'
    page.should have_content 'Amount: $14.00'
  end

  it 'checks out correctly', js: true do
    visit '/'
    page.should have_content 'Amount: $20.00'
    page.find('#button-two').click_button 'Pay with Card'
    Capybara.within_frame 'stripe_checkout_app' do
      find('.yield') do
        fill_in 'email', with: 'iamnicholascox@gmail.com'
        fill_in 'name',  with: 'Nick Cox'
        fill_in 'one-line-address', with: '7352 11th Ave NW'
        fill_in 'zip', with: '98117'
        fill_in 'city', with: 'Seattle'
        click_button 'Payment Info'
        fill_in 'card_number', with: '4242424242424242'
        fill_in 'cc-exp', with: '02/22'
        fill_in 'cc-csc', with: '222'
        click_button 'Pay'
      end
    end
    page.should have_content 'Thanks'
  end
end
