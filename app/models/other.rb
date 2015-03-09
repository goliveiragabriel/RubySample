class Other < Vendor
  has_flags 1 => :carros,
            2 => :tendas,
            :column => 'other_details'
end