package lyc.compiler.files;

public class RegistroDeTabla {

    private String  lexema,
                    tipo,
                    valor;
    private int longitud;

    public RegistroDeTabla(String _lexema) {
        this.lexema = _lexema;
    }

    public void setTipo(String _tipo){

        this.tipo = _tipo;
    }

    public void setValor(String _valor){
        this.valor = _valor;
    }

    public void setLongitud(){
        this.longitud = lexema.length() - 1; //le saco uno porque está el guion bajo
    }

    public String getLexema(){

        return lexema;
    }

    @Override
    public String toString() {
        return String.format("%-15s %-15s %-15s %-15s\n", lexema, tipo, valor, longitud);
    }
}
