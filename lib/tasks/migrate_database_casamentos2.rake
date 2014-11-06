task :migrate_database_casamentos2 => :environment do
	ids = []
	i = 0
	Fornecedor.where("id > ? AND id < ?", 0, 3570).each do |f|
		unless ids.include?(f.id)
			f2 = Fornecedor.where("id_bemcasados = ?", f.id_bemcasados)
			if f2.size > 1
				i += 1
				ids_new = f2.collect {|x| x.id }
				ids = ids | ids_new
				puts "#{i}) #{f.id_bemcasados} #{ids_new.to_s}"
			end
		end
	end
	puts ids.size
end

#Removido:
#1) 1702 [16, 2874]
#2) 1718 [28, 517]
#3) 1731 [41, 52]
#4) 1746 [57, 1457]
#5) 1748 [59, 359]
#6) 1756 [67, 266]
#7) 1758 [70, 1181]
#8) 1780 [95, 2913]
#10) 1805 [124, 142]
#11) 1806 [125, 1811]
#12) 1811 [132, 2399]
#13) 1984 [342, 2218]
#14) 2136 [510, 2754]
#16) 2844 [1253, 2541]
#17) 3017 [1429, 1515]
#18) 3227 [1649, 2091]
#19) 3495 [1931, 2155]
#21) 4266 [2781, 3489]
#22) 4409 [2965, 3473]
#Resolvido:
#584 [120, 288]
#755 [685, 1365]
#187 [2618, 2812]