@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Quality Monitor - Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #X,
  sizeCategory: #M,
  dataClass: #MIXED
}
define root view entity ZI_ProdQualityMonitor
  as select from aufk as ProdOrder
    inner join   afko    as OrderHeader  on  OrderHeader.aufnr = ProdOrder.aufnr
    left outer join afpo as OrderItem    on  OrderItem.aufnr   = ProdOrder.aufnr
                                         and OrderItem.posnr   = '0001'

  association [0..*] to ZI_ProdQualityInspection as _Inspections
    on _Inspections.ProductionOrder = $projection.ProductionOrder

{
  key ProdOrder.aufnr                                        as ProductionOrder,
      ProdOrder.auart                                        as OrderType,
      ProdOrder.werks                                        as Plant,
      OrderItem.matnr                                        as Material,
      @Semantics.calendar.date: true
      OrderHeader.gstri                                      as BasicStartDate,
      @Semantics.calendar.date: true
      OrderHeader.gltri                                      as BasicFinishDate,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      OrderHeader.gamng                                      as TotalOrderQty,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      OrderHeader.gmnga                                      as ConfirmedScrapQty,
      @Semantics.unitOfMeasure: true
      OrderHeader.gmein                                      as BaseUnit,
      case
        when OrderHeader.gamng > 0
        then cast(
               cast( OrderHeader.gmnga as abap.dec(13,3) )
               / cast( OrderHeader.gamng as abap.dec(13,3) ) * 100
             as abap.dec(5,2) )
        else cast( 0 as abap.dec(5,2) )
      end                                                    as ScrapRatePct,
      @Semantics.calendar.date: true
      ProdOrder.erdat                                        as OrderCreationDate,
      ProdOrder.ernam                                        as CreatedBy,

      /* Associations */
      _Inspections
}
where ProdOrder.auart  in ( 'PP01', 'PP10', 'ZP01', 'ZP10' )
