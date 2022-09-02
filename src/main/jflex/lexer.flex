package lyc.compiler;

import java_cup.runtime.Symbol;
import lyc.compiler.ParserSym;
import lyc.compiler.model.*;
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


///-----------Elementos terminales---------

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
Identation =  [ \t\f]

Plus = "+"
Mult = "*"
Sub = "-"
Div = "/"
Assig = "="
OpenBracket = "("
CloseBracket = ")"
Letter = [a-zA-Z]
Digit = [0-9]

//Acá van los nuestros//

///-------Elementos NO terminales----------

WhiteSpace = {LineTerminator} | {Identation}
Identifier = {Letter} ({Letter}|{Digit})*
IntegerConstant = {Digit}+

//Acá van los nuestros//
Comment = "/*" ({Letter}|{Digit}|" "|\*)* "*/"


//palabras reservadas que pide el enunciado
Init = "init"
Colon = ":"
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
  {IntegerConstant}                        { return symbol(ParserSym.INTEGER_CONSTANT, yytext()); }

  /* operators */
  {Plus}                                    { return symbol(ParserSym.PLUS); }
  {Sub}                                     { return symbol(ParserSym.SUB); }
  {Mult}                                    { return symbol(ParserSym.MULT); }
  {Div}                                     { return symbol(ParserSym.DIV); }
  {Assig}                                   { return symbol(ParserSym.ASSIG); }
  {OpenBracket}                             { return symbol(ParserSym.OPEN_BRACKET); }
  {CloseBracket}                            { return symbol(ParserSym.CLOSE_BRACKET); }

  /* whitespace */
  {WhiteSpace}                             { /* ignore */ }
}


/* error fallback */
[^]                              { throw new UnknownCharacterException(yytext()); }
