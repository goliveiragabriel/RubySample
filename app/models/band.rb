class Band < Vendor
  has_flags 1 => :dj,
            2 => :banda,
            3 => :coral,
            4 => :aluguel,
            5 => :orquestra,
            :column => 'band_details'

	def self.dj_label
		"DJ"
	end

	def self.banda_label
		"Banda"
	end

	def self.coral_label
		"Coral & Orchestra"
	end

	def self.aluguel_label
		"Aluguel de Equipamentos"
	end
end