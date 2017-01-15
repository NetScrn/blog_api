require 'rails_helper'

RSpec.describe "Same ip from multiple users action" do
  let(:first_user) { create(:user, login: 'First user') }
  let(:second_user) { create(:user, login: 'Second user') }
  let(:third_user) { create(:user, login: 'Third user') }

  it "correct list" do
    first_post_attrs = attributes_for(:post, author_login: first_user.login, author_ip: '1.1.1.1')
    second_post_attrs = attributes_for(:post, author_login: second_user.login, author_ip: '1.1.1.1')
    third_post_attrs = attributes_for(:post, author_login: third_user.login, author_ip: '1.1.1.2')
    create_blog_post_through_http_post(first_post_attrs)
    create_blog_post_through_http_post(second_post_attrs)
    create_blog_post_through_http_post(third_post_attrs)
    get '/posts/dup_ips', headers: { 'ACCEPT' => 'application/json' }
    expect(response.body).to include('1.1.1.1', first_user.login, second_user.login)
    expect(response.body).to_not include('1.1.1.2', third_user.login)
  end

  it "empty array if db is empty" do
    get '/posts/dup_ips', headers: { 'ACCEPT' => 'application/json' }
    expect(response.body).to eq '[]'
  end
end