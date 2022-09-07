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
OP_ASIG = "="

OpenParenthesis = "("
CloseParenthesis = ")"
OpenSqrBracket = "["
CloseSqrBracket = "]"
OpenBracket = "{"
CloseBracket = "}"
Colon = ":"
Semicolon = ";"



//Identificadores y constantes//
Identifier = {Letter} ({Letter}|{Digit})*
IntegerConstant = "-"?{Digit}{1,5}
FloatConstant = ("-"?{Digit}+)?"."{Digit}*
StringConstant = \"({Letter}|{Digit}|" "|"@"|"%")+\"


/* varios*/
Comment = "/*" ({Letter}|{Digit}|" "|\*)* "*/"
/* -------*/

//palabras reservadas que pide el enunciado
Init = "init"
Read = "read"
Write = "write"

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

  {LineTerminator}                                {System.out.println("Line Terminator"); return symbol(ParserSym.EOF);  }
  {Comment}                                {System.out.println("comment"); return symbol(ParserSym.EOF);  }
  {Init}                                {System.out.println("INIT"); return symbol(ParserSym.INIT); }
  {Read}                                {System.out.println("READ"); return symbol(ParserSym.READ); }
  {Write}                                {System.out.println("WRITE"); return symbol(ParserSym.WRITE); }


  {If}                                     {System.out.println("IF"); return symbol(ParserSym.IF); }
  {Else}                                     {System.out.println("ELSE"); return symbol(ParserSym.ELSE); }
  {While}                                     {System.out.println("WHILE"); return symbol(ParserSym.WHILE); }
  {For}                                     {System.out.println("FOR"); return symbol(ParserSym.FOR); }
  {Int}                                     {System.out.println("INT"); return symbol(ParserSym.INT); }
  {Float}                                     {System.out.println("FLOAT"); return symbol(ParserSym.FLOAT); }
  {String}                                     {System.out.println("STRING"); return symbol(ParserSym.STRING); }
  {Boolean}                                     {System.out.println("BOOLENA"); return symbol(ParserSym.BOOLEAN); }
  {True}                                     {System.out.println("TRUE"); return symbol(ParserSym.TRUE); }
  {False}                                     {System.out.println("FALSE"); return symbol(ParserSym.FALSE); }
   /* -----------*/


  /* identifiers */
  {Identifier}                             {
                                             if(yytext().length() > MAX_LENGTH){
                                                 throw new InvalidLengthException(yytext());
                                             }
                                             System.out.println("ID");
                                             return symbol(ParserSym.IDENTIFIER, yytext());
                                            }
  /* Constants */
  {IntegerConstant}                        {
                                                if(Integer.parseInt(yytext()) > 32767 || Integer.parseInt(yytext()) < -32768){
                                                    throw new InvalidIntegerException(yytext());
                                                }
                                                System.out.println("INTEGER CONSTANT");
                                                return symbol(ParserSym.INTEGER_CONSTANT, yytext());
                                           }
  {FloatConstant}                          {
                                                  if(Float.parseFloat(yytext()) > 2147483647 || Float.parseFloat(yytext()) < -2147483648){
                                                      throw new InvalidFloatException(yytext());
                                                  }
                                                  System.out.println("FLOAT CONSTANT");
                                                  return symbol(ParserSym.FLOAT_CONSTANT, yytext());
                                            }
   {StringConstant}                         {
                                                    if(yytext().length() > MAX_LENGTH){
                                                        throw new InvalidLengthException(yytext());
                                                    }
                                                    System.out.println("STRING CONSTANT");
                                                    return symbol(ParserSym.STRING_CONSTANT, yytext());
                                            }


  /* operators */
  {OP_PLUS}                                    {System.out.println("OP_PLUS"); return symbol(ParserSym.PLUS); }
  {OP_SUB}                                     {System.out.println("OP_SUB"); return symbol(ParserSym.SUB); }
  {OP_MULT}                                    {System.out.println("OP_MULT"); return symbol(ParserSym.MULT); }
  {OP_DIV}                                     {System.out.println("OP_DIV"); return symbol(ParserSym.DIV); }
  {OP_ASIG}                                   {System.out.println("OP_ASIG"); return symbol(ParserSym.ASSIG); }
  {OpenBracket}                             {System.out.println("OPEN_BRACKER"); return symbol(ParserSym.OPEN_BRACKET); }
  {CloseBracket}                            {System.out.println("CLOSE_BRACKET"); return symbol(ParserSym.CLOSE_BRACKET); }
  {OpenSqrBracket}                             {System.out.println("OPEN_SQR_BRACKET"); return symbol(ParserSym.OPEN_SQR_BRACKET); }
  {CloseSqrBracket}                             {System.out.println("CLOSE_SQR_BRACKET"); return symbol(ParserSym.CLOSE_SQR_BRACKET); }
  {OpenParenthesis}                             {System.out.println("OPEN_PAR"); return symbol(ParserSym.OPEN_PAR); }
  {CloseParenthesis}                             {System.out.println("CLOSE_PAR"); return symbol(ParserSym.CLOSE_PAR); }
  {Colon}                                    {System.out.println("COLON"); return symbol(ParserSym.COLON); }
  {Semicolon}                                {System.out.println("SEMI_COLON"); return symbol(ParserSym.SEMI_COLON); }

  /* whitespace */
  {WhiteSpace}                             { /* ignore */ }
}


/* error fallback */
[^]                              { throw new UnknownCharacterException(yytext()); }
