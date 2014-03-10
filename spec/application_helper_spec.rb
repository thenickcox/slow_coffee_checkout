require 'spec_helper'

class TestHelper
  include ApplicationHelper
end

describe 'ApplicationHelper' do
  let(:helper) { TestHelper.new }

  describe 'create_customer' do
    let(:params) {{
      stripeEmail: 'me@me.com',
      stripeToken: '123'
    }}
    it 'sets the hash correctly' do
      helper.create_customer(params).should == { email: 'me@me.com', card: '123' }
    end
  end

  describe 'format_currency' do
    let(:params) {{ amount: '1400' }}
    it { helper.format_currency(params).should == '$14.00' }
  end

  describe 'create_charge' do
    let(:params) {{ amount: '1400' }}
    let(:expected) {{
      amount: '1400',
      description: 'Slow Coffee',
      currency: 'usd',
    }}
    it { helper.create_charge(params).should == expected }
  end

  describe 'deliver_confirmation_email' do
    let(:params) {{
      stripeEmail: 'me@me.com',
      stripeShippingName: 'Nick Cox'
    }}
    it {
      Notifier.any_instance.should_receive(:deliver).with(
        name: 'Nick',
        email: 'me@me.com'
      )
      helper.deliver_confirmation_email(params)
    }
  end

  describe 'get_first_name' do
    let(:params) {{
      stripeShippingName: name
    }}

    subject { helper.get_first_name(params) }

    context 'first name, last name' do
      let(:name)       { 'Nick Cox' }
      let(:first_name) { 'Nick' }
      it { should == first_name }
    end

    context 'first name only' do
      let(:name)       { 'Nick' }
      let(:first_name) { 'Nick' }
      it { should == first_name }
    end

    context 'first, middle, last' do
      let(:name)       { 'Nicholas John Cox' }
      let(:first_name) { 'Nicholas' }
      it { should == first_name }
    end
  end

  describe 'get_email' do
    let(:params) {{ stripeEmail: 'me@me.com' }}

    subject { helper.get_email(params) }

    it { should == 'me@me.com' }
  end
end
