package lyc.compiler;

import lyc.compiler.factories.LexerFactory;
import lyc.compiler.model.CompilerException;
import lyc.compiler.model.InvalidIntegerException;
import lyc.compiler.model.InvalidFloatException;
import lyc.compiler.model.InvalidLengthException;
import lyc.compiler.model.UnknownCharacterException;
import org.apache.commons.text.CharacterPredicates;
import org.apache.commons.text.RandomStringGenerator;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

import java.io.IOException;

import static com.google.common.truth.Truth.assertThat;
import static lyc.compiler.constants.Constants.MAX_LENGTH;
import static org.junit.jupiter.api.Assertions.assertThrows;



public class LexerTest {

  private Lexer lexer;


  /* ----Acá van nuestras pruebas */

  @Test
  public void r_init() throws Exception{
    scan("init");
    assertThat(nextToken()).isEqualTo(ParserSym.INIT);
  }

  @Test
  public void r_colon() throws Exception{
    scan(":");
    assertThat(nextToken()).isEqualTo(ParserSym.COLON);
  }

  @Test
  public void r_read() throws Exception{
    scan("read");
    assertThat(nextToken()).isEqualTo(ParserSym.READ);
  }

  @Test
  public void r_write() throws Exception{
    scan("write");
    assertThat(nextToken()).isEqualTo(ParserSym.WRITE);
  }

  @Test
  public void r_if() throws Exception{
    scan("if");
    assertThat(nextToken()).isEqualTo(ParserSym.IF);
  }

  @Test
  public void r_else() throws Exception{
    scan("else");
    assertThat(nextToken()).isEqualTo(ParserSym.ELSE);
  }

  @Test
  public void r_while() throws Exception{
    scan("while");
    assertThat(nextToken()).isEqualTo(ParserSym.WHILE);
  }

  @Test
  public void r_for() throws Exception{
    scan("for");
    assertThat(nextToken()).isEqualTo(ParserSym.FOR);
  }

  @Test
  public void r_int() throws Exception{
    scan("int");
    assertThat(nextToken()).isEqualTo(ParserSym.INT);
  }

  @Test
  public void r_float() throws Exception{
    scan("float");
    assertThat(nextToken()).isEqualTo(ParserSym.FLOAT);
  }

  @Test
  public void r_string() throws Exception{
    scan("string");
    assertThat(nextToken()).isEqualTo(ParserSym.STRING);
  }

  @Test
  public void r_boolean() throws Exception{
    scan("boolean");
    assertThat(nextToken()).isEqualTo(ParserSym.BOOLEAN);
  }

  @Test
  public void r_true() throws Exception{
    scan("true");
    assertThat(nextToken()).isEqualTo(ParserSym.TRUE);
  }

  @Test
  public void r_false() throws Exception{
    scan("false");
    assertThat(nextToken()).isEqualTo(ParserSym.FALSE);
  }

  @Test
  public void validPositiveFloatConstantValue() throws Exception{
    scan("1.5");
    assertThat(nextToken()).isEqualTo(ParserSym.FLOAT_CONSTANT);
  }

  @Test
  public void invalidPositiveFloatConstantValue() {
    assertThrows(InvalidFloatException.class, () -> {
      scan("55555555555555555.50");
      nextToken();
    });
  }


  /* ------------------------------- */

  @Test
  public void comment() throws Exception{
    scan("/*This is a comment*/");
    assertThat(nextToken()).isEqualTo(ParserSym.EOF);
  }



  @Test
  public void invalidStringConstantLength() {
    assertThrows(InvalidLengthException.class, () -> {
      scan("\"%s\"".formatted(getRandomString()));
      nextToken();
    });
  }

  @Disabled
  @Test
  public void invalidIdLength() {
    assertThrows(InvalidLengthException.class, () -> {
      scan(getRandomString());
      nextToken();
    });
  }

  @Test
  public void invalidPositiveIntegerConstantValue() {
    assertThrows(InvalidIntegerException.class, () -> {
      scan("%d".formatted(9223372036854775807L));
      nextToken();
    });
  }



  @Test
  public void invalidNegativeIntegerConstantValue() {
    assertThrows(InvalidIntegerException.class, () -> {
      scan("%d".formatted(-9223372036854775807L));
      nextToken();
    });
  }

  @Test
  public void assignmentWithExpressions() throws Exception {
    scan("c = d * ( e - 21 ) / 4");
    assertThat(nextToken()).isEqualTo(ParserSym.IDENTIFIER);
    assertThat(nextToken()).isEqualTo(ParserSym.ASSIG);
    assertThat(nextToken()).isEqualTo(ParserSym.IDENTIFIER);
    assertThat(nextToken()).isEqualTo(ParserSym.MULT);
    assertThat(nextToken()).isEqualTo(ParserSym.OPEN_PAR);
    assertThat(nextToken()).isEqualTo(ParserSym.IDENTIFIER);
    assertThat(nextToken()).isEqualTo(ParserSym.SUB);
    assertThat(nextToken()).isEqualTo(ParserSym.INTEGER_CONSTANT);
    assertThat(nextToken()).isEqualTo(ParserSym.CLOSE_PAR);
    assertThat(nextToken()).isEqualTo(ParserSym.DIV);
    assertThat(nextToken()).isEqualTo(ParserSym.INTEGER_CONSTANT);
    assertThat(nextToken()).isEqualTo(ParserSym.EOF);
  }

  @Test
  public void unknownCharacter() {
    assertThrows(UnknownCharacterException.class, () -> {
      scan("#");
      nextToken();
    });
  }


  @AfterEach
  public void resetLexer() {
    lexer = null;
  }

  private void scan(String input) {
    lexer = LexerFactory.create(input);
  }

  private int nextToken() throws IOException, CompilerException {
    return lexer.next_token().sym;
  }

  private static String getRandomString() {
    return new RandomStringGenerator.Builder()
            .filteredBy(CharacterPredicates.LETTERS)
            .withinRange('a', 'z')
            .build().generate(MAX_LENGTH * 2);
  }

}
