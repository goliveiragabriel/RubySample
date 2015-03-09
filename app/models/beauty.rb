class Beauty < Vendor
  has_flags 1 => :feminino,
            2 => :masculino,
            :column => 'beauty_details'
end
