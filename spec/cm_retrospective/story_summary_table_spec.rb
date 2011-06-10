# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'fakeweb'

describe CmRetrospective::StorySummaryTable do

  before :all do
    @cmr = CmRetrospective.new(File.expand_path(File.dirname(__FILE__) + '/../cm_retrospective.yml'))
  end

  context :to_text do
    it "ストーリー名、タイプ、所要時間、ポイントをテキスト表で表示できる" do
      sst = @cmr.story_summary_table
      sst.to_text.should == <<EOS
type     point  spent  story_name
feature     13     6h  ほげほげほげ
bug          -     3h  xxxxが動かない
EOS
    end
  end
end
