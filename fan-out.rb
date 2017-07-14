require 'sequel'
require 'zlib'
require 'stringio'
require 'json'
require 'fileutils'

def fan_out(mbtiles, dirname)
  db = Sequel.sqlite(mbtiles)
  md = {}
  db[:metadata].all.each {|pair|
    key = pair[:name]
    value = pair[:value]
    value = value.to_i if %w{minzoom maxzoom}.include?(key)
    md[key] = value
  }
  File.write("#{dirname}/metadata.json", JSON::dump(md))
  count = 0
  db[:tiles].each {|r|
    z = r[:zoom_level]
    x = r[:tile_column]
    y = (1 << r[:zoom_level]) - r[:tile_row] - 1
    data = r[:tile_data]
    dir = "#{dirname}/#{z}/#{x}"
    FileUtils::mkdir_p(dir) unless File.directory?(dir)
    File.write("#{dir}/#{y}.mvt", Zlib::GzipReader.new(StringIO.new(data)).read)
    count += 1
  }
  print "wrote #{count} tiles.\n"
end

if $0 == __FILE__
  fan_out(
    './chome.mbtiles',
    '.'
  )
end
