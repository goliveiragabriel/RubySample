task :migrate_database_casamentos => :environment do

CATEGORY_LIST = {
"acessorios-noivas" => "Other",
"wedding-planner" => "Planner",
"fotografo-casamento" => "Photography", # Photography-foto
"musica-de-casamento" => "Band",
"animacao-festa" => "Band",
"filmagem-casamento" => "Photography", # Photography-filmagem
"chacara-casamento" => "Venue", # Venue-campo
"decoracao-casamento" => "Decoration",
"beleza-noivas" => "Beauty",
"atelier-noiva" => "Garment",
"buffet-casamento" => "Catering",
"bolo-casamento" => "Cake", # Cake-bolo
"doces-casamento" => "Cake", # Cake-doces
"lembrancas-de-casamento" => "Gift",
"carros-casamento" => "Other", # Other-carros
"casa-para-casamento" => "Venue",
"sitio-casamento" => "Venue", # Venue-campo
"hotel-casamento" => "Venue", # Venue-hotel
"salao-casamento" => "Venue", # Venue-salao
"convites-de-casamento" => "Invitation",
"restaurante-casamento" => "Venue", # Venue-restaurante
"fazenda-casamento" => "Venue", # Venue-campo
"lua-de-mel" => "Travel",
"florista-casamento" => "Decoration",
"roupas-para-festa" => "Garment",
"lista-de-casamento" => "Registry",
"roupa-noivo" => "Garment", # Garment-noivo
"alianca-casamento" => "Jewelry",
"tendas-casamentos" => "Other", # Other-tendas
"lojas-de-noiva" => "Garment",
"aluguel-roupa-noivo" => "Garment", # Garment-noivo-aluguel,
"cuidado-masculino" => "Beauty" # Beauty-masculino
}

Fornecedor.where("id > ? AND id < ?", 3562, 3571).each do |f| # 0 - 3570

	# SE nome_antigo = nome_novo OU tel-antigo=tel-novo OU email... OU website... ,
	# ENTÃO tem duplicação, e podemos copiar só as informações que ainda não estão no nosso site
	# SE NÃO sussa, copia tudo porque é um fornecedor novo

	query1 = Vendor.where{name.matches f.nome} if f.nome
	query2 = Vendor.where(website: f.site) if f.site
	#phones = [f.telefone, f.telefone2].compact
	#query3 = Address.where{phone1.like_any phones}
	#query4 = Address.where{phone2.like_any phones}

	query = []
	query << query1.first if query1 && query1.size > 0
	query << query2.first if query2 && query2.size > 0
	#query << query3.first.vendor if query3.size > 0
	#query << query4.first.vendor if query4.size > 0
	query = query.uniq

	create_vendor = query.size > 0 ? false : true

	dist = query.size > 0 ? query[0].addresses.first.distance_from([f.lat,f.lng]) : 1000
	#create_vendor = dist > 50 ? true : false
		
	if create_vendor

		puts "Creating id #{f.id} - #{f.nome} ..."

		vendor = Vendor.new
		vendor.name = f.nome
		vendor.website = f.site
		vendor.description = f.descricao
		vendor.type = CATEGORY_LIST[f.categoria]
		vendor.featured = 0
		vendor.save

		puts "A"
		vendor2 = Vendor.find(vendor.id)
		if f.categoria == "fotografo-casamento"
			vendor2.foto = true
		elsif f.categoria == "filmagem-casamento"
			vendor2.filmagem = true
		elsif f.categoria == "chacara-casamento"
			vendor2.campo = true
		elsif f.categoria == "bolo-casamento"
			vendor2.bolo = true
		elsif f.categoria == "doces-casamento"
			vendor2.doces = true
		elsif f.categoria == "carros-casamento"
			vendor2.carros = true
		elsif f.categoria == "sitio-casamento"
			vendor2.campo = true
		elsif f.categoria == "hotel-casamento"
			vendor2.hotel = true
		elsif f.categoria == "salao-casamento"
			vendor2.salao = true
		elsif f.categoria == "restaurante-casamento"
			vendor2.restaurante = true
		elsif f.categoria == "fazenda-casamento"
			vendor2.campo = true
		elsif f.categoria == "roupa-noivo"
			vendor2.noivo = true
		elsif f.categoria == "tendas-casamentos"
			vendor2.tendas = true
		elsif f.categoria == "aluguel-roupa-noivo"
			vendor2.noivo = true
			vendor2.aluguel = true
		elsif f.categoria == "cuidado-masculino"
			vendor2.masculino = true
		end

		puts "B"

		address = Address.new
		address.street = f.endereco
		address.state = f.estado
		address.city = f.cidade
		address.latitude = f.lat
		address.longitude = f.lng
		address.phone1 = f.telefone
		address.phone2 = f.telefone2

		#street = address.street.gsub(/\(.*?\)/, '')
		street = address.street.sub("(#{f.estado})", '')
		street = street.reverse.sub(f.cidade.reverse, '').reverse
		cep = f.endereco[/\d{5}-\d{3}/] || f.endereco[/\d{8}/]
		if cep
			address.zipcode = cep
			street = street.gsub(/\d{5}-\d{3}/, '').gsub(/\d{8}/, '')
		end
		address.street = street.split(/[[:space:]]/).join(" ")

		address.vendor = vendor2
		address.save

		puts "C"

		dir_str =  "C://Users//Gabriel//Documents//bemcasados//documentos//casamento.com.br2//#{f.id}"
		filename_photos = Dir["#{dir_str}/*"]
		filename_photos.first(20).each do |photo|
			p = Photo.new
			p.image = File.open(photo)
		    p_id = vendor2.photos.size + 1
		    p.name = "#{vendor2.translated_type}-#{vendor2.name}-#{p_id}".parameterize
		    vendor2.photos << p
		    p.save
		    puts "Photo: #{p_id}"
		end

		puts "D"

		# Q&A
		capacity = f.answers.where(question_id: 67)
		vendor2.details_field3 = capacity.first.content[/[0-9]+/] if capacity.size > 0

		cerimonia = f.answers.where(question_id: 35)
		if vendor2.type == "Venue" && cerimonia.size > 0
			vendor2.cerimonia = true
		end

		banda = f.answers.where(question_id: 55)
		if vendor2.type == "Band" && banda.size > 0
			vendor2.dj = true if banda.first.content.include?("DJ")
			vendor2.banda = true if banda.first.content.include?("banda")
			vendor2.coral = true if banda.first.content.include?("coro")
			vendor2.orquestra = true if banda.first.content.include?("orquestra")
		end

		puts "E"
		vendor2.save

		puts "F"
		f.id_bemcasados = vendor2.id
	else
		vendor = query.first
		f.id_bemcasados = vendor.id
		puts "Already Exists: #{f.id} (dist = #{dist}; id_bemcasados = #{f.id_bemcasados})"
		
		dir_str =  "C://Users//Gabriel//Documents//bemcasados//documentos//casamento.com.br2//#{f.id}"
		filename_photos = Dir["#{dir_str}/*"]
		filename_photos.first(20).each do |photo|
			p = Photo.new
			p.image = File.open(photo)
		    p_id = vendor.photos.size + 1
		    p.name = "#{vendor.translated_type}-#{vendor.name}-#{p_id}".parameterize
		    p.vendor = vendor
		    p.save
		    puts "Photo: #{p_id}"
		end
	end	
	f.save
end

end