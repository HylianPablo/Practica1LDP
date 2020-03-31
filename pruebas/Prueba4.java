/*LOCC = 1 LOCP = 22 LOCW = 3 LOCF = 26 Número ciclomático = 5*/
public class Prueba4 {
	public static void main(String args[]) {
		if (3 > 4) {
			System.out.println("Estoy en el if");
		} else {
			System.out.println("Estoy en el else");
		}

		for (int i = 0; i < 5; i++) {
			System.out.println("Imprimo el número " + i + " en el for");
		}

		int i = 0;
		while (i < 5) {
			System.out.println("Imprimo el número " + i + " en el while");
			i++;
		}

		try {
			System.out.println("Estoy en el try");
		} catch (Exception e) {
			System.out.println("Imprimo una excepcion");
		}
	}
}
