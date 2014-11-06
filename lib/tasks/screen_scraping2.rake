# encoding: utf-8
task :scrapi_casamentos => :environment do

	require 'nokogiri'
	require 'open-uri'
	require 'json'

	api_key = "AIzaSyDDLNVe5qNbTuUgj7MouRLiN9VjycHVxp4"

	for i in 1..296
		
		puts "PAGE: #{i}"
		entry = 0

		url = i == 1 ? "http://www.casamentos.com.br/casamentos" : "http://www.casamentos.com.br/casamentos--#{i}"
		doc = Nokogiri::HTML(open(url))

		cidades_estados = doc.css(".item-list-title .small")

		doc.css(".red").each do |item|

			entry += 1
			puts "ENTRY: #{entry}"

			url_vendor = item["href"]
			empresa_id = url_vendor.split("--e")[1]

			if Fornecedor.where(empresa_id: empresa_id).size == 0

				doc2 = Nokogiri::HTML(open(url_vendor))

				fornecedor = Fornecedor.new

				# NOME, ENDEREÇO E DESCRIÇÃO
				fornecedor.nome = item.text
				fornecedor.endereco = doc2.at_css(".npbottom").text
				fornecedor.categoria = item["href"].split("/")[3]
				fornecedor.empresa_id = empresa_id
				fornecedor.url = url_vendor
				fornecedor.descricao = doc2.css(".m5.mb10 p, .m5.mb10 ul").to_s

				match_data = /\n/.match(cidades_estados[entry-1].text).end(0)
				cidade_estado = cidades_estados[entry-1].text[match_data..-1].strip[1..-1] if match_data
				fornecedor.estado = cidade_estado[/\(.*?\)/][1..-2] if cidade_estado
				fornecedor.cidade = cidade_estado.gsub(/\(.*?\)/, '').strip if cidade_estado

				map = doc.at_css("#staticmap")
				unless fornecedor.lat
					coords = map.attributes["src"].value.split("&center=")[1].split("&")[0].split(",") if map
					fornecedor.lat = coords[0] if coords
					fornecedor.lng = coords[1] if coords
				end

				puts fornecedor.nome

				#PROMOÇÃO
				promocao = doc2.at_css(".promo-item .red")
				if promocao
					fornecedor.promocao_titulo = promocao.text.squish
					fornecedor.promocao_link = promocao[:href]
					fornecedor.promocao_descricao = doc2.at_css(".promo-item .small").text.squish
				end
				
				#TELEFONE
				doc3 = Nokogiri::HTML(open("http://www.casamentos.com.br/emp-ShowTelefonoTrace.php?id_empresa=#{fornecedor.empresa_id}"))
				fornecedor.telefone = doc3.at_css(".mas-phone strong").text.squish
				puts "Fone #{fornecedor.telefone}"

				#REVIEWS
				reviews = doc2.at_css(".ico.mas-reviews")
				fornecedor.reviews = reviews.next_sibling.text if reviews

				# GOOGLE PLACES
				if fornecedor.lat && fornecedor.lng && (fornecedor.site.nil? || fornecedor.telefone2.nil?)
					url1 = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{f.lat},#{f.lng}&radius=1000&name=#{URI::escape(f.nome)}&sensor=false&key=#{api_key}"
					json1 = JSON.parse(open(url1, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
					results = json1["results"]
					unless results.empty?
						reference = results[0]["reference"]
						url2 = "https://maps.googleapis.com/maps/api/place/details/json?reference=#{reference}&sensor=true&key=#{api_key}"
						json2 = JSON.parse(open(url2, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
						phone = json2["result"]["formatted_phone_number"]
						site = json2["result"]["website"]
						puts "Site: #{site}"
						puts "Fone: #{phone}"
						fornecedor.site ||= site
						fornecedor.telefone2 ||= phone 
					end
				else
					puts "Sem info sobre lat/lng"
				end

				fornecedor.save

				#FAQS
				detalhes = Nokogiri::HTML(open("#{url_vendor}/detalhes"))
				faqs = detalhes.css(".faqs li")
				puts "Sincronizando #{faqs.size} faqs ..."
				faqs.each do |faq|
					qid = faq.attributes["id"].value.split("_")[1]
					question_value = faq.css(".question").text.squish
					#puts question_value
					question = Question.find_or_create_by_qid_and_content(:qid => qid, :content => question_value)
					answer_value = faq.css(".overflow").text.squish
					#puts answer_value
					answer = Answer.create(question_id: question.id, content: answer_value)
					fornecedor.answers << answer
				end	

				folder = "Fotos/#{fornecedor.id}"
				Dir::mkdir(folder)

				#LOGO
				logo_url = doc2.at_css(".empresa-logo").attributes["src"].value
				puts "Baixando logo ..."
				logo_ext = File.basename(logo_url).split(".").last
				logo_name = "logo.#{logo_ext}"
			    begin
			      File.open("#{folder}/#{logo_name}",'wb'){ |f| f.write(open(logo_url).read) }
			    rescue Exception => exc
			      puts "Problema no download do logo"
			    end
				
				#FOTOS
				fotos_size = doc2.css(".col2 li").size
				fotos_size = 20 if fotos_size > 20
				puts "Baixando #{fotos_size} fotos ..."
				for j in 0..(fotos_size-1)
					doc4 = Nokogiri::HTML(open("#{url_vendor}/fotos/#{j}"))
					foto_url = doc4.at_css("#fotoPrincipal").attributes["src"].value
					foto_ext = File.basename(foto_url).split(".").last
					foto_name = "#{fornecedor.nome.parameterize}-#{j}.#{foto_ext}"
				    begin
				      File.open("#{folder}/#{foto_name}",'wb'){ |f| f.write(open(foto_url).read) }
				    rescue Exception => exc
				      puts "Problema no download da imagem #{j}"
				    end
				end

			else
				fornecedor = Fornecedor.where(empresa_id: empresa_id).first

				match_data = /\n/.match(cidades_estados[entry-1].text).end(0)
				cidade_estado = cidades_estados[entry-1].text[match_data..-1].strip[1..-1] if match_data
				fornecedor.estado = cidade_estado[/\(.*?\)/][1..-2] if cidade_estado
				fornecedor.cidade = cidade_estado.gsub(/\(.*?\)/, '').strip if cidade_estado

				fornecedor.save
			end

		end

	end # for
	
end