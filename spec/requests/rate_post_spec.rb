require "rails_helper"

RSpec.describe "Rate post", :type => :request do
  let(:user) { create(:user) }
  let(:blog_post) { create(:post, author_id: user.id) }

  it "create valid rating for post" do
    expect{
      post "/posts/#{blog_post.id}/rate",
           params: { value: 1 },
           headers: { "ACCEPT" => "application/json" }
    }.to change(blog_post.ratings, :count).by(1)
    expect(response).to have_http_status(:ok)
  end
end