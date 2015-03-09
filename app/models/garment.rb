class Garment < Vendor
  has_flags 1 => :noiva,
            2 => :noivo,
            3 => :madrinhas,
            4 => :aluguel,
            :column => 'dress_details'
end
