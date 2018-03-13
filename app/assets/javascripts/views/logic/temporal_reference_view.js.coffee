class Thorax.Views.TemporalReferenceLogic extends Thorax.Views.BonnieView

  template: JST['logic/temporal_reference']
  timing_map:
    'DURING':'During'
    'OVERLAP':'Overlaps'
    'SBS':'Starts Before Start of'
    'SAS':'Starts After Start of'
    'SBE':'Starts Before End'
    'SAE':'Starts After End of'
    'EBS':'Ends Before Start of'
    'EAS':'Ends After Start of'
    'EBE':'Ends Before End'
    'EAE':'Ends After End of'
    'SDU':'Starts During'
    'EDU':'Ends During'
    'ECW':'Ends Concurrent with'
    'SCW':'Starts Concurrent with'
    'ECWS':'Ends Concurrent with Start of'
    'SCWE':'Starts Concurrent with End of'
    'SBCW': 'Starts Before or Concurrent with'
    'SBCWE': 'Starts Before or Concurrent with End'
    'SACW': 'Starts After or Concurrent with'
    'SACWE': 'Starts After or Concurrent with End'
    'SBDU': 'Starts Before or During'
    'EBCW': 'Ends Before or Concurrent with'
    'EBCWS': 'Ends Before or Concurrent with Start'
    'EACW': 'Ends After or Concurrent with'
    'EACWS': 'Ends After or Concurrent with Start'
    'EADU': 'Ends After or During'
    'CONCURRENT':'Concurrent with'

  initialize: ->
    ""

  translate_timing: (code) ->
    @timing_map[code].toLocaleLowerCase()
