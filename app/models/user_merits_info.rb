# encoding: utf-8
class UserMeritsInfo < ActiveRecord::Base
  has_one :user
  belongs_to :merit
  has_many :merits_actions, :dependent => :destroy
  has_many :achievements, :dependent => :destroy
  attr_accessible :closed, :merit_id, :points, :user_id

  def set_achievements
    achievement = Achievement.new(
      :user_merits_info_id => id,
      :action_type => MeritsAction::ACTIONS.keys[0],
      :message => "Parabéns pelo cadastro. Esta é a sua barra de pontos. Comece escrevendo uma review e ganhe seus primeiros pontos.",
      :name => MeritsAction::ACTIONS.keys[0],
      :score => 5,
      :status => Achievement::STATUS[1]
    )
    achievement.save!
    achievement = Achievement.new(
      :user_merits_info_id => id,
      :action_type =>  MeritsAction::ACTIONS.keys[1],
      :message => "Que legal, a sua recomendação com certeza ajudará outras noivas. Agora deixe todas as suas amigas ficarem sabendo. Vá ao menu 'Meu Casamento' e indique uma amiga.",
      :name =>  MeritsAction::ACTIONS.keys[1],
      :score => 5,
      :status => Achievement::STATUS[0]
    )
    achievement.save!
    parent = achievements.where("action_type = ?", "review")
    child = achievements.where("action_type = ?", "indicacao")
    parent.first.update_attributes(:child_id => child.first.id)
  end
end
