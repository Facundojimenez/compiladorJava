package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.constants.Constants;import lyc.compiler.model.*;
import static lyc.compiler.constants.Constants.*;

%%

%public
%class Lexer
%unicode
%cup
%line
%column
%throws CompilerException
%eofval{
  return symbol(ParserSym.EOF);
%eofval}


%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}


/* Operadores y elementos básicos*/

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Identation =  [ \t\f]
WhiteSpace = {LineTerminator} | {Identation}
Letter = [a-zA-Z]
Digit = [0-9]


OP_PLUS = "+"
OP_MULT = "*"
OP_SUB = "-"
OP_DIV = "/"
OP_ASSIG = "="
OP_GT = ">"
OP_GE = ">="
OP_LT = "<"
OP_LE = "<="
OP_EQ = "=="
OP_NE = "!="
OP_NOT = "!"
OP_AND = "&"
OP_OR = "||"

OpenParenthesis = "("
CloseParenthesis = ")"
OpenSqrBracket = "["
CloseSqrBracket = "]"
OpenBracket = "{"
CloseBracket = "}"
Colon = ":"
Semicolon = ";"
Comma = ","



//Identificadores y constantes//
Identifier = {Letter} ({Letter}|{Digit})*
IntegerConstant = "-"?{Digit}{1,5}
FloatConstant = ("-"?{Digit}+)?"."{Digit}*
StringConstant = \"({Letter}|{Digit}|" "|"@"|"%")+\"


/* varios*/
Comment = "/*" .* "*/"
/* -------*/

//palabras reservadas que pide el enunciado
Init = "init"
Read = "read"
Write = "write"
Repeat = "repeat"

///palabras reservadas de java
If = "if"
Else = "else"
While = "while"
For = "for"
Int = "int"
Float = "float"
String = "string"
Boolean = "boolean"
True = "true"
False = "false"

%%


/* keywords */

//Hay que listar los tokens de más especificos a menos específico, porque sino te los va a reconocer mal

<YYINITIAL> {
   /*------Aca van los nuestros------*/

  {Comment}                                {System.out.println("--comment--"); }
  {Init}                                {System.out.println("TOKEN: INIT"); return symbol(ParserSym.INIT); }
  {Read}                                {System.out.println("TOKEN: READ"); return symbol(ParserSym.READ); }
  {Write}                                {System.out.println("TOKEN: WRITE"); return symbol(ParserSym.WRITE); }
  {Repeat}                                {System.out.println("TOKEN: REPEAT"); return symbol(ParserSym.REPEAT); }


  {If}                                     {System.out.println("TOKEN: IF"); return symbol(ParserSym.IF); }
  {Else}                                     {System.out.println("TOKEN: ELSE"); return symbol(ParserSym.ELSE); }
  {While}                                     {System.out.println("TOKEN: WHILE"); return symbol(ParserSym.WHILE); }
  {For}                                     {System.out.println("TOKEN: FOR"); return symbol(ParserSym.FOR); }
  {Int}                                     {System.out.println("TOKEN: INT"); return symbol(ParserSym.INT); }
  {Float}                                     {System.out.println("TOKEN: FLOAT"); return symbol(ParserSym.FLOAT); }
  {String}                                     {System.out.println("TOKEN: STRING"); return symbol(ParserSym.STRING); }
  {Boolean}                                     {System.out.println("TOKEN: BOOLEAN"); return symbol(ParserSym.BOOLEAN); }
  {True}                                     {System.out.println("TOKEN: TRUE"); return symbol(ParserSym.TRUE); }
  {False}                                     {System.out.println("TOKEN: FALSE"); return symbol(ParserSym.FALSE); }
   /* -----------*/


  /* identifiers */
  {Identifier}                             {
                                             if(yytext().length() > MAX_LENGTH){
                                                 throw new InvalidLengthException(yytext());
                                             }
                                             System.out.println("TOKEN: ID");
                                             return symbol(ParserSym.IDENTIFIER, yytext());
                                            }
  /* Constants */
  {IntegerConstant}                        {
                                                if(Integer.parseInt(yytext()) > 32767 || Integer.parseInt(yytext()) < -32768){
                                                    throw new InvalidIntegerException(yytext());
                                                }
                                                System.out.println("TOKEN: INTEGER CONSTANT");
                                                return symbol(ParserSym.INTEGER_CONSTANT, yytext());
                                           }
  {FloatConstant}                          {
                                                  if(Float.parseFloat(yytext()) > 2147483647 || Float.parseFloat(yytext()) < -2147483648){
                                                      throw new InvalidFloatException(yytext());
                                                  }
                                                  System.out.println("TOKEN: FLOAT CONSTANT");
                                                  return symbol(ParserSym.FLOAT_CONSTANT, yytext());
                                            }
   {StringConstant}                         {
                                                    if(yytext().length() > MAX_LENGTH){
                                                        throw new InvalidLengthException(yytext());
                                                    }
                                                    System.out.println("TOKEN: STRING CONSTANT");
                                                    return symbol(ParserSym.STRING_CONSTANT, yytext());
                                            }


  /* operators */
  {OP_PLUS}                                    {System.out.println("TOKEN: OP_PLUS"); return symbol(ParserSym.OP_PLUS); }
  {OP_SUB}                                     {System.out.println("TOKEN: OP_SUB"); return symbol(ParserSym.OP_SUB); }
  {OP_MULT}                                    {System.out.println("TOKEN: OP_MULT"); return symbol(ParserSym.OP_MULT); }
  {OP_DIV}                                     {System.out.println("TOKEN: OP_DIV"); return symbol(ParserSym.OP_DIV); }
  {OP_GT}                                   {System.out.println("TOKEN: OP_GT"); return symbol(ParserSym.OP_GT); }
  {OP_GE}                                   {System.out.println("TOKEN: OP_ASIG"); return symbol(ParserSym.OP_GE); }
  {OP_LT}                                   {System.out.println("TOKEN: OP_GE"); return symbol(ParserSym.OP_LT); }
  {OP_LE}                                   {System.out.println("TOKEN: OP_LE"); return symbol(ParserSym.OP_LE); }
  {OP_EQ}                                   {System.out.println("TOKEN: OP_EQ"); return symbol(ParserSym.OP_EQ); }
  {OP_NE}                                   {System.out.println("TOKEN: OP_NE"); return symbol(ParserSym.OP_NE); }
  {OP_NOT}                                   {System.out.println("TOKEN: OP_NOT"); return symbol(ParserSym.OP_NOT); }
  {OP_AND}                                   {System.out.println("TOKEN: OP_AND"); return symbol(ParserSym.OP_AND); }
  {OP_OR}                                   {System.out.println("TOKEN: OP_OR"); return symbol(ParserSym.OP_OR); }
  {OP_ASSIG}                                   {System.out.println("TOKEN: OP_ASIG"); return symbol(ParserSym.OP_ASSIG); }
  {OpenBracket}                             {System.out.println("TOKEN: OPEN_BRACKET"); return symbol(ParserSym.OPEN_BRACKET); }
  {CloseBracket}                            {System.out.println("TOKEN: CLOSE_BRACKET"); return symbol(ParserSym.CLOSE_BRACKET); }
  {OpenSqrBracket}                             {System.out.println("TOKEN: OPEN_SQR_BRACKET"); return symbol(ParserSym.OPEN_SQR_BRACKET); }
  {CloseSqrBracket}                             {System.out.println("TOKEN: CLOSE_SQR_BRACKET"); return symbol(ParserSym.CLOSE_SQR_BRACKET); }
  {OpenParenthesis}                             {System.out.println("TOKEN: OPEN_PAR"); return symbol(ParserSym.OPEN_PAR); }
  {CloseParenthesis}                             {System.out.println("TOKEN: CLOSE_PAR"); return symbol(ParserSym.CLOSE_PAR); }
  {Colon}                                    {System.out.println("TOKEN: COLON"); return symbol(ParserSym.COLON); }
  {Semicolon}                                {System.out.println("TOKEN: SEMI_COLON"); return symbol(ParserSym.SEMI_COLON); }
  {Comma}                                {System.out.println("TOKEN: COMMA"); return symbol(ParserSym.COMMA); }

  /* whitespace */
  {WhiteSpace}                             { /* ignore */ }
}


/* error fallback */
[^]                              { throw new UnknownCharacterException(yytext()); }
