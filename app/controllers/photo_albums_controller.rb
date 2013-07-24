class PhotoAlbumsController < ApplicationController

  respond_to :html, :json, :xml
  layout Spud::Photos.base_layout
  skip_before_filter :verify_authenticity_token, :only => [:create]

  if Spud::Photos.galleries_enabled
    before_filter :get_gallery
  end

  after_filter :only => [:show, :index] do |c|
    if Spud::Photos.enable_full_page_caching
      c.cache_page(nil, nil, false)
    end
  end

  def index
    if @photo_gallery
      @photo_albums = @photo_gallery.albums.order('created_at desc')
    else
      @photo_albums = SpudPhotoAlbum.order('created_at desc')
    end
    respond_with @photo_albums
  end

  def show
    @photo_album = SpudPhotoAlbum.find_by_url_name(params[:id])
    if @photo_album.blank?
      flash[:error] = "Could not find the requested Photo Album"
      if params[:photo_gallery_id]
        redirect_to photo_gallery_photo_albums_path(params[:photo_gallery_id])
      else
        redirect_to photo_albums_path
      end
    else
      respond_with @photo_album
    end
  end

private

  def get_gallery
    @photo_gallery = SpudPhotoGallery.find_by_url_name(params[:photo_gallery_id])
    if @photo_gallery.blank?
      flash[:error] = "Could not find the requested Photo Gallery"
      if request.xhr?
        render :nothing => true, :status => 404
      else
        redirect_to photo_galleries_path
      end
      return false
    end
  end

end