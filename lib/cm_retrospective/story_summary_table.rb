# -*- coding: utf-8 -*-

class CmRetrospective
  class StorySummaryTable
    def initialize(cmr)
      project = cmr.project
      @stories = project.stories.all
    end

    def to_text
      result = "type     point  spent  story_name\n"
      @stories.each do |s|
        spent = 0
        s.notes.all.each do |n|
          if (scaned_text = n.text.scan(/\d+\.*\d*h/)) && !scaned_text.empty?
            spent += scaned_text.first.first.to_i
          end
        end
        estimate = s.estimate || "-"
        result << "#{s.story_type.ljust(7, " ")} #{estimate.to_s.rjust(6, " ")} #{spent.to_s.rjust(5, " ")}h  #{s.name.force_encoding('UTF-8')}\n"
      end
      result
    end
  end
end
