@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Production Quality - Inspection Lots Interface View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #X,
  sizeCategory: #M,
  dataClass: #MIXED
}
define view entity ZI_ProdQualityInspection
  as select from qals as InspLot
    left outer join qave                    as UsageDecision
      on  UsageDecision.prueflos = InspLot.prueflos
    left outer join ZI_ProdQualityDefectCount as DefCnt
      on  DefCnt.QMNotification   = InspLot.qmnum

{
  key InspLot.prueflos                             as InspectionLot,
      InspLot.aufnr                                as ProductionOrder,
      InspLot.matnr                                as Material,
      InspLot.werks                                as Plant,
      InspLot.art                                  as InspLotOrigin,
      @Semantics.quantity.unitOfMeasure: 'SampleUoM'
      InspLot.enstmg                               as SampleSize,
      @Semantics.unitOfMeasure: true
      InspLot.entgm                                as SampleUoM,
      InspLot.qmnum                                as QMNotification,
      @Semantics.calendar.date: true
      InspLot.erdat                                as InspLotCreationDate,
      InspLot.lvorm                                as DeletionFlag,

      /* Usage Decision */
      UsageDecision.beurteilung                    as UsageDecisionCode,
      UsageDecision.usnam                          as UDCreatedBy,
      @Semantics.calendar.date: true
      UsageDecision.erdat                          as UDCreationDate,

      /* Defects */
      coalesce( DefCnt.DefectCount, 0 )            as DefectCount
}
