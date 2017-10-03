class AddMobileToLeads < ActiveRecord::Migration[5.1]
  def change
    add_column :leads, :mobile, :string
  end
end
