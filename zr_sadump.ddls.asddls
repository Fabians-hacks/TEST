@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZSADUMP'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_SADUMP
  as select from zsa_dump
{
  key id as ID,
  filename as Filename,
  mimetype as Mimetype,
  @Semantics.largeObject: {
        mimeType: 'Mimetype',
        fileName: 'Filename',
        acceptableMimeTypes: ['*/*'],
        contentDispositionPreference: #ATTACHMENT
      }
  attachment as Attachment,
  created_by as CreatedBy,
  created_at as CreatedAt,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged,
  is_cleaned as IsCleaned
}
