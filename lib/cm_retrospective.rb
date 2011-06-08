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
end
