class AddReferrals < ActiveRecord::Migration
  def change
  	add_column :users, :referral_token, :string
  	add_column :users, :referrer_id, :integer

  	add_index :users, :referral_token
  end
end
