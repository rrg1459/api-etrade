class CreateStrategies < ActiveRecord::Migration[7.2]
  def change
    create_table :strategies do |t|
      t.string :name
      t.string :description
      t.string :time_frame
      t.string :analysis_type
      t.string :ideal_for

      t.timestamps
    end
  end
end
