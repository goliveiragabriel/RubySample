class Photography < Vendor
  has_flags 1 => :foto,
            2 => :filmagem,
            :column => 'photography_details'
end
