package lyc.compiler.files;

import java.io.FileWriter;
import java.io.IOException;
import java.util.HashSet;


public class SymbolTableGenerator implements FileGenerator{

    /*
        habria que hacer una clase que se llame algo asi como
        "RegistroDeTabla" y que cuando invoquemos a agregarLexema() cree una nueva instancia ahi
        El hashSet pasaria de ser "HashSet<String>" a "HashSet<RegistroDeTabla>" creo
     */
    public static HashSet<String> tabla = new HashSet<String>();

    @Override
    public void generate(FileWriter fileWriter) throws IOException {
        fileWriter.write("TODO");
    }

    public static void agregarLexema(String lexema, String tipo){   //los tipos son ID o CTE
        lexema = (tipo == "ID") ? lexema : "_" + lexema;
        System.out.println("SymbolTable: El lexema agregado es: " + lexema);
        tabla.add(lexema);
    }

    public static void mostrarTabla(){ //metodo para ver si estoy llamando a la tabla de simbolos en un principio
        System.out.println("---- Mostrando tabla de simbolos ----");
        System.out.format("%-15s %-15s %-15s %-15s\n", "NOMBRE", "TIPODATO", "VALOR", "LONGITUD");
        for(String lexema : tabla){
            System.out.format("%-15s\n", lexema);
        }
        System.out.println("---- Fin de la tabla de simbolos ----");
    }

}
