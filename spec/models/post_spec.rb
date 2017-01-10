require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { create(:post, author: create(:user)) }
  it "correctly resets ave cache" do
    create(:rating, value: 1, post: post)
    create(:rating, value: 5, post: post)
    post.reset_ave_cache
    expect(post.ave_cache).to eq 3.0
  end
end