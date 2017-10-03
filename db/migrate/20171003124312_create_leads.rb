class CreateLeads < ActiveRecord::Migration[5.1]
  def change
    create_table :leads do |t|
      t.string :name
      t.string :company
      t.string :phone
      t.string :source

      t.timestamps
    end
  end
end
