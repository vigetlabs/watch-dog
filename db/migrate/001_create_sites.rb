class CreateSites < ActiveRecord::Migration
  def self.up
    create_table :sites do |t|
      t.string  :name
      t.string  :url
      t.text    :match_text
      t.integer :threshold
      t.string  :email
      t.string  :status_record

      t.timestamps
    end
  end

  def self.down
    drop_table :sites
  end
end
