require "rails_helper"

RSpec.describe "Creating posts", :type => :request do
  let!(:user) {create(:user)}

  context "successfully" do
    it "with not existing user" do
      expect{
        post "/posts",
             params: { post: attributes_for(:post, author_ip: '1.1.1.1',
                                                   author_login: 'TestUser') },
             headers: { "ACCEPT" => "application/json" }
      }.to change(Post, :count).by(1)

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)

      expected_response = { 'title' => 'Text title',
                            'content' => 'Text content',
                            'author_ip' => '1.1.1.1',
                            'author_id' => User.last.id }
      expect(JSON.parse(response.body)).to include(expected_response)
    end

    it "with existing user" do
      expect{
        post "/posts",
             params: { post: attributes_for(:post, author_ip: '1.1.1.1', author_login: user.login) },
             headers: { "ACCEPT" => "application/json" }
      }.to_not change(User, :count)
      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(:ok)
    end
  end

  context "unsuccessfully" do
    it "with invalid post" do
      post_attrs = attributes_for(:post, author_ip: '1.1.1.1',
                                         author_login: 'TestUser',
                                         title: '',
                                         content: '')
      expect{
        post "/posts",
             params: { post: post_attrs },
             headers: { "ACCEPT" => "application/json" }
      }.to_not change(Post, :count)

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(422)

      expected_response = { 'errors' => {'post' => {'title' => ["can't be blank"],
                                                    'content' => ["can't be blank"]} } }
      expect(JSON.parse(response.body)).to include(expected_response)
    end

    it "with invalid user" do
      post_attrs = attributes_for(:post, author_ip: '1.1.1.1',
                                         author_login: '')
      expect{
        post "/posts",
             params: { post: post_attrs },
             headers: { "ACCEPT" => "application/json" }
      }.to_not change(Post, :count)

      expect(response.content_type).to eq("application/json")
      expect(response).to have_http_status(422)

      expected_response = { 'errors' => {'author' => {'login' => ["can't be blank"]} } }
      expect(JSON.parse(response.body)).to include(expected_response)
    end
  end
end