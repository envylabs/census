class CreateCensusTables < ActiveRecord::Migration
  def self.up
    create_table :data_groups do |t|
      t.string  :name
      t.integer :position
      t.timestamps
    end

    create_table :questions do |t|
      t.integer :data_group_id
      t.string  :data_type
      t.string  :prompt
      t.boolean :multiple
      t.boolean :other
      t.integer :position
      t.timestamps
    end
    
    add_index :questions, :data_group_id
    
    create_table :choices do |t|
      t.integer :question_id
      t.string  :value
      t.integer :position
      t.timestamps
    end
    
    add_index :choices, :question_id
    
    create_table :answers do |t|
      t.integer :question_id
      t.integer :user_id
      t.string  :data
    end
    
    add_index :answers, :question_id
    add_index :answers, :user_id
    
  end

  def self.down
    remove_index :answers, :question_id
    remove_index :answers, :user_id
    drop_table :answers
    
    remove_index :choices, :question_id
    drop_table :choices
    
    remove_index :questions, :data_group_id
    drop_table :questions
    
    drop_table :data_groups
  end
end
