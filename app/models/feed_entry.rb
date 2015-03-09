# encoding: utf-8
class FeedEntry < ActiveRecord::Base
  attr_accessible :title, :summary, :content, :img_url, :url, :published_at, :guid, :categories
  serialize :categories

  # PK - slug da categoria
  # Infos - título + url da categoria
  FEEDS_CATEGORIES_RSS = {'primeira-decisao' => ["Primeira Decisão", "http://blog.bemcasados.art.br/tag/primeira-decisao/feed/"], 'apos-definicao-data' => [ "Após Definição da Data" ,'http://blog.bemcasados.art.br/tag/apos-definicao-da-data/feed/'], 
                      '6-12-meses' => ["6 a 12 meses antes", "http://blog.bemcasados.art.br/tag/6-a-12-meses-antes/feed/"], '3-6-meses' => ["3 a 6 meses antes", "http://blog.bemcasados.art.br/tag/3-a-6-meses-antes/feed/"], 
                      '2-meses' => ["2 meses antes", "http://blog.bemcasados.art.br/tag/2-meses-antes/feed/"], '2-3-semanas' => ["2 a 3 semanas antes", "http://blog.bemcasados.art.br/tag/2-a-3-semanas-antes/feed/"], 
                      '1-semana' => ["1 semana antes","http://blog.bemcasados.art.br/tag/1-semana-antes/feed/"] , 'volta-da-lua-de-mel' => ["Volta da Lua de Mel","http://blog.bemcasados.art.br/tag/volta-da-lua-de-mel/feed/"]}
  
  def self.update_from_feed(feed_url)
    feed = Feedzirra::Feed.fetch_and_parse(feed_url)
    add_entries(feed.entries)
  end
  
  # A rotina de atualização deve ser a seguinte:
  # executar: 
  # 1) FeedEntry.update_from_feed("http://blog.bemcasados.art.br/feed/rss2")
  # Deve ser executado uma única vez para atualizar as categorias dos posts que tem as tags da Hash acima
  def self.update_posts_from_feeds

    FEEDS_CATEGORIES_RSS.each do |tag, value|
      feed = Feedzirra::Feed.fetch_and_parse(value[1])
      feed.entries.each do |entry|
        unless exists? :guid => entry.id.split("?p=")[1]
          guid = entry.id.split("?p=")[1]
          post = FeedEntry.find_by_guid(guid)
          post.update_attributes(:categories => entry.categories)
        end
      end
    end

  end

  private
  
  def self.add_entries(entries)
    entries.each do |entry|
      unless exists? :guid => entry.id.split("?p=")[1]
        url = entry.url.split("?")[0]
        featured_img = Nokogiri::HTML(open(url)).css("#post-featured-images img").first
        #insere uma imagem default
        featured_img_url = featured_img ? featured_img.attributes["src"].to_s : "/assets/no-image.png"
        #img_url = entry.content.scan(/<img .*?>/)[0]
        #img_url = img_url.scan(/http.*.(?:png|jpg)/)[0] if img_url
        create!(
          :title        => entry.title,
          :summary      => entry.summary,
          :content      => entry.content,
          :img_url      => featured_img_url,
          :url          => url,
          :published_at => entry.published,
          :guid         => entry.id.split("?p=")[1],
          :categories   => entry.categories
        )
      end

    end

  end
end
