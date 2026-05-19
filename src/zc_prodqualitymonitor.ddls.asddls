@EndUserText.label: 'Production Quality Monitor - Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true

define root view entity ZC_ProdQualityMonitor
  provider contract transactional_query
  as projection on ZI_ProdQualityMonitor
{
  key ProductionOrder,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      OrderType,
      @Search.defaultSearchElement: true
      Plant,
      @Search.defaultSearchElement: true
      @ObjectModel.text.element: ['MaterialText']
      Material,
      BasicStartDate,
      BasicFinishDate,
      TotalOrderQty,
      ConfirmedScrapQty,
      BaseUnit,
      ScrapRatePct,
      OrderCreationDate,
      CreatedBy,

      /* Virtual element for material description - exposed via value help */
      cast( '' as abap.char(40) ) as MaterialText,

      /* Navigation to Inspection Lots */
      _Inspections : redirected to composition child ZC_ProdQualityInspection
}
