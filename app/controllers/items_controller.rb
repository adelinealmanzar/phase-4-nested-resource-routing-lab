class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_res
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_res

  def index
    if params[:user_id]
      user = User.find(params[:user_id])
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item, status: :ok
  end

  def create
    user = User.find(params[:user_id])
    new_item = user.items.create(item_params)
    render json: new_item, status: :created
  end

  private

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_unprocessable_entity_res(invalid)
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end
  
  def render_not_found_res
    render json: { errors: "Record not found" }, status: :not_found
  end

end
