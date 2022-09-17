package lyc.compiler.files;

import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;


public class SymbolTableGenerator implements FileGenerator{

    /*
        habria que hacer una clase que se llame algo asi como
        "RegistroDeTabla" y que cuando invoquemos a agregarLexema() cree una nueva instancia ahi
        El hashSet pasaria de ser "HashSet<String>" a "HashSet<RegistroDeTabla>" creo
     */
    public static HashSet<String> listaLexemas = new HashSet<String>(); //el hashset es para validar que no se hayan lexemas duplicados
    public static ArrayList<RegistroDeTabla> tabla = new ArrayList<RegistroDeTabla>();

    @Override
    public void generate(FileWriter fileWriter) throws IOException { //genera el archivo de salida
        fileWriter.write("TODO");
    }

    public static void agregarLexema(String lexema, String tipo){   //los tipos son ID o CTE
        lexema = (tipo == "ID") ? lexema : "_" + lexema;
        if(existeLexema(lexema)){
            System.out.println("SymbolTable: Ya existe el lexema : " + lexema);
            return;
        }

        listaLexemas.add(lexema);
        tabla.add(new RegistroDeTabla(lexema));
        System.out.println("SymbolTable: El lexema agregado es: " + lexema);

    }

    public static boolean existeLexema(String lexema){
        return listaLexemas.contains(lexema);
    }

    public static void agregarTipo(String lexema, String tipo){
        lexema = (tipo == "ID") ? lexema : "_" + lexema;
        RegistroDeTabla registro = buscarRegistro(lexema);
        if(registro == null){
            return;
        }
        registro.setTipo(tipo);

    }

    public static void setValor(String lexema, String tipo, String valor){
        lexema = (tipo == "ID") ? lexema : "_" + lexema;
        RegistroDeTabla registro = buscarRegistro(lexema);
        if(registro == null){
            return;
        }
        registro.setValor(valor);
    }

    //solo para constantes string
    public static void setLongitud(String lexema){
        RegistroDeTabla registro = buscarRegistro("_" + lexema);
        if(registro == null){
            return;
        }
        registro.setLongitud();
    }

    private static RegistroDeTabla buscarRegistro(String lexema){
        boolean found = false;
        RegistroDeTabla registro = null;

        int i = 0;
        while(!found && i < tabla.size()){
            String lexemaRegistro = tabla.get(i).getLexema();
            if(lexema.equals(lexemaRegistro)){
                registro = tabla.get(i);
                found = true;
            }
            i++;
        }
        return registro;
    }


    public static void mostrarTabla(){ //metodo para ver si estoy llamando a la tabla de simbolos en un principio
        System.out.println("---- Mostrando tabla de simbolos ----");
        System.out.format("%-15s %-15s %-15s %-15s\n", "NOMBRE", "TIPODATO", "VALOR", "LONGITUD");
        for(RegistroDeTabla registro : tabla){
            System.out.println(registro.toString());
        }
        System.out.println("---- Fin de la tabla de simbolos ----");
    }

}
