var temp: Image "OpenLandMap Long-term Land Surface Temperature daytime monthly median"
var muni: Table "https://code.earthengine.google.com/?asset=users/markcherriemc/Com01012019_WGS84"

// visualise
var band_viz = {
  bands:['dec'],
  min: 11989,
  max: 16700,
  palette: ['black', 'blue', 'purple', 'cyan', 'green', 'yellow', 'red']
};


/////// select each band

var bandSubset = temp.select(['dec'], ['dec'])

bandSubset = bandSubset.clip(muni)

Map.addLayer(bandSubset, band_viz);


///////// get median for each municipality

var muni_dec = bandSubset.reduceRegions({
  collection: muni,
  reducer: ee.Reducer.median(),
  scale: 1000 // the resolution of the dataset
});


////////////////// EXPORT ///////////////////////////////////

// drop .geo column
var polyOut = muni_dec.select(['.*'],null,false);


// An example for how to export
Export.table.toDrive({
  collection: polyOut,
  description: 'temp_dec_italymuni',
  folder: 'GEE_output',
  fileFormat: 'CSV'
});   




