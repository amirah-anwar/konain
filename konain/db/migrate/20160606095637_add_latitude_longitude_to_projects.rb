class AddLatitudeLongitudeToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :latitude, :decimal, precision: 16, scale: 13
    add_column :projects, :longitude, :decimal, precision: 16, scale: 13
  end
end
