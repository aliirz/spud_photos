class Spud::Admin::PhotoGalleriesController < Spud::Admin::ApplicationController

  before_filter :get_gallery, :only => [:show, :edit, :update, :destroy]
  before_filter :get_albums, :only => [:new, :create, :edit, :update]
  respond_to :html, :json, :xml
  layout 'spud/admin/spud_photos'

  def index
    @photo_galleries = SpudPhotoGallery.all
    respond_with @photo_galleries
  end
  
  def show
    respond_with @photo_gallery
  end
  
  def new
    @photo_gallery = SpudPhotoGallery.new
    respond_with @photo_gallery
  end
  
  def create
    @photo_gallery = SpudPhotoGallery.new(params[:spud_photo_gallery])
    flash[:notice] = 'SpudPhotoGallery created successfully' if @photo_gallery.save
    respond_with @photo_gallery, :location => spud_admin_photo_galleries_path
  end
  
  def edit
    respond_with @photo_gallery
  end
  
  def update
    @photo_gallery.update_attributes(params[:spud_photo_gallery])
    flash[:notice] = 'SpudPhotoGallery updated successfully' if @photo_gallery.save
    respond_with @photo_gallery, :location => spud_admin_photo_galleries_path
  end
  
  def destroy
    flash[:notice] = 'SpudPhotoGallery deleted successfully' if @photo_gallery.destroy
    respond_with @photo_gallery, :location => spud_admin_photo_galleries_path
  end

  def get_gallery
    @photo_gallery = SpudPhotoGallery.find(params[:id])
  end

  def get_albums
    @photo_albums = SpudPhotoAlbum.all
  end

end