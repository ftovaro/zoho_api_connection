class AddZohoIdToLeads < ActiveRecord::Migration[5.1]
  def change
    add_column :leads, :zoho_id, :string
  end
end
