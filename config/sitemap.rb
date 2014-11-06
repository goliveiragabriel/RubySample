require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://www.bemcasados.art.br'
SitemapGenerator::Sitemap.create do

  add '/d/users/register', changefreq: 'monthly'
  add '/sobre-a-empresa', changefreq: 'monthly' 

  Vendor.find_each do |vendor|
    add fornecedores_path(service: vendor.translated_type, 
                          city: vendor.city.parameterize, 
                          id: vendor), lastmod: vendor.updated_at, changefreq: 'monthly'
  end

  User.find_each do |user|
    add recomendacoes_path(uid: user), lastmod: user.updated_at, changefreq: 'monthly' 
  end

  #Search.find_each do |search|
  Search.where("created_at > ?", 1.month.ago).where('user_id not in (?)', User.admin_ids).each do |search|
    add search_path(search), :lastmod => search.updated_at, changefreq: 'never'   
  end

  #Dress.find_each do |dress|
  #  add dress_path(dress), :lastmod => dress.updated_at, changefreq: 'monthly'   
  #end
  #add dresses_path, changefreq: 'weekly'   

  add_to_index '/blog/site.xml', changefreq: 'monthly' 
  add_to_index '/blog/post.xml', changefreq: 'weekly' 
  add_to_index '/blog/page.xml', changefreq: 'monthly' 
end