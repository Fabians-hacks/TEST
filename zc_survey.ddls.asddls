@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_Survey as projection on ZSA_CDS_Survey

{
  key QuestionId,
  Text,
  surveyid,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  /* Associations */
  _overview
  
}
