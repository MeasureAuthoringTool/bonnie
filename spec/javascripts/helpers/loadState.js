function loadState(key) {
//  bonnie.measures = $.extend(true, {}, window.bonnieRouterMeasureCache.state[key]['measures'])
//  bonnie.valueSetsByOid = $.extend(true, {}, window.bonnieRouterMeasureCache.state[key]['valueSetsByOid'])
//  bonnie.calculator = $.extend(true, {}, window.bonnieRouterMeasureCache.state[key]['calculator'])
    window.bonnie = $.extend(true, {}, window.bonnieRouterMeasureCache.state[key])
}

function saveState(key) {
//  window.bonnieRouterMeasureCache.state[key]['measures'] = bonnie.measures
//  window.bonnieRouterMeasureCache.state[key]['valueSetsByOid'] = bonnie.valueSetsByOid
//  window.bonnieRouterMeasureCache.state[key]['calculator'] = bonnie.calculator
  window.bonnieRouterMeasureCache.state[key] = window.bonnie
}