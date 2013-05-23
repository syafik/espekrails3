# -*- encoding : utf-8 -*-
class SignaturesController < ApplicationController

  layout "standard-layout"

  def index
    list
    render :action => 'list'
  end

  def list
    #@signature_pages, @signatures = paginate :signatures, :per_page => 10
    @signatures = Signature.paginate(:page => params[:page], :per_page => 10)
  end

  def list_popup
	list
  end

  def show
    @signature = Signature.find(params[:signature_id])
  end

  def show_popup
	show
  end

  def new
    @signature = Signature.new
  end

  def new_popup
    new
  end

  def create
    @signature = Signature.new(params[:signature])
	if params[:signature][:filename] !=""
	@signature.filename = params[:signature][:filename].original_filename

	if RUBY_PLATFORM == "i386-mswin32"
		@file_to_save = "public/signatures/#{params[:signature][:filename].original_filename}"
	else
		@file_to_save = "/aplikasi/www/instun/public/signatures/#{params[:signature][:filename].original_filename}"
	end
	end

	if @signature.save
	if params[:signature][:filename] !=""
	  File.open(@file_to_save, "wb") { |f| f.write(params[:signature][:filename].read) }
	end
      flash[:notice] = 'signature was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def create_popup
    @signature = Signature.new(params[:signature])
	@signature.filename = params[:file2upload].original_filename

	if RUBY_PLATFORM == "i386-mswin32"
		@file_to_save = "public/signatures/#{@signature.filename}"
	else
		@file_to_save = "public/signatures/#{@signature.filename}"
	end

	if @signature.save
	  File.open(@file_to_save, "wb") { |f| f.write(params[:file2upload].read) }
      flash[:notice] = 'signature was successfully created.'
      redirect_to signature_show_popup_path(@signature)
    else
      render :action => 'new_popup'
    end
  end

  def edit
    @signature = Signature.where("id = ?", params[:signature_id]).first
  end

  def edit_popup
    edit
  end

  def update
    @signature = Signature.find(params[:id])
    if @signature.update_attributes(params[:signature])
      flash[:notice] = 'signature was successfully updated.'
      redirect_to :action => 'list', :id => @signature
    else
      render :action => 'edit'
    end
  end

  def update_popup

    @signature = Signature.find(params[:signature_id])
	if params[:file2upload] and params[:file2upload].original_filename!=""
		params[:signature][:filename] = params[:file2upload].original_filename
	end

    if @signature.update_attributes(params[:signature])
		if params[:file2upload] and params[:file2upload].original_filename!=""
			if RUBY_PLATFORM == "i386-mswin32"
				@file_to_save = "public/signatures/#{@signature.filename}"
			else
				@file_to_save = "public/signatures/#{@signature.filename}"
			end

			File.open(@file_to_save, "wb") { |f| f.write(params[:file2upload].read) }
		end

	flash[:notice] = 'signature was successfully updated.'
	redirect_to signature_show_popup_path(@signature)

    else
      render :action => 'edit_popup'
    end
  end

  def destroy
    Signature.find(params[:id] || params[:signature_id]).destroy
    redirect_to list_popup_signatures_path
  end
end
