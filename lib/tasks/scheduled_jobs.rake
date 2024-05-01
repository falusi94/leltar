# frozen_string_literal: true

namespace :scheduled_jobs do
  desc 'Run scheduled jobs'
  # rake scheduled_jobs:perform['testjob']

  task :perform, [:job_name] => [:environment] do |_t, args|
    Rails.logger.info("Executing #{args.job_name}")

    args.job_name.constantize.perform
  end
end
