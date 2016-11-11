class ProjectsController < ApplicationController

  before_action :authenticate_admin_user!, only: [:edit, :new, :create, :update, :destroy]
  before_action :set_project, only: [:show, :edit, :update, :destroy, :fetch_sub_projects]
  before_action :set_featured_properties, only: [:index]

  load_and_authorize_resource only: [:index, :show, :new, :edit, :update, :create, :destroy]

  def index
    @projects = Project.perform_search(params)
    gon.array_of_projects_fields = Project.project_fields_array(@projects)
  end

  def show
    gon.project_location = {"lat" => @project.latitude, "lng" => @project.longitude}
    @attachments = @project.attachments
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params)
    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, flash: { success: 'Project was successfully added.' } }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, flash: { success: 'Project was successfully updated' } }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, flash: { error: 'Project was not updated.' } }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @project.destroy
        format.html { redirect_to projects_path, flash: { success: 'Project was successfully destroyed' } }
        format.json { head :no_content }
      else
        format.html { redirect_to :back, flash: { error: 'Project was not destroyed' } }
      end
    end
  end

  def fetch_project
    @fetch_type = params[:fetch_type]
    @projects = Project.projects_by_city(params[:city]).collect{ |project| [project.title, project.id] }
    @sub_projects = SubProject.projects_by_city(params[:city]).collect{ |project| [project.title, project.id] }
  end

  def fetch_sub_projects
    @fetch_type = params[:fetch_type] if params[:fetch_type].present?
    @project = Project.find_by_id(params[:id])
    @sub_projects = @project.sub_projects.ordered.pluck(:title, :id) if @project.sub_projects.exists?
    respond_to do |format|
      format.js { render 'fetch_sub_projects' }
    end
  end

  private

    def set_project
      @project = Project.find_by_id(params[:id])
      return redirect_to :root, flash: { error: "Project was not found." } if @project.blank?
    end

    def project_params
      params.require(:project).permit(:title, :description, :location, :city,
                    :country, :latitude, :longitude, attachments_attributes: [:id, :image, :_destroy])
    end
end
