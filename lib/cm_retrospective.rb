# -*- coding: utf-8 -*-
require 'active_support/core_ext'
class CmRetrospective

  autoload :StorySummaryTable, "cm_retrospective/story_summary_table"

  def initialize(config_path)
    @config_path = config_path
  end

  def story_summary_table(options = {})
    StorySummaryTable.new
  end

  def velocity(options = {})
    35
  end

  def velocity_per_pair_day(options = {})
    10
  end

  def velocity_per_pair_rotation(options = {})
    2.5
  end
end
