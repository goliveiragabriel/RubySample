# encoding: utf-8
class Message < ModestModel::Base
  attributes :email, :content, :subject, :body, :type,
  			 :nome_fantasia, :razao_social, :cnpj, :telefone, :endereco, :site, :cnpj, :contato, :cargo, :proposal, :featured
  
  #  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  #  validates_presence_of :email, :nome_fantasia
  #validates_length_of :conteudo, :maximum => 500

  def body_cadastro
  	t = "Nome: #{nome_fantasia} \n"
  	t += "Razão Social: #{razao_social}  \n"
  	t += "Endereço: #{endereco}  \n"
  	t += "CNPJ: #{cnpj}  \n"
  	t += "Site: #{site}  \n"
  	t += "Telefone: #{telefone}  \n"
  	t += "Contato: #{contato}  \n"
  	t += "Email: #{email}  \n"
  	t += "Cargo: #{cargo}  \n"
  	t += "Comentários: \n #{content}"
    t += "Tipo Plano: \n #{featured}"
  	t.html_safe
  end

  def body_atualizacao
  	t = "Nome: #{nome_fantasia}  \n"
  	t += "Telefone: #{telefone}  \n"
  	t += "Contato: #{contato}  \n"
  	t += "Email: #{email}  \n"
  	t += "Cargo: #{cargo}  \n"
  	t += "Comentários: \n #{content}"
  	t
  end

end