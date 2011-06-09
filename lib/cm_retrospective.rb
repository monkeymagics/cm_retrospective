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

  def current_stories(options = {})
    # require 'active_support/core_ext'
    # PivotalTracker::Client.token = "xxxxx"
    # proj = PivotalTracker::Project.find(291045)
    # PivotalTracker::Iteration.current(proj).stories.sort_by{ |s| s.current_state }.map{ |s| "%8s %10s %3s %s" %  [s.story_type, s.current_state, s.estimate, s.name]}
    # 的なことをやりたい
    stories = <<EOS
     bug   accepted     タイムアウト強制停止したネストしたジョブネット内のジョブを選択して再実行すると実行スケジュールが終了しない場合がある
 feature   accepted   2 リリース計画を要員計画と共に見直す
 feature   accepted   1 0.9.8のNSリリースの問題に対する原因分析と対策案のレポートを作成する
 feature   accepted   3 九電向けMMの必要サーバー構成の見積もり案を提示する
   chore   accepted     九電、業務アプリの打ち合わせに参加する
     bug   accepted     NS#1776: ネストしたジョブネット内のジョブを選択して再実行すると、上位のレイヤーのFinallyジョブが実行されない
 feature   accepted   3 2.0で使用するオープンソースプロダクトのライセンスを調べる
 feature  delivered   8 見積の根拠とする為の機能一覧をまとめる
 feature  delivered   8 見積の根拠とする為の機能一覧をまとめる#レビュー
 feature   finished   1 0.9.8に必要なGemfileを間違いなく揃えられるようにする
 feature   finished   1 見積の根拠とする為の機能一覧をまとめる#修正
 feature    started   5 テスト環境の見積もり(サーバ)
 feature    started   5 CIを設定する
     bug    started     ジョブネットのスポット再実行を行った際に、ジョブネット内のfinallyのジョブが実行されない
   chore    started     プロダクト名の決定
 feature    started   5 イテレーション毎のdeliver/finishされているストーリーのポイントの合計を計算するツールを作成する
EOS
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
