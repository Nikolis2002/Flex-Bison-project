%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    extern int yylex();
    extern int yyparse();
    extern FILE* yyin;
    extern int yylineno;
    void yyerror(const char* s);
    void add_id(char*** arr, int* size, const char* value);
    void print(char **arr,int size);
    int id_compare(char** arr,int size);
    int checkedButton_checker(char** arr,int size,char* string);
    int progress_max(int progress,int max);
    int size=0;
    int size2=0;
    int line_button=0;
    int line_radioButton=0;
    int max=100; //default max
    int progress=0;
    char **arr;
    char **radio_arr;
    char* checkedButton;
    int radio_count=0;
    int radio_checker=0;
    int mode=0;
    char* pos_error="near at the start of the file";
    
%}
%define parse.error verbose



%union /*to exw balei gia na kathorizoume ti einai to kathe token*/
{
    char *strval;
}


%token<strval> LINEAR_START RELATIVE_START TEXTVIEW_START IMAGEVIEW_START  BUTTON_START RADIOGROUP_START RADIOBUTTON_START BAR_START
%token<strval> ANDROID_ID ANDROID_ORIENTATION ANDROID_LAYOUT_WIDTH ANDROID_LAYOUT_HEIGHT ANDROID_TEXT ANDROID_TEXT_COLOR ANDROID_CHECKBUTTON ANDROID_PADDING ANDROID_SRC;
%token<strval> ANDROID_PROGRESS ANDROID_MAX ANDROID_COUNT 
%token END_LINEAR  END1 END2 RADIOGROUP_END END_RELATIVE
%token<strval>  UNKNOWN ANDROID_LAYOUT_ERROR PADDING_ERROR
%type<strval> android_id mad_feats android_orientation android_text text_color android_checkButton android_padding android_src 
%type<strval> android_max android_progress android_count
%start xml

%%
xml: linear_layout{printf("The file is correct goodbye\n");
    |relative_layout{printf("The file is correct goodbye\n");}
    ;

linear_layout: LINEAR_START mad_feats linear_optional END1 linear_layout_attributes END_LINEAR {}
             ;


linear_layout_attributes: elements 
                        | elements linear_layout_attributes {}
                        ;

linear_optional: android_id {}
               | android_orientation {}
               | android_id android_orientation {}
               | android_id UNKNOWN{ yyerror("expecting 'android:orientation=(string)'"); }
               | android_orientation android_id {}
               | android_orientation UNKNOWN{yyerror("expecting 'android:id=(string)'");}
               | UNKNOWN{ yyerror("expecting 'android:orientation=(string)' or 'android:id=(string)'");}
               | %empty{}
               ;

relative_layout: RELATIVE_START mad_feats relative_optional END1  END_RELATIVE {}
               | RELATIVE_START mad_feats relative_optional END1 relative_attributes END_RELATIVE {}


relative_attributes: elements 
                   | elements relative_attributes 


relative_optional: android_id 
                 | UNKNOWN{yyerror("expecting 'android:id=(string)'");}
                 | %empty
                 ;


elements: textview {}
        | imageview {}
        | button {}
        | radiogroup {}
        | linear_layout {}
        | relative_layout {}
        | progress_bar {}
        ;

textview: TEXTVIEW_START mad_feats textview_optional android_text END2 
        ;

textview_optional: android_id {}
                 | text_color {}
                 | android_id text_color {}
                 | text_color android_id {}
                 | UNKNOWN{yyerror("expecting 'android:id=(string)' or 'android:textColor=(string)'");}
                 | android_id UNKNOWN {yyerror("expecting 'android:textColor=(string)'");}
                 | text_color UNKNOWN {yyerror("expecting 'android:id=(string)'");}
                 | %empty {}
                 ;

imageview: IMAGEVIEW_START mad_feats android_src button_id_optional END2 ;

button: BUTTON_START mad_feats android_text button_id_optional END2 
    ;

button_id_optional: android_id 
                  | android_padding
                  | android_id android_padding
                  | android_padding android_id
                  | UNKNOWN{yyerror("expecting 'android:id=(string)' or 'android:padding=(positive intenger)'");}
                  | android_id UNKNOWN {yyerror("expecting 'android:padding=(positive intenger)'");}
                  | android_padding UNKNOWN {yyerror("expecting 'android:id=(string)'");}
                  | %empty
                  ;

radiogroup:RADIOGROUP_START mad_feats android_count radiogroup_optional END1 radiobutton_repeat RADIOGROUP_END {
                                                                                        if(checkedButton_checker(radio_arr,size2,checkedButton)==0)
                                                                                            {
                                                                                                yylineno=line_button;
                                                                                                mode=1;
                                                                                                yyerror("'android:checkedButton' value is different from 'android:id'");
                                                                                            }

                                                                                        }
                                                                                        ;


radiogroup_optional:android_id
                  | android_checkButton
                  | android_id  android_checkButton
                  | android_checkButton android_id
                  | UNKNOWN{yyerror("expecting 'android:checkButton=(string)' or 'android:id=(string)'");}
                  | android_id UNKNOWN {yyerror("expecting 'android:checkButton=(string)'");}
                  | android_checkButton UNKNOWN {yyerror("expecting 'android:id=(string)'");}
                  | %empty
                  ;

radiobutton_repeat: radiobutton {radio_count++; }
                  | radiobutton radiobutton_repeat {if(radio_checker==radio_count)
                                                        {
                                                         yylineno=line_radioButton;
                                                         mode=1;
                                                         yyerror(" 'android:count' is different by the number of 'RadioButton' elements");
                                                        }
                                                         
                                                         radio_count++; }
                  ;  

radiobutton: RADIOBUTTON_START mad_feats radiobutton_optional android_text END2
           ;

radiobutton_optional: android_id {add_id(&radio_arr,&size2,$1);}
                 | UNKNOWN{yyerror("expecting 'android:id=(string)'");}
                 | %empty
                 ;

progress_bar: BAR_START mad_feats bar_options END2 {if(progress_max(max,progress)==1) 
                                                        yyerror("the value of 'android:progress'is larger than 'android:max'");}
            ;


bar_options: android_id
            | android_max
            | android_progress   
            | android_id android_max
            | android_id android_progress
            | android_max android_id
            | android_max android_progress
            | android_progress android_id
            | android_progress android_max 
            | android_id android_max android_progress
            | android_id android_progress android_max
            | android_max android_id android_progress
            | android_max android_progress android_id
            | android_progress android_id android_max
            | android_progress android_max android_id
            | UNKNOWN{yyerror("expecting 'android:max=(positive intenger)' or 'android:progress=(positive intenger)' or 'android:id=(string)'");} 
            | android_id UNKNOWN {yyerror("expecting 'android:max=(positive intenger)' or 'android:progress=(positive intenger)'");}
            | android_max UNKNOWN {yyerror("expecting 'android:id=(string)' or 'android:progress=(positive intenger)'");}
            | android_progress UNKNOWN {yyerror("expecting 'android:max=(positive intenger)' or 'android:id=(string)'");}
            | android_id android_max UNKNOWN {yyerror("expecting 'android:progress=(positive intenger)'");}
            | android_id android_progress UNKNOWN {yyerror("expecting 'android:max=(positive intenger)'");}
            | android_max android_id UNKNOWN {yyerror("expecting 'android:progress=(positive intenger)'");}
            | android_max android_progress UNKNOWN {yyerror("expecting 'android:id=(string)'");}
            | android_progress android_id UNKNOWN {yyerror("expecting 'android:max=(positive intenger)'");}
            | android_progress android_max UNKNOWN {yyerror("expecting 'android:id=(string)'");}
            | %empty 
            ;


mad_feats: ANDROID_LAYOUT_WIDTH ANDROID_LAYOUT_HEIGHT {}
         | ANDROID_LAYOUT_HEIGHT ANDROID_LAYOUT_WIDTH {}
         | ANDROID_LAYOUT_HEIGHT UNKNOWN {yyerror("expecting 'android:layout_width=(string)'");}
         | ANDROID_LAYOUT_WIDTH UNKNOWN {yyerror("expecting 'android:layout_heigh=(string)'");}
         | UNKNOWN {yyerror("expecting 'android:layout_width=(string)' or 'android:layout_height=(string)'");}
         | ANDROID_LAYOUT_ERROR { mode=1; yyerror("Not accepted value, accepts 'wrap_content',\n'match_parent' or positive integer");}
         ;


android_id: ANDROID_ID {add_id(&arr,&size,yylval.strval);
                                                      
                            if(id_compare(arr,size)==0)
                            {
                                mode=1;
                                yyerror("'android_id' should be unique");
                            }
                            $$=$1;
                       }
          ;


android_orientation: ANDROID_ORIENTATION {} 
                   ;


android_count: ANDROID_COUNT {$$=$1; line_radioButton=yylineno; radio_checker=atoi($1);}
             ;


text_color: ANDROID_TEXT_COLOR {$$=$1;}
          ;


android_text: ANDROID_TEXT


android_max: ANDROID_MAX {max=atoi($1);}
            ;

android_padding: PADDING_ERROR {mode=1; yyerror("padding should be only a positive integer");} 
               | ANDROID_PADDING 
               ;

android_src: ANDROID_SRC 
           ;

android_checkButton: ANDROID_CHECKBUTTON {$$=$1; line_button=yylineno; checkedButton=$1;} 
    ;

android_progress: ANDROID_PROGRESS {progress=atoi($1);} 
    ;


%% 

int main(int argc,char *argv[])
{
    if(argc<2)
    {
        fprintf(stderr,"You didnt give me a file\n");
        return 1;
    }

    yyin=fopen(argv[1],"r");
    if(!yyin)
    {
        perror(argv[1]);
        return 1;   
    }
    
    char c;
    int count=1;
    printf("%d ",count++);
    rewind(yyin);
    while((c=fgetc(yyin))!=EOF)
    {   
        if(c=='\n')
        {   
            printf("%c",c);
            printf("%d: ",count);
            count++;
        }else{
            printf("%c",c);
        }
        
       
    }
    printf("\n");
    rewind(yyin);
    
    arr = (char**)malloc(sizeof(char*));
    radio_arr=(char**)malloc(sizeof(char*));
    
    yyparse();
    
    printf("this is a certified success!!\n");
    fclose(yyin);
    return 0;

}

void yyerror(const char* s) {
    pos_error=yylval.strval;
    if(mode==0)
        fprintf(stderr, "Parse error at line %d: %s near %s\n",yylineno,s,pos_error);
    else if(mode==1)
        fprintf(stderr, "Parse error at line %d: %s\n",yylineno,s);
    
    exit(1);
}

void add_id(char*** arr, int* size, const char* value) {
    if (*arr == NULL || *size == 0) {
        *arr = (char**)malloc(sizeof(char*));
        *size = 1;
    } else if (*size > 0) {
        *arr = (char**)realloc(*arr, (*size + 1) * sizeof(char*));
        (*size)++;
    }

    (*arr)[*size - 1] = (char*)malloc(strlen(value) + 1);
    strcpy((*arr)[*size - 1], value);

}

int id_compare(char** arr,int size)
{
    if(size==1)
        return 1;      
    
    for(int i=0; i<size-1; i++)
    {
       if(strcmp(arr[size-1],arr[i])==0)
            return 0;
           
    }
    return 1;
}

int checkedButton_checker(char** arr,int size,char* string)
{
    if(size==0)
        return 1;      
    
    for(int i=0; i<size; i++)
    {
       if(strcmp(string,arr[i])==0)
            return 1;
           
    }
    return 0;
}

int progress_max(int max,int progress)
{
    if (progress>max)
    {
        return 1;
    }   
    
    return 0;
}
