class Thorax.Views.TemporalReferenceLogic extends Thorax.Views.BonnieView

  template: JST['logic/temporal_reference']
  timing_map:
    'DURING':'During'
    'SBS':'Starts Before Start of'
    'SAS':'Starts After Start of'
    'SBE':'Starts Before or During'
    'SAE':'Starts After End of'
    'EBS':'Ends Before Start of'
    'EAS':'Ends After Start of'
    'EBE':'Ends Before or During'
    'EAE':'Ends After End of'
    'SDU':'Starts During'
    'EDU':'Ends During'
    'ECW':'Ends Concurrent with'
    'ECWS':'Ends Concurrent with Start of'
    'SCW':'Starts Concurrent with'
    'SCWE':'Starts Concurrent with End of'
    'CONCURRENT':'Concurrent with'

  initialize: ->
    ""

  translate_timing: (code) ->
    @timing_map[code].toLocaleLowerCase()
