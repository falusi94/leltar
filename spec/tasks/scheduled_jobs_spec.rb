# frozen_string_literal: true

RSpec.describe 'scheduled_jobs:perform', rakefile: 'scheduled_jobs' do
  let(:test_job) do
    Class.new(ScheduledJob) do
      def perform; end
    end
  end

  before do
    stub_const('TestJob', test_job)

    allow(test_job).to receive(:perform).and_call_original
  end

  it 'performs the correct job' do
    task.invoke('TestJob')

    expect(test_job).to have_received(:perform)
  end
end
