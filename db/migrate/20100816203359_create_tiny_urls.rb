class CreateTinyUrls < ActiveRecord::Migration
  def self.up
    drop_table :tiny_urls

    create_table :tiny_urls do |t|
      t.string :key
      t.text :url

      t.timestamps
    end    
  end

  def self.down
    drop_table :tiny_urls
  end
end
