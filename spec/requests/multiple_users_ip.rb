require 'rails_helper'

RSpec.describe "Same ip from multiple users action" do
  let(:first_user) { create(:user, login: 'First user') }
  let(:second_user) { create(:user, login: 'Second user') }
  let(:third_user) { create(:user, login: 'Third user') }

  it "correct list" do
    create(:post, author: first_user, author_ip: '1.1.1.1')
    create(:post, author: second_user, author_ip: '1.1.1.1')
    create(:post, author: third_user, author_ip: '1.1.1.2')

    get '/posts/dup_ips', headers: { 'ACCEPT' => 'application/json' }
    expect(response.body).to include('1.1.1.1', first_user.login, second_user.login)
    expect(response.body).to_not include('1.1.1.2', third_user.login)
  end

  it "empty array if db is empty" do
    get '/posts/dup_ips', headers: { 'ACCEPT' => 'application/json' }
    expect(response.body).to eq '[]'
  end
end