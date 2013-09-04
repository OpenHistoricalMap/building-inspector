namespace :data_import do

	desc "Import a polygon GeoJSON for a sheet file"
	task :ingest_geojson => :environment do
		id = ENV['id']
		bbox = ENV['bbox']
		file = "public/files/#{id}-traced.shp.json"

		if not File.exists?(file)
			puts "Sheet ID #{id} not found."
			return
		end
		
		str = IO.read(file)
		json = JSON.parse(str)
		
		if json["features"] == nil
			puts "Sheet ID #{id} has no features."
			return
		end
		
		# now we can create the sheet and polygons

		#first check if sheet exists
		sheet = Sheet.where(:map_id => id)

		if (sheet.count != 0)
			sheet.destroy_all
		end

		sheet = Sheet.new(:map_id => id, :bbox => bbox, :status => "unprocessed")
		sheet.save

		json["features"].each do |f|
			polygon = Polygon.new()
			polygon[:sheet_id] = sheet.id
			polygon[:status] = "unprocessed"
			polygon[:vectorizer_json] = f.to_json
			polygon[:color] = f['properties']['Color']
			polygon[:geometry] = f['geometry']['coordinates'].to_json
			polygon[:dn] = f['properties']['DN']
			polygon.save
		end
	end

	desc "Import the tutorial GeoJSON sheet file"
	task :ingest_tutorial => :environment do
		id = 0
		bbox = ''
		file = "public/files/tutorial.json"

		if not File.exists?(file)
			puts "Tutorial JSON not found."
			return
		end
		
		str = IO.read(file)
		json = JSON.parse(str)
		
		if json["features"] == nil
			puts "Tutorial sheet has no features."
			return
		end
		
		# now we can create the sheet and polygons

		#first check if sheet exists
		sheet = Sheet.where(:map_id => id)

		if (sheet.count != 0)
			sheet.destroy_all
		end

		sheet = Sheet.new(:map_id => id, :bbox => bbox, :status => "unprocessed")
		sheet.save

		json["features"].each do |f|
			polygon = Polygon.new()
			polygon[:sheet_id] = sheet.id
			polygon[:status] = "unprocessed"
			polygon[:vectorizer_json] = f.to_json
			polygon[:color] = f['properties']['Color']
			polygon[:geometry] = f['geometry']['coordinates'].to_json
			polygon[:dn] = f['properties']['DN']
			polygon.save
		end
	end

end