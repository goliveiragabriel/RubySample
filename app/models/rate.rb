class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true
  
  attr_accessible :rate, :dimension
  validates_numericality_of :stars, :minimum => 1

  def destroy
    dim = dimension
    vendor = rateable
    super
    vendor.update_cached_average(dim)
  end
end
