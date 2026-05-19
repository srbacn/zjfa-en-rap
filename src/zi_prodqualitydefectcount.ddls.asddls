@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Defect Count per QM Notification'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #TRANSACTIONAL
}
define view entity ZI_ProdQualityDefectCount
  as select from qmfe as DefectItem
  group by DefectItem.qmnum
{
  key DefectItem.qmnum    as QMNotification,
      count( * )          as DefectCount
}
