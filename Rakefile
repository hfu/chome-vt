task :default do
  sh "ruby shp2ndjson.rb"
  sh "../tippecanoe/tippecanoe -f -o chome.mbtiles --read-parallel --layer=chome --maximum-zoom=12 chome.ndjson"
  sh "ruby fan-out.rb"
end
