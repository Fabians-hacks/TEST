@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Survey Base view'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSA_CDS_Survey as select from zsa_survey
association to parent ZR_SAOV as _overview
  on $projection.surveyid = _overview.SurveyID
{
  key question_id as QuestionId,
  text as Text,
  survey_id as surveyid,
  created_by as CreatedBy,
  created_at as CreatedAt,
  last_changed_by as LastChangedBy,
  last_changed_at as LastChangedAt,
  local_last_changed_at as LocalLastChangedAt,
  _overview // Make association public
}
