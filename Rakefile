task :default do
  sh "ruby shp2ndjson.rb"
  sh "../tippecanoe/tippecanoe -f -o chome.mbtiles --read-parallel --layer=chome --maximum-zoom=12 --grid-low-zooms chome.ndjson"
  sh "ruby fan-out.rb"
end
