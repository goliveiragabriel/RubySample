class Proposal < ActiveRecord::Base  
  belongs_to :vendor
  mount_uploader :document, ProposalUploader

  attr_accessible :date, :description, :document, :quotation_id, :validity, :vendor_id, :vendor_name, :vendor_email
  attr_accessor :vendor_name, :vendor_email

  validates_presence_of :vendor_name, :document, :vendor_email

  def size_to_kb
  	(self.document.size / 1024 ).round(3)
  end

end
