Thorax.Model.extend
  name: 'measure'
  idAttribute: '_id'
  subId: -> 'abcdefghijklmnopqrstuvwxyz'.charAt(@get('population'))
