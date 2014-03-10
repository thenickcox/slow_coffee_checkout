require 'spec_helper'

describe 'App' do
  it 'gets the homepage successfully' do
    get '/'
    expect(last_response).to be_ok
  end

end
