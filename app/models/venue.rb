# encoding: utf-8
class Venue < Vendor
  has_flags 1 => :cerimonia,
            2 => :ar_livre,
            3 => :hotel,
            4 => :restaurante,
            5 => :praia,
            6 => :campo,
            7 => :salao,
            :column => 'venue_details'

	def self.cerimonia_label
		"Cerimônia no local"
	end

	def self.ar_livre_label
		"Espaço ao ar livre"
	end

	def self.hotel_label
		"Hotel"
	end

	def self.restaurante_label
		"Restaurante"
	end

	def self.praia_label
		"Praia"
	end

	def self.campo_label
		"Campo"
	end

	def self.capacity_label
		"Capacidade"
	end

end