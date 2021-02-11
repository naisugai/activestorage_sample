class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update upload_image destroy ]

  # GET /items or /items.json
  def index
    @items = Item.all
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    @item.images.detach #一旦、すべてのimageの紐つけを解除
    if @item.update(item_params)
      redirect_to @item, notice: 'Item was successfully updated.'
    else
      render :edit
    end
  end
  
  def upload_image
    @image_blob = create_blob(params[:image])
    respond_to do |format|
      format.json { @image_blob.id }
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :description).merge(images: uploaded_images)
    end

    def uploaded_images
      params[:item][:images].map{|id| ActiveStorage::Blob.find(id)} if params[:item][:images]
    end

    def create_blob(uploading_file)
      ActiveStorage::Blob.create_after_upload! \
        io: uploading_file.open,
        filename: uploading_file.original_filename,
        content_type: uploading_file.content_type
    end
end
