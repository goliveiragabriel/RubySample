# encoding: utf-8
class FeedEntriesController < AuthorizedController
  # GET /feed_entries
  # GET /feed_entries.json
  def index
    @feed_entries = FeedEntry.order("published_at DESC").page(params[:page]).per(10)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feed_entries }
    end
  end

  # GET /feed_entries/1
  # GET /feed_entries/1.json
  def show
    @feed_entry = FeedEntry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feed_entry }
    end
  end

  # GET /feed_entries/new
  # GET /feed_entries/new.json
  def new
    @feed_entry = FeedEntry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feed_entry }
    end
  end

  # GET /feed_entries/1/edit
  def edit
    @feed_entry = FeedEntry.find(params[:id])
  end

  # POST /feed_entries
  # POST /feed_entries.json
  def create
    @feed_entry = FeedEntry.new(params[:feed_entry])

    respond_to do |format|
      if @feed_entry.save
        format.html { redirect_to @feed_entry, notice: 'Feed entry was successfully created.' }
        format.json { render json: @feed_entry, status: :created, location: @feed_entry }
      else
        format.html { render action: "new" }
        format.json { render json: @feed_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feed_entries/1
  # PUT /feed_entries/1.json
  def update
    @feed_entry = FeedEntry.find(params[:id])

    respond_to do |format|
      if @feed_entry.update_attributes(params[:feed_entry])
        format.html { redirect_to @feed_entry, notice: 'Feed entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feed_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feed_entries/1
  # DELETE /feed_entries/1.json
  def destroy
    @feed_entry = FeedEntry.find(params[:id])
    @feed_entry.destroy

    respond_to do |format|
      format.html { redirect_to feed_entries_url }
      format.json { head :no_content }
    end
  end
  
  def update_from_feed
    FeedEntry.update_from_feed("http://blog.bemcasados.art.br/feed/rss2")

    respond_to do |format|
      format.html { redirect_to feed_entries_url, notice: 'Feeds atualizados.' }
    end
  end

  def update_categories
    feed = Feedzirra::Feed.fetch_and_parse("http://blog.bemcasados.art.br/feed/rss2")
    FeedEntry.all.each do |post|
      
      # unless post.categories
      #   feed.entries
      # end

    end

  end

end
