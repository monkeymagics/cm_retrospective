# -*- coding: utf-8 -*-
require 'active_support/core_ext'
require 'pivotal_tracker'

class CmRetrospective

  autoload :StorySummaryTable, "cm_retrospective/story_summary_table"

  attr_reader :config, :project, :current_iteration

  def initialize(config_path)
    @config_path = config_path
    @config = YAML.load_file(@config_path)
    @config = @config.symbolize_keys

    load_pivotal_tracker
  end

  def load_pivotal_tracker
    ::PivotalTracker::Client.token = @config[:token]
    @project = ::PivotalTracker::Project.find(@config[:project_id])
    @current_iteration = ::PivotalTracker::Iteration.current(project)
  end

  def story_summary_table(options = {})
    StorySummaryTable.new
  end

  def velocity(options = {})
    35
  end

  def velocity_per_pair_day(options = {})
    3.0
  end

  def velocity_per_pair_rotation(options = {})
    2.5
  end
end
