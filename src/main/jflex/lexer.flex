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

OpenBracket = "("
CloseBracket = ")"
Colon = ":"
Semicolon = ";"



//Identificadores y constantes//
Identifier = {Letter} ({Letter}|{Digit})*
IntegerConstant = {Digit}{1,5}  ///temporalmente uso este hasta desbuggear el otro con el signo negativo
//IntegerConstant = -?{Digit}{1,5}
FloatConstant = {Digit}+"."{Digit}+
StringConstant = \"({Letter}|{Digit}|" ")+\"


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
  {Comment}                                { return symbol(ParserSym.EOF); }

  {Init}                                { return symbol(ParserSym.INIT); }
  {Colon}                                { return symbol(ParserSym.COLON); }
  {Read}                                { return symbol(ParserSym.READ); }
  {Write}                                { return symbol(ParserSym.WRITE); }


  {If}                                     { return symbol(ParserSym.IF); }
  {Else}                                     { return symbol(ParserSym.ELSE); }
  {While}                                     { return symbol(ParserSym.WHILE); }
  {For}                                     { return symbol(ParserSym.FOR); }
  {Int}                                     { return symbol(ParserSym.INT); }
  {Float}                                     { return symbol(ParserSym.FLOAT); }
  {String}                                     { return symbol(ParserSym.STRING); }
  {Boolean}                                     { return symbol(ParserSym.BOOLEAN); }
  {True}                                     { return symbol(ParserSym.TRUE); }
  {False}                                     { return symbol(ParserSym.FALSE); }
   /* -----------*/


  /* identifiers */
  {Identifier}                             { return symbol(ParserSym.IDENTIFIER, yytext()); }
  /* Constants */
  {IntegerConstant}                        {
                                                if(Integer.parseInt(yytext()) > 32767 || Integer.parseInt(yytext()) < -32768){
                                                    throw new InvalidIntegerException(yytext());
                                                }
                                                return symbol(ParserSym.INTEGER_CONSTANT, yytext());
                                           }
  {FloatConstant}                          {
                                                  if(Float.parseFloat(yytext()) > 2147483647 || Float.parseFloat(yytext()) < -2147483648){
                                                      throw new InvalidFloatException(yytext());
                                                  }
                                                  return symbol(ParserSym.FLOAT_CONSTANT, yytext());
                                            }
   {StringConstant}                         {
                                                    if(yytext().length() > MAX_LENGTH){
                                                        throw new InvalidLengthException(yytext());
                                                    }
                                                    return symbol(ParserSym.STRING_CONSTANT, yytext());
                                            }


  /* operators */
  {OP_PLUS}                                    { return symbol(ParserSym.PLUS); }
  {OP_SUB}                                     { return symbol(ParserSym.SUB); }
  {OP_MULT}                                    { return symbol(ParserSym.MULT); }
  {OP_DIV}                                     { return symbol(ParserSym.DIV); }
  {OP_ASIG}                                   { return symbol(ParserSym.ASSIG); }
  {OpenBracket}                             { return symbol(ParserSym.OPEN_BRACKET); }
  {CloseBracket}                            { return symbol(ParserSym.CLOSE_BRACKET); }

  /* whitespace */
  {WhiteSpace}                             { /* ignore */ }
}


/* error fallback */
[^]                              { throw new UnknownCharacterException(yytext()); }
