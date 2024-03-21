#!/bin/bash
#
#

# Menu:
#
RAIZ=$(pwd)

while true; do
    echo "Ingresa una opcion: "

    echo -e "\n[1] Instalar kafka"
    echo -e "[2] Levantar servidor kafka (local)"
    echo -e "[3] Crear colas (topicos)"
    echo -e "[4] Listar colas del servidor"
    echo -e "[5] Matar servidor kafka"
	echo -e "[6] Producer / Consumer"
    echo -e "[0] salir o CTRL + C"

    KAFKA_HOME=kafka_server

    read -p ">> " opcion
    echo ""
    
    if [ $opcion -eq 1 ]; then
		cd ${RAIZ}
        wget https://downloads.apache.org/kafka/3.7.0/kafka_2.12-3.7.0.tgz
        tar -xf kafka_2.12-3.7.0.tgz
        mv kafka_2.12-3.7.0 ${KAFKA_HOME}

		echo "Instalacion de kafka completada"
		echo -e "\n\n"

    elif [ $opcion -eq 2 ]; then
		cd ${RAIZ}

		cd ${KAFKA_HOME}
		sh bin/zookeeper-server-start.sh config/zookeeper.properties > /dev/null 2>&1 &
		sleep 5
		ZOOKEEPER_PID=$(ps aux | grep -i '[z]oo' | awk '{print $2}' | head -n 1)
		echo "PID del servidor de Zookeeper: $ZOOKEEPER_PID"


		sh bin/kafka-server-start.sh config/server.properties > /dev/null 2>&1 &
		sleep 5
		KAFKA_PID=$(ps aux | grep -i 'kafka\.Kafka' | grep -v grep | awk '{print $2}')
		echo "PID del servidor de Kafka: $KAFKA_PID"
		cd ${RAIZ}
		echo -e "KAFKA_PID,ZOOKEEPER_PID\n${KAFKA_PID},${ZOOKEEPER_PID}" >> pid.csv
		
		echo "Servidor kafka levantado"
		echo -e "\n\n"

    elif [ $opcion -eq 3 ]; then
		cd ${RAIZ}
		cd ${KAFKA_HOME}
		kafka="localhost"
		port="9092"
		topic=""
		partitions="5"
		replicas="1"

		read -p "(default: localhost) Ingresa el servidor de kafka: " kafka_input
		read -p "(default: 9092) Ingresa el puerto de kafka: " port_input
		read -p "Ingresa el nombre del topico: " topic_input
		read -p "(default: 5) Ingresa el numero de particiones: " partitions_input
		read -p "(default: 1) Ingresa el numero de replicas: " replicas_input

		kafka="${kafka_input:-localhost}"  # Usar el valor ingresado o el predeterminado si está vacío
		port="${port_input:-9092}"          # Usar el valor ingresado o el predeterminado si está vacío
		topic="${topic_input}"              # Usar el valor ingresado sin predeterminado
		partitions="${partitions_input:-5}" # Usar el valor ingresado o el predeterminado si está vacío
		replicas="${replicas_input:-1}"     # Usar el valor ingresado o el predeterminado si está vacío

		bin/kafka-topics.sh --bootstrap-server ${kafka}:${port} --create --topic ${topic} --partitions ${partitions} --replication-factor ${replicas} 

		echo "Cola creada!"
		cd ${RAIZ}
		echo -e "\n\n"

    elif [ $opcion -eq 4 ]; then
		cd ${RAIZ}

		cd ${KAFKA_HOME}
		kafka="localhost"
		port="9092"

		read -p "(default: localhost) Ingresa el servidor de kafka: " kafka_input
		read -p "(default: 9092) Ingresa el puerto de kafka: " port_input

		kafka="${kafka_input:-localhost}"  # Usar el valor ingresado o el predeterminado si está vacío
		port="${port_input:-9092}"          # Usar el valor ingresado o el predeterminado si está vacío

		echo -e "\n\tListado de colas del servidor kafka:"

		bin/kafka-topics.sh --list --bootstrap-server $kafka:$port
		cd ${RAIZ}
		echo -e "\n\n"

	elif [ $opcion -eq 5 ]; then
		cd ${RAIZ}

		ZOOKEEPER_PID=$(ps aux | grep -i '[z]oo' | awk '{print $2}' | head -n 1)
		KAFKA_PID=$(ps aux | grep -i 'kafka\.Kafka' | grep -v grep | awk '{print $2}')

		kill -9 $KAFKA_PID $ZOOKEEPER_PID

		echo "Servidor kafka matado"
		cd ${RAIZ}
		echo -e "\n\n"

	elif [ $opcion -eq 6 ]; then
		cd ${RAIZ}

		kafka="localhost"
		port="9092"
		topic=""

		read -p "(default: localhost) Ingresa el servidor de kafka: " kafka_input
		read -p "(default: 9092) Ingresa el puerto de kafka: " port_input
		read -p "Ingresa el nombre del topico: " topic_input

		kafka="${kafka_input:-localhost}"  # Usar el valor ingresado o el predeterminado si está vacío
		port="${port_input:-9092}"          # Usar el valor ingresado o el predeterminado si está vacío
		topic="${topic_input}"              # Usar el valor ingresado sin predeterminado
		echo "Abre 2 terminales y ejecuta:"
		cd ${KAFKA_HOME}

		echo -e "\n\tCreacion del consumer:"
		echo -e "bin/kafka-console-consumer.sh --topic ${topic}  --bootstrap-server ${kafka}:${port} --property print.key=true --property key.separator=\"-\""

		echo -e "\n\tCreacion del producer:"
		echo -e "bin/kafka-console-producer.sh --topic ${topic}  --bootstrap-server ${kafka}:${port}"


    elif [ $opcion -eq 0 ]; then
        break
    fi

done
