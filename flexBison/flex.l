%option noyywrap
%{
    #include "Bison.tab.h"
    #include<stdio.h>
    #include<ctype.h>
    #define YY_DECL int yylex()
    void yyerror_at_line(int line, const char* msg);
%}
%s COMMENT
%s WIDTH
%s HEIGHT
%s ANDROID
%s PADDING

START_L "<LinearLayout"
END_L "</LinearLayout>"
R_START "<RelativeLayout"
END_R "</RelativeLayout>"
T_START "<TextView"
IMAG_START "<ImageView"
BUT_START "<Button"
RADIOG_START "<RadioGroup"
RADIOG_END "</RadioGroup>"
RADIOB_START "<RadioButton"
B_START "<ProgressBar"
END11 ">"
END22 "/>"

%%
<INITIAL>{START_L} {yylval.strval=strdup(yytext); return LINEAR_START;}
<INITIAL>{END_L} {yylval.strval=strdup(yytext); return END_LINEAR;}
<INITIAL>{R_START} {yylval.strval=strdup(yytext); return RELATIVE_START;}
<INITIAL>{END_R} {yylval.strval=strdup(yytext); return END_RELATIVE;}
<INITIAL>{T_START} {yylval.strval=strdup(yytext); return TEXTVIEW_START;}
<INITIAL>{IMAG_START} {yylval.strval=strdup(yytext); return IMAGEVIEW_START;}
<INITIAL>{BUT_START} {yylval.strval=strdup(yytext); return BUTTON_START;}
<INITIAL>{RADIOG_START} {yylval.strval=strdup(yytext); return RADIOGROUP_START;}
<INITIAL>{RADIOG_END} {yylval.strval=strdup(yytext); return RADIOGROUP_END;}
<INITIAL>{RADIOB_START} {yylval.strval=strdup(yytext); return RADIOBUTTON_START;}
<INITIAL>{B_START} {yylval.strval=strdup(yytext); return BAR_START;}

<INITIAL>android: {BEGIN(ANDROID);}

<ANDROID>id=\"([^\n\"]+)\"  {
    char *tmp=strdup(yytext+strlen("id=\""));
    tmp[strlen(tmp) - 1] = '\0';
    yylval.strval=strdup(tmp);
    BEGIN(INITIAL); return ANDROID_ID;}
<ANDROID>layout_width=\" { yylval.strval=strdup(yytext); BEGIN(WIDTH);}
<ANDROID>layout_height=\" { yylval.strval=strdup(yytext); BEGIN(HEIGHT);}
<ANDROID>text=\"[^\n\"]+\" {yylval.strval=strdup(yytext); BEGIN(INITIAL); return ANDROID_TEXT;}
<ANDROID>textColor=\"[^\n\"]+\" {yylval.strval=strdup(yytext); BEGIN(INITIAL); return ANDROID_TEXT_COLOR;}
<ANDROID>progress=\"[0-9]+\" {char *tmp=strdup(yytext+strlen("progress:\"")); 
                              tmp[strlen(tmp) - 1] = '\0';
                              yylval.strval=strdup(tmp);
                              BEGIN(INITIAL);return ANDROID_PROGRESS;}

<ANDROID>max=\"[0-9]+\" {
                            char *tmp=strdup(yytext+strlen("max=\"")); 
                            tmp[strlen(tmp) - 1] = '\0';
                           yylval.strval=strdup(tmp);
                            BEGIN(INITIAL); return ANDROID_MAX;}


<ANDROID>checkedButton=\"[^\n\"]+\" {char *tmp=strdup(yytext+strlen("checkedButton=\""));
                                    tmp[strlen(tmp) - 1] = '\0';
                                    yylval.strval=strdup(tmp); BEGIN(INITIAL);
                                    return ANDROID_CHECKBUTTON;} 

<ANDROID>orientation=\"[^\n\"]+\" {BEGIN(INITIAL); return ANDROID_ORIENTATION;}
<ANDROID>padding=\" {BEGIN(PADDING); }
<ANDROID>src=\"[^\n\"]+\" {BEGIN(INITIAL); return ANDROID_SRC;}

<ANDROID>count=\"[0-9]+\" { char *tmp=strdup(yytext+strlen("count=\"")); 
                            tmp[strlen(tmp) - 1] = '\0';
                            yylval.strval=strdup(tmp);
                            BEGIN(INITIAL); return ANDROID_COUNT;}

<ANDROID>[^\"]+ {yylval.strval=strdup(yytext); return UNKNOWN;}

<WIDTH>(wrap_content|match_parent|[0-9]+)\" {yylval.strval=strdup(yytext); BEGIN(INITIAL); return ANDROID_LAYOUT_WIDTH; }
<WIDTH>[^\"]+ {yylval.strval=strdup(yytext);return ANDROID_LAYOUT_ERROR;}

<HEIGHT>(wrap_content|match_parent|[0-9]+)\" {yylval.strval=strdup(yytext); BEGIN(INITIAL); return ANDROID_LAYOUT_HEIGHT; }
<HEIGHT>. {yylval.strval=strdup(yytext); return ANDROID_LAYOUT_ERROR;}

<PADDING>([0-9]+)\" {yylval.strval=strdup(yytext); BEGIN(INITIAL); return ANDROID_PADDING; }
<PADDING>[^\"]+ {yylval.strval=strdup(yytext); return PADDING_ERROR;}

"<!--" {BEGIN(COMMENT);}
<COMMENT>"-->" {BEGIN(INITIAL);}
<COMMENT>--[^>] {yyerror_at_line(yylineno,"Encountered \"--\" inside the comment");}
<COMMENT>-{0,1}[>] {yyerror_at_line(yylineno,"incorrect comment form");}
<COMMENT>. {/*ignoring the comment*/} 
<INITIAL>{END11} {yylval.strval=strdup(yytext); return END1;}
<INITIAL>{END22} {yylval.strval=strdup(yytext); return END2;}
[\t\f\r" "]+ {}
[\n] {yylineno++;}
. {return UNKNOWN;}

%%

void yyerror_at_line(int line, const char* msg) {
    fprintf(stderr, "Error on line %d: %s\n", line, msg);
    exit(1);
}
