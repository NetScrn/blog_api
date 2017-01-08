require "rails_helper"

RSpec.describe "Rate post", :type => :request do
  let(:user) { create(:user) }
  let(:blog_post) { create(:post, author_id: user.id) }

  it "create valid rating for post" do
    expect{
      post "/posts/#{blog_post.id}/rate",
           params: { value: 1 },
           headers: { 'ACCEPT' => 'application/json' }
    }.to change(blog_post.ratings, :count).by(1)
    expect(response).to have_http_status(:ok)
  end

  it "invalid rating for post" do
    expect{
      post "/posts/#{blog_post.id}/rate",
           params: { value: 6 },
           headers: { "ACCEPT" => 'application/json' }
    }.to_not change(blog_post.ratings, :count)
    expect(response).to have_http_status(:unprocessable_entity)
    expect(JSON.parse(response.body)).to eq({ 'errors' => {'value' => ['is not included in 1 to 5']}})
  end

  it "invalid post id" do
    post "/posts/#{blog_post.id + 1}/rate",
         params: { value: 1 },
         headers: { "ACCEPT" => 'application/json' }
    expect(response).to have_http_status(:not_found)
  end
end