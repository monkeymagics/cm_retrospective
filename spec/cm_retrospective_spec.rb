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

    it "現在のイテレーションでcurrentに入っているストーリーが取得できる" do
      stories = @cmr.current_stories(:attributes => [:story_time, :current_state, :estimate, :name])
      stories.should == [
        "     bug   accepted     タイムアウト強制停止したネストしたジョブネット内のジョブを選択して再実行すると実行スケジュールが終了しない場合がある",
        " feature   accepted   2 リリース計画を要員計画と共に見直す",
        "   chore   accepted     九電、業務アプリの打ち合わせに参加する",
        "     bug   accepted     NS#1776: ネストしたジョブネット内のジョブを選択して再実行すると、上位のレイヤーのFinallyジョブが実行されない",
        " feature   accepted   3 2.0で使用するオープンソースプロダクトのライセンスを調べる",
        " feature   accepted   1 0.9.8のNSリリースの問題に対する原因分析と対策案のレポートを作成する",
        " feature  delivered   8 見積の根拠とする為の機能一覧をまとめる",
        " feature  delivered   8 見積の根拠とする為の機能一覧をまとめる#レビュー",
        " feature   finished   1 見積の根拠とする為の機能一覧をまとめる#修正",
        " feature   finished   1 0.9.8に必要なGemfileを間違いなく揃えられるようにする",
        "     bug    started     ジョブネットのスポット再実行を行った際に、ジョブネット内のfinallyのジョブが実行されない",
        " feature    started   5 テスト環境の見積もり(サーバ)"
      ]
    end
  end

  it "最も簡単な使い方" do
    # このテストは最終的に消すこと
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

  context "iterations" do
    it "current_iterations からストーリーの一覧を取得できる"
    it "current_iterations と backlog からストーリーの一覧を取得できる"
    it "current_iterations のイテレーション開始日から定例後の時間(金曜日の12時)を算出できる"
    it "current_iterations のストーリーの一覧からの定例後のコメント(note)が取得できる"
  end

  context "ストーリーのコメントから所要時間を取得できる" do
    it "所要時間(半角数字)"
    it "所要時間(全角数字)"
    it "作業時間(半角数字)"
    it "作業時間(全角数字)"
  end

  context "ストーリーのコメントからペア数を取得できる" do
    it "半角数字を含む"
    it "全角数字を含む"
    it "半角アンパサンドを含む"
    it "全角アンパサンドを含む"

    it "作業者が2名の場合は1ペア"
    it "作業者が3名の場合は1ペア"
    it "作業者が4名の場合は2ペア"
    it "作業者が6名の場合は3ペア"
  end

  # 運用として、一度、backlogにいれたストーリーを何らかの理由でIceboxに戻したい場合は、定例でメンバーに確認してやること
  # （backlogとiceboxの行き来に関しては、チームの合意が必要）
  context "ストーリーのコメントから所要時間とペア数が取得できる" do
    it "current_state が not_yet_started"
    it "current_state が started"
    it "current_state が finished"
    it "current_state が deliverd"
    it "current_state が acepted"
    it "current_state が rejected"
    it "current_state が 全て対象(作業時間として認めるもの)"
    it "current_state が deliverd と finished のみ(速度として認めるもの)"
  end

  context "velocity_per_pair_rotation" do
    it "ストーリーのポイント数の合計 / 1イテレーションあたりのタイムボックス数の合計"
  end

  context "velocity_per_pair_day" do
    it "ストーリーのポイント数の合計 / デフォルトのペア数 / デフォルトの1イテレーションあたりの日数"
  end

end
