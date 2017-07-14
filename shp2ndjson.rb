require 'georuby'
require 'geo_ruby/shp'
require 'geo_ruby/geojson'
require 'json'
include GeoRuby::Shp4r

def properties(record)
  h = record.attributes
  h.keys.each{|k|
    if h[k].class == String
      h[k] = h[k].encode('utf-8', 'cp932')
    end
  }
  h
end

def process(shpfile)
  ShpFile.open(shpfile) {|shp|
    keys = shp.fields
    shp.each {|f|
      feature = {
        :type => 'Feature',
        :tippecanoe => {},
        :geometry => JSON::parse(f.geometry.to_json),
        :properties => properties(f.data)
      }
      yield feature
    }
  }
end

w = File.open('chome.ndjson', 'w')
count = 0
Dir.glob("../jp_chome_boundary/Shapefile/*.shp") {|shpfile|
  process(shpfile) {|line|
    count += 1
    w.print JSON::dump(line), "\n"
    print "*" if count % 100 == 0
  }
}
w.close
