require 'rails_helper'

RSpec.describe 'POST /sessions' do
  it 'routes POST /sessions' do
    expect(post: '/sessions').to route_to(controller: 'sessions', action: 'create')
  end
end
