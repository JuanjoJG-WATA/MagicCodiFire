#!/bin/bash


# Función para validar la contraseña
function validar_contrasena() {
    local contrasena_ingresada="$1"
    local contrasena_guardada="$2"

    if [ "$contrasena_ingresada" == "$contrasena_guardada" ]; then
        return 0  # Contraseña válida
    else
        return 1  # Contraseña incorrecta
    fi
}

# Contraseña predeterminada (puedes cambiarla)
CONTRASENA_CORRECTA="TU_CONTRASEÑA_DESEADA"

# Pedir la contraseña al iniciar el programa
while true; do
    clear
    read -s -p "Ingrese la contraseña para iniciar el programa: " contrasena_usuario
    echo ""  # Agrega un salto de línea después de que el usuario ingrese la contraseña

    # Validar la contraseña
    if validar_contrasena "$contrasena_usuario" "$CONTRASENA_CORRECTA"; then
        echo "Contraseña correcta. Bienvenido al programa."
        break  # Salir del bucle si la contraseña es correcta
    else
        echo "Contraseña incorrecta. Inténtelo de nuevo."
    fi
done


function progreso() {
    local porcentaje=0

    while [ $porcentaje -le 100 ]; do
        local barra=""
        local espacio=""
        local barra_length=$((porcentaje / 2))

        for ((i = 0; i < barra_length; i++)); do
            barra+="-"
        done

        for ((i = 0; i < 50 - barra_length; i++)); do
            espacio+=" "
        done

        echo -ne "[${barra}${espacio}] [${porcentaje}%] \r"
        sleep 0.01
        ((porcentaje++))
    done

    echo -ne "\n"
}


while true; do
    clear

    echo "
     ___ ___   ____   ____  ____    __   ___   ___    ____  _____  ____  ____     ___ 
    |   |   | /    | /    ||    |  /  ] /   \ |   \  |    ||     ||    ||    \   /  _]
    | _   _ ||  o  ||   __| |  |  /  / |     ||    \  |  | |   __| |  | |  D  ) /  [_ 
    |  \_/  ||     ||  |  | |  | /  /  |  O  ||  D  | |  | |  |_   |  | |    / |    _]
    |   |   ||  _  ||  |_ | |  |/   \_ |     ||     | |  | |   _]  |  | |    \ |   [_ 
    |   |   ||  |  ||     | |  |\     ||     ||     | |  | |  |    |  | |  .  \|     |
    |___|___||__|__||___,_||____|\____| \___/ |_____||____||__|   |____||__|\_||_____|

                                                    by Juan José Jiménez Gil.
    "

    echo "Bienvenido a mi script de encriptación y desencriptación."
    echo ""
    echo "¿Qué acción quieres realizar?"
    echo "1. Encriptar"
    echo "2. Desencriptar"
    echo "3. Salir"
    echo ""
    read -p "Ingrese el número correspondiente a la acción que quieras realizar: " opcion
    echo ""

    case $opcion in
        1)
            echo "Has seleccionado Encriptar."
            echo ""
            sleep 2
            clear
            echo "#########################################################################"
            echo "
                      ___             _      _           _          
                     | __|_ _  __ _ _(_)_ __| |_ __ _ __(_)___ _ _  
                     | _|| ' \/ _| '_| | '_ \  _/ _  / _| / _ \ ' \ 
                     |___|_||_\__|_| |_| .__/\__\__,_\__|_\___/_||_|
                                       |_|                          
                                                basado en el cifrado de archivos AES-256.
            "
            echo "#########################################################################"
            sleep 4
            clear
            read -sp "Inserte el texto que desea encriptar: " texto
            echo ""
            if [ -z "$texto" ]; then
                echo "Error: No se proporcionó ningún texto para encriptar."
                exit 1
            fi
            clear
            echo ""
            echo "Generando clave de encriptación..."
            echo ""
            progreso
            echo ""

            # Preguntar al usuario si desea utilizar una nueva clave o la misma que anteriormente
            read -p "¿Desea utilizar una nueva clave de encriptación? (S/N): " nueva_clave
            echo ""

            if [ "$nueva_clave" == "S" ] || [ "$nueva_clave" == "s" ]; then
                openssl rand -base64 128 > Clave.txt
                echo "Clave generada con éxito."
            elif [ "$nueva_clave" == "N" ] || [ "$nueva_clave" == "n" ]; then
                if [ ! -f Clave.txt ]; then
                    echo "Error: No se encontró ninguna clave previa."
                    exit 1
                fi
                echo "Se utilizará la misma clave de encriptación previa."
            else
                echo "No se eligió ninguna opción, se generará una nueva clave."
                openssl rand -base64 128 > Clave.txt
                echo "Clave generada con éxito."
            fi


            sleep 2
            clear
            echo ""
            echo "Encriptando archivo..."
            echo ""
            progreso
            echo ""
            echo $texto > Encriptado.txt
            openssl aes-256-cbc -pbkdf2 -in Encriptado.txt -out Encriptado.3nc -pass file:Clave.txt
            rm Encriptado.txt
            echo ""
            echo "##################################################"
            echo ""
            echo "Archivo encriptado con éxito."
            echo ""
            echo "##################################################"
            echo ""
            echo ""
            sleep 4
            ;;
        2)
            echo "Ha seleccionado desencriptar."
            echo ""
            sleep 2
            clear
            echo "#########################################################################"
            echo "
              ___                          _      _           _          
             |   \ ___ ___ ___ _ _  __ _ _(_)_ __| |_ __ _ __(_)___ _ _  
             | |) / -_|_-</ -_) ' \/ _| '_| | '_ \  _/ _  / _| / _ \ ' \ 
             |___/\___/__/\___|_||_\__|_| |_| .__/\__\__,_\__|_\___/_||_|
                                            |_|                          
                                        
                                        basado en el cifrado de archivos AES-256.
            "
            echo "#########################################################################"
            sleep 6
            clear
            echo ""
            echo "##################################################"
            echo ""

            for archivo in $(find . -name "*.3nc")
            do
                echo "Comprobando la clave de encriptación."
                echo ""

                if [ -e Clave.txt ]; then
                    progreso
                    echo ""
                    echo "Clave comprobada con éxito."
                    echo ""
                    echo "##################################################"
                    echo ""
                    sleep 2
                    clear
                else
                    echo "Clave de cifrado no encontrada."
                    echo ""
                    echo "##################################################"
                    echo ""
                    sleep 2
                    clear
                    exit
                fi
                echo ""
                echo "##################################################"
                echo ""
                echo "Desencriptando archivo."
                echo ""
                progreso
                openssl aes-256-cbc -pbkdf2 -d -in "$archivo" -out Desencriptado.d3nc -pass file:Clave.txt
                echo ""
                echo "Archivo desencriptado con éxito."
                echo ""
                echo "##################################################"
                echo ""
                sleep 2
                clear
            done

            echo "##################################################"
            echo ""
            read -p "¿Deseas borrar los ficheros que contienen la clave y el archivo inicial encriptado? [S/N]: " confirmacion

            if [ "$confirmacion" == "S" ] || [ "$confirmacion" == "s" ]; then
                rm $archivo Clave.txt
                echo ""
                echo "Se han borrado $archivo y Clave.txt."
                echo ""
                echo "##################################################"
                echo ""
                sleep 2
                clear
            else
                if [ "$confirmacion" == "N" ] || [ "$confirmacion" == "n" ]; then
                    echo ""
                    echo "No se han borrado los ficheros $archivo ni Clave.txt. Asegúrese de borrarlos manualmente para mayor seguridad."
                    echo ""
                    echo ""
                    echo "##################################################"
                    echo ""
                    sleep 2
                    clear
                else
                    echo ""
                    echo "Confirmación inválida. Se borrarán los archivos creados y se cerrará el programa."
                    rm "${archivo%.*}.d3nc"
                    echo ""
                    echo ""
                    echo "##################################################"
                    echo ""
                    exit
                    sleep 2
                    clear
                fi
            fi
            ;;
        3)
            echo "Cerrando el programa."
            sleep 2
            exit 2
            ;;
    esac
done
