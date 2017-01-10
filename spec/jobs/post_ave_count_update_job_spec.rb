require 'rails_helper'

RSpec.describe PostAveCountUpdateJob, type: :job do
  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      PostAveCountUpdateJob.perform_later
    }.to have_enqueued_job(PostAveCountUpdateJob)
  end

  it "matches with enqueued job" do
    ActiveJob::Base.queue_adapter = :test
    expect {
      PostAveCountUpdateJob.perform_later
    }.to have_enqueued_job.on_queue("default")
  end
end
