/*LOCC = 1, LOCP = 30, LOCW = 6, LOCF = 37, Número ciclomático = 8*/

public class Prueba4 {

	public static void ifwhile(int catchfor){
		if(catchfor < 0){
			System.out.println("Movidote");
		} else if(catchfor == 0)
			System.out.println("elseif");
	}

	public static void main(String args[]) {
		int forcatch = 0;
		ifwhile(forcatch);
		if (3 > 4) {
			System.out.println("Estoy en el if");
		} else {
			System.out.println("Estoy en el else");
		} if(2>3) { System.out.println("A continuacion de llave");}

		for (int i = 0; i < 5; i++) {
			System.out.println("Imprimo el número " + i + " en el for");
		}

		int iffor = 0;
		while (iffor < 5) {
			System.out.println("Imprimo el número " + iffor + " en el while");
			iffor++;
		}

		try {
			System.out.println("Estoy en el try");
		} catch (Exception e) {
			System.out.println("Imprimo una excepcion");
		}
	}
}
