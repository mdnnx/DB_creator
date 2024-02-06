#!/bin/bash
	function Crear_base {        
		echo -e "Como llamaras a tu nueva base de datos: "       
		read Nueva_base
        	sqlite3 $Nueva_base.db<< EOF
	CREATE TABLE Inventario(
	ID iNTEGER PRIMARY KEY,
	Producto TEXT NOT NULL,       
	Precio_U INTEGER,      
	Precio_P INTEGER,       
	Beneficio INTEGER AS (Precio_P - Precio_U),     
	Stock INTEGER,
	Inversion INTEGER AS (Precio_U * Stock));

EOF
		echo -e "La nueva base de datos $Nueva_base.db se ha creado con exito\nAhora selecciona < 1 > para agregar datos a la base de datos o < 2 > para salir"
       		 read -p "Has una eleccion: " opt    
		 case $opt in    
		 "1") Modificar ;; 
		 "2") exit ;;
		 
	        esac   
}
	function Mostrar_base {
	
		echo "Cual base de datos deseas visualizar: "
		read Mod
		sqlite3 $Mod ".mode column" "SELECT * FROM Inventario;"

	}

	function Modificar {

		echo "Cual base de datos deseas modificar: "
		read Base
		clear
		echo "Producto:"     
		read Producto      
		echo "Precio unitario:"     
		read Precio_unitario
       		echo "Precio al publico:"
       		read Precio_publico
       		echo "Stock:"
       		read Stock
		sqlite3 $Base << EOF
        INSERT INTO Inventario (Producto, Precio_U, Precio_P, Stock) VALUES ('$Producto', $Precio_unitario, $Precio_publico, $Stock );
EOF
		function Seguir_modificando () {
			read -p "Desea seguir ingresando mas datos? s/n: " opc
			if [ "$opc" != "s" ]; then
				exit 
			else
				Modificar
			fi

		}
		Seguir_modificando
}
	function Consultar {
	read -p "Cual base deseas consultar: " name
	read -p "Que articulo buscas: " articulo
	sqlite3 $name ".mode column" "SELECT * FROM Inventario WHERE producto='$articulo';"
		function Seguir_buscando () {
			read -p "Deseas hacer otra consulta? s/n: " opc
			if [ "$opc" != "s" ]; then
				exit
			else
				Consultar
			fi

		}
		Seguir_buscando

}

echo -e "Bienvenido al script para crear bases de datos, que deseas hacer hoy: \n1.- Crear una nueva base de datos.\n2.- Modificar una basr de datos existente.\n3.- Mostrar base de datos.\n4.- Consultar base de datos.\n5.- Salir."
read -p "Has una eleccion: " opt      
case $opt in       
	"1") Crear_base ;;      
	"2") Modificar ;;   
	"3") Mostrar_base ;;
	"4") Consultar ;;
	"5") exit ;;
esac


