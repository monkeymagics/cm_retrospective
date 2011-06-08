# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "CmRetrospective" do

  it "最も簡単な使い方" do
    # CmRetrospective.newに渡す設定ファイルのパスは、それを使うコマンドで求めるor入力させる
    # 未入力時には設定ファイルは、カレントディレクトリからルートに向かって検索する
    # デフォルトのファイル名は、cm_retrospective.yml


    cmr = CmRetrospective.new("~/cm2/cm_retrospective.yml")

    # 設定ファイルには以下の設定が可能。
    #  * pivotalのトークン
    #  * プロジェクトのpivotalでのID
    #  * デフォルトのペア数
    #  * デフォルトの1日あたりのローテーション数
    #  * デフォルトの１イテレーションあたりの作業日数


    table = cmr.story_summary_table(:since => 1.week.ago)
    table.to_text.should == <<EOS
type     point  spent  story_name
feature     13     6h  ほげほげほげ
bug          -     3h  xxxxが動かない
EOS
    cmr.velocity(:since => 1.week.ago, :include => :delivered).should == 35
    cmr.velocity_per_pair_day(:since => 1.week.ago, :include => :delivered, :pair => 3.5).should == 10 # points / pair / day
    cmr.velocity_per_pair_rotation(:since => 1.week.ago, :include => :delivered, :pair => 3.5).should == 2.5 # points / pair / rotation
  end
end
