# encoding: utf-8
task :scrapi_church => :environment do

	require 'nokogiri'
	require 'open-uri'

	for i in 1..8
		
		igreja = 0

		doc = Nokogiri::HTML(open("http://planejandocasamento.com.br/fornecedores/category/igrejas/page/#{i}/"))
		doc.css("#contentblock").each do |item|

			igreja += 1

			#if (i == 1 && igreja > 9) || i > 1
			if true

				v = Vendor.new
				a = Address.new
				p = Photo.new
				v.addresses << a
				v.photos << p
				v.type = "Church"
				v.featured = 0
				a.city = "São Paulo"
				a.state = "SP"

			  church_name = item.at_css(".postmeta2 a").text
			  puts church_name
			  v.name = church_name
			  link = item.at_css(".postmeta2 a")[:href]
			  street = item.at_css(".date p").text
			  puts street
			  a.street = street

			  doc2 = Nokogiri::HTML(open(link))

			  if doc2.at_css(".alignnone")
				  image = doc2.at_css(".alignnone").attributes["src"].to_s
				  image = doc2.at_css(".alignnone img").attributes["src"].to_s if image == ""
				  if image
				  	p.remote_image_url = image
				  	p.name = "igreja-#{church_name}-1".parameterize
						p.save
				  end
				end

				endereco = doc2.at_css("#infoblock").xpath('//div/b')
				endereco.each do |e|
					bairro = e.next_sibling.text if e.text == "Bairro: "
					puts bairro
					a.district = bairro if bairro
					cep = e.next_sibling.text if e.text == "CEP: "
					puts cep
					a.zipcode = cep if cep
					fone = e.next_sibling.text if e.text == "Telefone: "
					puts fone
					fone2 = fone.split("/") if fone
					a.phone1 = fone2[0].split("(fax)")[0].strip if fone2 && fone2.size > 0
					a.phone2 = fone2[1].split("(fax)")[0].strip if fone2 && fone2.size > 1
					funcionamento = e.next_sibling.text if (e.text == "Horário de funcionamento: " || e.text == "Atendimento: ")
					puts funcionamento
					v.description = funcionamento if funcionamento
				end

				net = doc2.css("#infoblock a")
				net.each do |n|
					thumb = n.children[0].attributes["src"].to_s
					site = n[:href] if thumb == "http://planejandocasamento.com.br/img/ico_link.png"
					puts site
					v.website = site if site
					email = n[:href].split(":")[1] if thumb == "http://planejandocasamento.com.br/img/ico_email.png"
					puts email
					v.email = email if email
				end

				tags = doc2.css(".tags a")
				tags.each do |t|
					catolica = true if t.text == "Católica"
					puts catolica
					v.details_field1 = 1 if catolica
				end

				pv = Vendor.where{name.like "%#{church_name}%"}
				v.name = "#{church_name} [#{pv.size+1}]" if pv.size > 0

				v.save
				a.save

			end # if igreja > x

		end

	end # for
	
end