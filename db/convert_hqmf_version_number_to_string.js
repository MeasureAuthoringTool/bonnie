db.draft_measures.find( { 'hqmf_version_number' : { $type: 16 } } ).forEach( function (x) {   
  x.hqmf_version_number = String(x.hqmf_version_number) ; // convert int32 to string
  db.draft_measures.save(x); 
});