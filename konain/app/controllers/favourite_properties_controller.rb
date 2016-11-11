class FavouritePropertiesController < ApplicationController

  before_action :set_property

  def create
    @favourited = Favourite.create(favourited: @property, user: current_user)
    set_user_favourities
  end

  def destroy
    @user_favourited = params[:user_favourited_active]
    @category = params[:category]
    @unfavourited = Favourite.where(favourited_id: @property.id, user_id: current_user.id).first
    @unfavourited.destroy if @unfavourited.present?
    set_user_favourities
  end

  private

    def set_property
      @property = Property.find(params[:id])
      return redirect_to :root, flash: { error: "Property was not found" } if @property.blank?
    end

end
