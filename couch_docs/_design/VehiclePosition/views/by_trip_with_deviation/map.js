function(doc) {
  if ((doc['type'] == 'VehiclePosition') && (doc['predicted_deviation'] != 63)) {
    emit(doc['_id'], 1);
  }
}
