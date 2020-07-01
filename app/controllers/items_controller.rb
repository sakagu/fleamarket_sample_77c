class ItemsController < ApplicationController

  before_action :set_item, only: [:confirm, :destroy, :show]
  before_action :set_category, only: [:index, :new, :show]
  before_action :set_category_link, only: [:show]

  def index
    @items = Item.all.order("created_at DESC").limit(40)
  end

  def new
    @item = Item.new
    @item.images.new
    @category_parent_array = ["---"]
  end

  def get_category_children
    @category_children = Category.find(params[:parent_id]).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find(params[:child_id]).children
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      @item.images.new
      render :new
    end
  end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path
    else
      @item.images
      render :edit
    end
  end

  def show
    @items = Item.all
    @user_items = Item.where(customer_id: nil, user: @item.user).limit(5)
  end

  def destroy
    if @item.destroy
      redirect_to root_path
    else
      flash[:notice] = "削除に失敗しました"
    end
  end

  def confirm
    if @item.user_id != current_user.id
    redirect_to root_path
    end
  end

  def search
    return nil if params[:keyword] == ""
    @items = Item.search(params[:keyword])
    respond_to do |format|
      format.html
      format.json
    end
  end

  private

  def item_params
    params.require(:item).permit(:image, :item_name,:detail,:condition,:delivery_fee,:shipping_area,:delivery_time,:price,:brand_id,:category_id,images_attributes:  [:src, :_destroy, :id]).merge(user_id: current_user.id)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def set_category_link
    @category = Category.find(params[:id])
    if @category.has_children?
      @category_links = @category.children
    else
      @category_links = @category.siblings
    end
  end

end



