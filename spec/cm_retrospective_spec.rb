# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'fakeweb'

describe "CmRetrospective" do

  before :all do
    # PivotalTracker::Project
    project_xml = nil
    File.open(File.expand_path(File.dirname(__FILE__) + '/fixtures/project.xml')) do |f|
      project_xml = f.read
    end
    FakeWeb.register_uri(:get, "http://www.pivotaltracker.com/services/v3/projects/291045",
      :headers => { 'X-TrackerToken' => "xxxxx", 'Content-Type' => 'application/xml' },
      :body => project_xml)

    # PivotalTracker::Iteration
    iterations_xml = nil
    File.open(File.expand_path(File.dirname(__FILE__) + '/fixtures/iterations.xml')) do |f|
      iterations_xml = f.read
    end
    FakeWeb.register_uri(:get, "http://www.pivotaltracker.com/services/v3/projects/291045/iterations/current",
      :headers => { 'X-TrackerToken' => "xxxxx", 'Content-Type' => 'application/xml' },
      :body => iterations_xml)

    # CmRetrospective.newに渡す設定ファイルのパスは、それを使うコマンドで求めるor入力させる
    # 未入力時には設定ファイルは、カレントディレクトリからルートに向かって検索する
    # デフォルトのファイル名は、cm_retrospective.yml
    @cmr = CmRetrospective.new(File.expand_path(File.dirname(__FILE__) + '/cm_retrospective.yml'))
    # 設定ファイルには以下の設定が可能。
    #  * pivotalのトークン
    #  * プロジェクトのpivotalでのID
    #  * デフォルトのペア数
    #  * デフォルトの1日あたりのローテーション数
    #  * デフォルトの１イテレーションあたりの作業日数
  end

  context "initialize" do
    it "初期化時の設定を取得します" do
      @cmr.config.should == {
        :token => "xxxxx",        # pivotalのトークン
        :project_id => 291045,    # プロジェクトのpivotalでのID
        :pair => 3.5,             # デフォルトのペア数
        :rotation => 3,           # デフォルトの1日あたりのローテーション数
        :iteration_days => 4.5    # デフォルトの１イテレーションあたりの作業日数
      }
    end

    it "プロジェクトが取得できる" do
      @cmr.project.name.should == "mm2"
    end

    it "currentのitrationが取得できる" do
      @cmr.current_iteration.number.should == 4
      @cmr.current_iteration.start.utc.strftime('%Y/%m/%d UTC').should == "2011/06/05 UTC"
      @cmr.current_iteration.finish.utc.strftime('%Y/%m/%d UTC').should == "2011/06/12 UTC"
    end
  end

  it "最も簡単な使い方" do
    table = @cmr.story_summary_table(:since => 1.week.ago)
    table.to_text.should == <<EOS
type     point  spent  story_name
feature     13     6h  ほげほげほげ
bug          -     3h  xxxxが動かない
EOS
#     cmr.velocity(:since => 1.week.ago, :include => :delivered).should == 35
#     cmr.velocity_per_pair_day(:since => 1.week.ago, :include => :delivered, :pair => 3.5).should == 10 # points / pair / day
#     cmr.velocity_per_pair_rotation(:since => 1.week.ago, :include => :delivered, :pair => 3.5).should == 2.5 # points / pair / rotation

    @cmr.velocity.should == 35
    # velocity_per_pair_rotation:  ストーリーのポイント数の合計 / 1イテレーションあたりのタイムボックス数の合計
    @cmr.velocity_per_pair_rotation.should == 2.5
    # velocity_per_pair_day:  ストーリーのポイント数の合計 / デフォルトのペア数 / デフォルトの1イテレーションあたりの日数
    @cmr.velocity_per_pair_day(:pair => 3.5, :iteration_days => 4.5).should == 3.0
  end

end
