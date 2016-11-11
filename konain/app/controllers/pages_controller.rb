class PagesController < ApplicationController

  before_action :set_page, only: [:show]

  load_and_authorize_resource only: [:show]

  def show
  end

  private

  def set_page
    @page = Page.find_by_permalink params[:permalink]
    return redirect_to :root, flash: { error: "Page not found" } if @page.blank?
  end

end
