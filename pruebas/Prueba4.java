/*LOCC = 1, LOCP = 29, LOCW = 5, LOCF = 35, Número ciclomático = 6*/
public class Prueba4 {

	public static void ifwhile(int catchfor){
		if(catchfor < 0){
			System.out.println("Movidote");
		}
	}

	public static void main(String args[]) {
		int forcatch = 0;
		ifwhile(forcatch);
		if (3 > 4) {
			System.out.println("Estoy en el if");
		} else {
			System.out.println("Estoy en el else");
		}

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
