class MeritsAction < ActiveRecord::Base
  belongs_to :user_merits_info
  #attr_accessible :action, :score, :user_merits_info_id
  # Hash com os pontos e ações
  # review = escrever uma recomendacao
  # indicacao = o seu amigo indicado cadastra-se no site
  # token = gera um novo token
  ACTIONS = {"review" => 20, "indicacao" => 30, "token" => 10, "guiaBusca" => 5}
end
