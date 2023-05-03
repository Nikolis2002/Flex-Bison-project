# Compiler and linker settings
CC = gcc

# Source and output files
LEXER_SRC = flex.l
PARSER_SRC = Bison.y

# Generated files
LEXER_OUT = lex.yy.c
PARSER_OUT = Bison.tab.c
PARSER_HEADER = Bison.tab.h
OUTPUT_EXECUTABLE = xml_parser 

# Build rules
all: $(OUTPUT_EXECUTABLE)

$(OUTPUT_EXECUTABLE): $(LEXER_OUT) $(PARSER_OUT)
	$(CC)  $(LEXER_OUT) $(PARSER_OUT) -o $(OUTPUT_EXECUTABLE)

$(LEXER_OUT): $(LEXER_SRC) $(PARSER_HEADER)
	flex $(LEXER_SRC)

$(PARSER_OUT) $(PARSER_HEADER): $(PARSER_SRC)
	bison -d $(PARSER_SRC)

clean:
	rm -f $(LEXER_OUT) $(PARSER_OUT) $(PARSER_HEADER) $(OUTPUT_EXECUTABLE)

.PHONY: all clean
