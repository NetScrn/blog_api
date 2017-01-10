require "rails_helper"

RSpec.describe "Get top ave posts", :type => :request do
  let(:user) { create(:user) }
  let(:post1) { create(:post, author: user, title: 'First title', content: 'First Content') }
  let(:post2) { create(:post, author: user, title: 'Second title', content: 'Second Content') }
  let(:post3) { create(:post, author: user, title: 'Third title', content: 'Third Content') }

  it "Return right top average posts: sql method" do
    create(:rating, post: post1, value: 1)
    create(:rating, post: post2, value: 2)
    create(:rating, post: post3, value: 3)

    get "/posts/top_ave",
         params: { amount: 2 },
         headers: { 'ACCEPT' => 'application/json' }
    expect(JSON.parse response.body).to include({"title" => post2.title, "content" => post2.content})
    expect(JSON.parse response.body).to include({"title" => post3.title, "content" => post3.content})
    expect(JSON.parse response.body).to_not include({"title" => post1.title, "content" => post1.content})

    create(:rating, post: post1, value: 5)
    get "/posts/top_ave",
         params: { amount: 2 },
         headers: { 'ACCEPT' => 'application/json' }
    expect(JSON.parse response.body).to_not include({"title" => post2.title, "content" => post2.content})
    expect(JSON.parse response.body).to include({"title" => post3.title, "content" => post3.content})
    expect(JSON.parse response.body).to include({"title" => post1.title, "content" => post1.content})
  end

  # it "Return right top average posts: ave_cache method" do
  #
  #
  #   get "/posts/top_ave",
  #       params: { amount: 2 },
  #       headers: { 'ACCEPT' => 'application/json' }
  #
  #   get "/posts/top_ave",
  #       params: { amount: 2 },
  #       headers: { 'ACCEPT' => 'application/json' }
  # end
end