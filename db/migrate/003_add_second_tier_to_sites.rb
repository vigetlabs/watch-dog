class AddSecondTierToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :threshold_tier_two, :integer
    add_column :sites, :email_tier_two, :string
  end

  def self.down
    remove_column :sites, :email_tier_two
    remove_column :sites, :threshold_tier_two
  end
end