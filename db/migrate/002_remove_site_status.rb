class RemoveSiteStatus < ActiveRecord::Migration
  def self.up
    remove_column :sites, :status_record
  end

  def self.down
    add_column :sites, :status_record, :string
  end
end
