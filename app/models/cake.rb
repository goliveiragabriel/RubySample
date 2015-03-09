class Cake < Vendor
  has_flags 1 => :bolo,
            2 => :doces,
            :column => 'cake_details'
end
