@EndUserText.label: 'Production Quality - Inspection Lots (Projection)'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZC_ProdQualityInspection
  as projection on ZI_ProdQualityInspection
{
  key InspectionLot,
      ProductionOrder,
      Material,
      Plant,
      InspLotOrigin,
      SampleSize,
      SampleUoM,
      QMNotification,
      InspLotCreationDate,
      DeletionFlag,
      UsageDecisionCode,
      UDCreatedBy,
      UDCreationDate,
      DefectCount
}
