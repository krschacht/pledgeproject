class CreateTinyUrls < ActiveRecord::Migration
  def self.up
    create_table :tiny_urls do |t|
      t.string :key
      t.text :url

      t.timestamps
    end
    
    add_index :tiny_urls, :key
  end

  def self.down
    drop_table :tiny_urls
  end
end
