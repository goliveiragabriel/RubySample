class AddStatusToQuotations < ActiveRecord::Migration
  def change
    add_column :quotations, :status, :string, { :default => 'Aguardando'}
    add_column :quotations, :sent_at, :date
    add_column :quotations, :email, :string, { :default => "", :null => false }
  end
end
