CLASS lhc_ZAU_CDS_OV DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zau_cds_ov RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      REQUEST requested_authorizations FOR zau_cds_ov RESULT result.
    METHODS analyze_with_ai FOR MODIFY
      keys FOR ACTION zau_cds_ov~analyze_with_ai.

ENDCLASS.

CLASS lhc_ZAU_CDS_OV IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  IF requested_authorizations-%create = if_abap_behv=>mk-on.
    result-%create = if_abap_behv=>auth-allowed.
  ENDIF.
ENDMETHOD.


  METHOD analyze_with_ai.
  ENDMETHOD.

ENDCLASS.
