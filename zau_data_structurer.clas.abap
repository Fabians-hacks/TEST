CLASS zau_data_structurer DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  METHODS structurer IMPORTING lv_data TYPE xstring lv_checkneeded TYPE abap_boolean.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zau_data_structurer IMPLEMENTATION.
METHOD structurer.
DATA: lt_parts_fill TYPE TABLE FOR CREATE ZR_AUSURVEY.
DATA lv_data_s TYPE string.

DATA(lo_conv) = cl_abap_conv_in_ce=>create(
  input       = lv_data
  encoding    = 'UTF-8'
  replacement = '?' ).

lo_conv->read( IMPORTING data = lv_data_s ).

IF lv_checkneeded = ''.

DATA: lv_result TYPE string.

    TRY.

        DATA: lv_prompt_1 TYPE string,
      lv_prompt_2 TYPE string,
      lv_prompt_3 TYPE string,
      lv_prompt_4 TYPE string,
      lv_prompt_5 TYPE string,
      lv_prompt_6 TYPE string,
      lv_full_prompt TYPE string.

lv_prompt_1 = 'You are a data analyst specialized in survey data processing. ' &&
              'Your task is to identify and extract free-text response columns from CSV survey data. ' &&
              'Input Format: You will receive a semicolon-separated CSV string containing survey data. ' &&
              'Each column represents a survey question, and rows contain participant responses.'.

lv_prompt_2 = 'Task: 1. Analyze each column to determine if it contains free-text responses ' &&
              '(open-ended answers) or structured data (multiple choice, ratings, yes/no, etc.). ' &&
              '2. Extract only the columns identified as free-text responses. ' &&
              '3. Format each free-text column as a separate table.'.

lv_prompt_3 = 'Output Format: Return a plain text response with the following structure: ' &&
              '- Each free-text column should be presented as its own table. ' &&
              '- Use § as the delimiter between different column tables. ' &&
              '- Preserve the original semicolon separators within each column data.'.

lv_prompt_4 = '- Include the column header as the first row of each table. ' &&
              '- Maintain the original row order. ' &&
              'Example Output Structure: Column_Name_1<newline>response_1<newline>response_2<newline>response_3<newline>§<newline>' &&
              'Column_Name_2<newline>response_1<newline>response_2<newline>response_3'.

lv_prompt_5 = 'Detection Criteria for Free-Text Columns: Consider a column as free-text if responses are: ' &&
              '- Varying in length and content. ' &&
              '- Written in complete sentences or phrases. ' &&
              '- Unique and not from a predefined set of options.'.

lv_prompt_6 = '- Descriptive or narrative in nature. ' &&
              'Do not include columns with structured data such as numeric ratings, single-word answers, ' &&
              'or responses from a limited set of predefined options.'.

" Concatenate all parts
lv_full_prompt = lv_prompt_1 && | | &&
                 lv_prompt_2 && | | &&
                 lv_prompt_3 && | | &&
                 lv_prompt_4 && | | &&
                 lv_prompt_5 && | | &&
                 lv_prompt_6.




        " API-Instanz mit deinem Szenario erstellen
        TRY.
            data(lo_ai_api) = cl_aic_islm_compl_api_factory=>get( )->create_instance( 'ZAU_ISLM' ).
          CATCH cx_aic_api_factory.
            "handle exception
        ENDTRY.




        DATA(message) = lo_ai_api->create_message_container(  ).

        message->set_system_role( lv_full_prompt ).
        message->add_user_message( lv_data_s ).

        try.
            data(lo_result) = lo_ai_api->execute_for_messages( message ).
          catch cx_aic_completion_api.
            "handle exception
        endtry.


        " Ergebnis abrufen
        lv_result = lo_result->get_completion( ).

        DATA: lt_parts TYPE Table of string.
        split lv_result AT '§' INTO TABLE lt_parts.
        ENDTRY.
        ELSE.
DATA: lt_lines TYPE stringtab,
      lt_tmp   TYPE stringtab,
    "  lt_parts TYPE TABLE OF string,
      lv_cols  TYPE i,
      lv_idx   TYPE i.

SPLIT lv_data_s AT cl_abap_char_utilities=>newline INTO TABLE lt_lines.

" Leerzeilen entfernen
DELETE lt_lines WHERE table_line IS INITIAL.

" Spaltenanzahl aus erster Zeile (= Qualtrics Header)
SPLIT lt_lines[ 1 ] AT ',' INTO TABLE lt_tmp.
DESCRIBE TABLE lt_tmp LINES lv_cols.

" lt_parts mit exakt lv_cols leeren Strings vorbelegen
DO lv_cols TIMES.
  APPEND '' TO lt_parts.
ENDDO.

LOOP AT lt_lines INTO DATA(lv_line).
  CLEAR lt_tmp.
  SPLIT lv_line AT ',' INTO TABLE lt_tmp.

  LOOP AT lt_tmp INTO DATA(lv_val).
    lv_idx = sy-tabix.
    CHECK lv_idx <= lv_cols.  " Schutz gegen Über-Index
    IF lt_parts[ lv_idx ] IS INITIAL.
      lt_parts[ lv_idx ] = lv_val.
    ELSE.
      lt_parts[ lv_idx ] = lt_parts[ lv_idx ] && ',' && lv_val.
    ENDIF.
  ENDLOOP.
ENDLOOP.




        ENDIF.


        LOOP AT lt_parts INTO DATA(i).
        APPEND VALUE #(
    %cid = |cid_{ sy-tabix }|
    text = i  " Map string to your entity field
  ) TO lt_parts_fill.
        ENDLOOP.


        ZBP_R_ausurvey=>writer( lt_parts_fill ).


        ZAU_DATA_ANALYSIS=>analyze(  ).




ENDMETHOD.
ENDCLASS.
