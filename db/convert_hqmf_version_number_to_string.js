// converts hqmf_version_numbers from int types to string types.
// needs to be done directly with the database (not through Rails) because Rails
// automatically converts the type if the model type changed (bonnie_bundler:lib/models/measure.rb)
// but this conversion is only reflected in the interface, not the actual data.
// The change here modifies the actual data. This helps ensure that there will be no
// issues using data accessed from this attribute as a string without any conversions.
// type #16 is int32 in mongo
//
// To run: in terminal:
// Open mongo from the commandline
// Switch to the bonnie database
// type load(<absolute path to script>/convert_hqmf_version_number_to_string.js)
// e.g.
// $mongo
// > use bonnie_production
// > load("/Users/edeyoung/Documents/projects/bonnie/git/bonnie/db/convert_hqmf_version_number_to_string.js")
db.draft_measures.find( { 'hqmf_version_number' : { $type: 16 } } ).forEach( function (x) {   
  x.hqmf_version_number = String(x.hqmf_version_number) ; // convert int32 to string
  db.draft_measures.save(x); 
});
