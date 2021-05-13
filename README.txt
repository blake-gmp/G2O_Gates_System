/* Dodanie skryptu */
config.xml -> <import src="G2O_Gates_System-main/scripts.xml" />

/* Info */
+ Autor: heisenberg/blake
+ Wymagane do dzialania: MySQL module
+ Domyslne haslo: "gate123"  (mozna zmienic w gates-server-init)

/* MySQL EXAMPLE */
/*MySQL EXAMPLE
CREATE TABLE gates (
id INT(13) UNSIGNED PRIMARY KEY,
opened INT(3) NOT NULL
);

INSERT INTO `gates`(`id`, `opened`) VALUES (0,1); każdą nową brame trzeba dodać do bazy (zeby dzialal zapis)
*/

/* Dystans */
const manipulation_distance = 270; //dystans do wpisania komendy
const manipulation_range = 1800; //dystans do animacji zamykania bramy
const manipulation_msg = 900; //dystans do otrzymania wiadomosci o akcji

/* Funkcje */ - Domyślnie w gates-server-init

   enabledGatesSystem(true) //system włączony
   gates_permission = false; //Bez uprawnień nie można otwierać

/* Komendy */

/open /o - otwieranie bramy
/close /c - zamykanie bramy
/gate /gates - logowanie do uprawnien
